import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:remind_ai/firebase_options.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_service.g.dart';

/// reCAPTCHA v3 site key for App Check on web. Public by design (it is embedded
/// in the client); security comes from App Check enforcement + Firestore rules.
/// Overridable per environment via --dart-define.
const String _kRecaptchaSiteKey = String.fromEnvironment(
  'RECAPTCHA_SITE_KEY',
  defaultValue: '6Le7rhstAAAAAIPWaE4xgwSt2vtJpc91xRANnxzU',
);

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
    if (kIsWeb) {
      await _completeWebRedirectSignIn();
    }
    await _activateAppCheck();
    return true;
  } catch (error, stackTrace) {
    debugPrint('Firebase: initialization failed ($error).');
    if (kDebugMode) debugPrintStack(stackTrace: stackTrace);
    return false;
  }
}

/// After a Google redirect sign-in, the app reloads on the same URL. This
/// completes the pending credential exchange (must run once per page load).
Future<void> _completeWebRedirectSignIn() async {
  try {
    final result = await FirebaseAuth.instance.getRedirectResult();
    if (result.user != null) {
      debugPrint('Firebase: redirect sign-in completed.');
    }
  } on FirebaseAuthException catch (error) {
    debugPrint(
      'Firebase: redirect sign-in failed (${error.code}) — ${error.message}',
    );
  } catch (error) {
    debugPrint('Firebase: redirect sign-in failed ($error).');
  }
}

/// Activates App Check so Firebase AI Logic calls are attested. Providers exist
/// only for web (reCAPTCHA v3) and Android (Play Integrity); other platforms
/// are skipped. Non-fatal: enforcement is what actually blocks unattested
/// calls, and we keep that off until verified.
Future<void> _activateAppCheck() async {
  if (!kIsWeb && defaultTargetPlatform != TargetPlatform.android) return;
  try {
    // ignore: deprecated_member_use
    await FirebaseAppCheck.instance.activate(
      // ignore: deprecated_member_use
      webProvider: ReCaptchaV3Provider(_kRecaptchaSiteKey),
      // ignore: deprecated_member_use
      androidProvider: kDebugMode
          ? AndroidProvider.debug
          : AndroidProvider.playIntegrity,
    );
  } catch (error) {
    debugPrint('App Check: activation failed ($error).');
  }
}
