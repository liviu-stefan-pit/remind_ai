import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:remind_ai/firebase_options.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_service.g.dart';

/// True only after [initFirebase] has successfully connected to a real
/// project. While `firebase_options.dart` still holds placeholder values (or
/// initialization fails), this stays false and every Firebase-backed feature
/// (auth, cloud sync) degrades gracefully instead of crashing.
@Riverpod(keepAlive: true)
bool firebaseReady(Ref ref) => throw UnimplementedError(
  'firebaseReadyProvider must be overridden in bootstrap()',
);

bool get _isPlaceholderConfig {
  try {
    return DefaultFirebaseOptions.currentPlatform.projectId.startsWith(
      'REPLACE_WITH',
    );
  } catch (_) {
    // Platform not configured at all (e.g. unsupported desktop target).
    return true;
  }
}

/// Initializes Firebase if real credentials are present. Returns whether the
/// app should consider Firebase available. Never throws.
Future<bool> initFirebase() async {
  if (_isPlaceholderConfig) {
    debugPrint(
      'Firebase: placeholder config detected — running without a backend. '
      'Run `flutterfire configure` to enable auth and cloud sync.',
    );
    return false;
  }
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return true;
  } catch (error, stackTrace) {
    debugPrint('Firebase: initialization failed ($error).');
    if (kDebugMode) debugPrintStack(stackTrace: stackTrace);
    return false;
  }
}
