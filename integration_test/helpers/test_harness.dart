import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:remind_ai/app.dart';
import 'package:remind_ai/config/access_tier/access_tier.dart';
import 'package:remind_ai/core/errors/app_exception.dart';
import 'package:remind_ai/core/network/gemini_client.dart';
import 'package:remind_ai/core/services/firebase_service.dart';
import 'package:remind_ai/core/services/usage_quota_service.dart';
import 'package:remind_ai/features/dreams/data/models/dream_entry.dart';
import 'package:remind_ai/hive/hive.dart';
import 'package:remind_ai/hive/hive_registrar.g.dart';

/// Marker string returned by [FakeGeminiClient] so tests can assert on results.
const kFakeInterpretationMarker = 'FAKE_INTERPRETATION_MARKER';

const _kSampleDreamText =
    'I was flying over a city of glass towers under a violet moon.';

/// Returns canned dream text long enough to pass form validation (20+ chars).
String get sampleDreamText => _kSampleDreamText;

/// Fake Gemini client that returns deterministic interpretations offline.
class FakeGeminiClient extends GeminiClient {
  const FakeGeminiClient({this.shouldFail = false});

  final bool shouldFail;

  @override
  Future<String> generate({
    required String prompt,
    required String systemInstruction,
    String model = kStandardModel,
    int maxOutputTokens = 512,
  }) async {
    if (shouldFail) {
      throw const NetworkException('Gemini request failed.');
    }
    return '$kFakeInterpretationMarker '
        'Your dream about "$prompt" suggests a longing for freedom.';
  }
}

/// Quota service that never throttles or blocks submissions during E2E runs.
class PermissiveUsageQuotaService extends UsageQuotaService {
  PermissiveUsageQuotaService() : super(Hive.box<String>(kPrefsBox));

  @override
  bool isThrottled() => false;

  @override
  bool canSubmit(AccessTier tier) => true;

  @override
  Future<void> markSubmitAttempt() async {}

  @override
  Future<void> recordUsage() async {}
}

Directory? _tempDir;
bool _hiveReady = false;

/// Initializes Hive into an isolated temp directory (once per test file).
Future<void> initHiveForTests() async {
  if (_hiveReady) return;

  _tempDir = await Directory.systemTemp.createTemp('remind_ai_e2e');
  Hive.init(_tempDir!.path);
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapters();
  }
  await Hive.openBox<String>(kPrefsBox);
  await Hive.openBox<DreamEntry>(kDreamsBox);
  _hiveReady = true;
}

/// Clears persisted boxes between tests for a clean slate.
Future<void> resetHiveBoxes() async {
  await Hive.box<String>(kPrefsBox).clear();
  await Hive.box<DreamEntry>(kDreamsBox).clear();
}

/// Marks onboarding complete so tests can skip straight to the home screen.
Future<void> seedOnboardingComplete() async {
  final prefs = Hive.box<String>(kPrefsBox);
  await prefs.put('onboardingSeen', 'true');
  await prefs.put('ageConfirmed', 'true');
}

Future<void> disposeHiveForTests() async {
  if (!_hiveReady) return;
  await Hive.close();
  if (_tempDir case final dir? when dir.existsSync()) {
    await dir.delete(recursive: true);
  }
  _tempDir = null;
  _hiveReady = false;
}

/// Pumps [RemindAiApp] with Firebase disabled and a fake Gemini client.
Future<void> pumpTestApp(
  WidgetTester tester, {
  GeminiClient? geminiClient,
}) async {
  await initHiveForTests();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        firebaseReadyProvider.overrideWithValue(false),
        geminiClientProvider.overrideWithValue(
          geminiClient ?? const FakeGeminiClient(),
        ),
        usageQuotaServiceProvider.overrideWithValue(
          PermissiveUsageQuotaService(),
        ),
      ],
      child: const RemindAiApp(),
    ),
  );
}

/// Pumps until [finder] matches or [timeout] elapses. Avoids [pumpAndSettle]
/// which times out on continuous QuietSky / Rive animations.
Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 15),
  Duration step = const Duration(milliseconds: 100),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(step);
    if (finder.evaluate().isNotEmpty) return;
  }
  fail('Timed out waiting for $finder');
}

/// Ensures a tall enough viewport so dream-input CTAs are reachable.
Future<void> configureLargeTestSurface(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(1280, 1024));
}

/// Scrolls [finder] into view and taps it.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  final scrollables = find.byType(Scrollable);
  if (scrollables.evaluate().isNotEmpty) {
    await tester.scrollUntilVisible(
      finder,
      250,
      scrollable: scrollables.last,
    );
  }
  await tester.ensureVisible(finder);
  await tester.pump(const Duration(milliseconds: 100));
  await tester.tap(finder);
  await tester.pump(const Duration(milliseconds: 100));
}

/// Submits the dream form via the desktop Ctrl+Enter shortcut.
Future<void> submitDreamForm(WidgetTester tester) async {
  await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
  await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
  await tester.pump(const Duration(milliseconds: 100));
}

/// Shared E2E setup: binding, large surface, fresh Hive boxes.
Future<void> setUpE2E(WidgetTester tester) async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await configureLargeTestSurface(tester);
  await initHiveForTests();
  await resetHiveBoxes();
}

/// Waits for the splash delay (1.5 s) then for home or onboarding content.
Future<void> pumpPastSplash(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 1600));
  await pumpUntilFound(
    tester,
    find.byType(MaterialApp),
  );
}
