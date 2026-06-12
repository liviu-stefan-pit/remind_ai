import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:remind_ai/app.dart';
import 'package:remind_ai/core/services/firebase_service.dart';
import 'package:remind_ai/hive/hive.dart';

Future<void> main() async {
  await bootstrap();
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  try {
    await initHive();
  } catch (error, stackTrace) {
    debugPrint('Fatal: local storage failed to initialize: $error');
    if (kDebugMode) debugPrintStack(stackTrace: stackTrace);
    runApp(const _StorageInitErrorApp());
    return;
  }

  // Optional backend: succeeds only with real Firebase credentials. The app
  // runs fully (Free tier, local-only) when this returns false.
  final firebaseReady = await initFirebase();

  runApp(
    ProviderScope(
      overrides: [firebaseReadyProvider.overrideWithValue(firebaseReady)],
      child: const RemindAiApp(),
    ),
  );
}

/// Shown only if local storage cannot be initialized even after the
/// self-healing reset in [initHive]. Keeps the app from white-screening.
class _StorageInitErrorApp extends StatelessWidget {
  const _StorageInitErrorApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF07061A),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.cloud_off_rounded, color: Colors.white70, size: 48),
                SizedBox(height: 16),
                Text(
                  "REMind-Ai couldn't open its local storage.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Please restart the app. If this keeps happening, '
                  'reinstalling will reset local data.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
