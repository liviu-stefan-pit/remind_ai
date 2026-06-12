import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:remind_ai/core/errors/app_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'windows_google_auth_stub.dart'
    if (dart.library.io) 'windows_google_auth.dart';

part 'auth_repository.g.dart';

const _kDesktopClientId = String.fromEnvironment('GOOGLE_DESKTOP_CLIENT_ID');
const _kDesktopClientSecret = String.fromEnvironment(
  'GOOGLE_DESKTOP_CLIENT_SECRET',
);

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepository();

/// Wraps FirebaseAuth with a per-platform Google Sign-In strategy:
///   - Web: `signInWithPopup`
///   - Android: native `google_sign_in` -> Firebase credential
///   - Windows: browser loopback OAuth -> Firebase credential
class AuthRepository {
  AuthRepository();

  FirebaseAuth get _auth => FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      await _auth.signInWithPopup(GoogleAuthProvider());
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.windows) {
      if (_kDesktopClientId.isEmpty || _kDesktopClientSecret.isEmpty) {
        throw const AuthException(
          'Windows Google sign-in is not configured. Pass '
          'GOOGLE_DESKTOP_CLIENT_ID and GOOGLE_DESKTOP_CLIENT_SECRET at build '
          'time.',
        );
      }
      final tokens = await signInWithGoogleDesktop(
        clientId: _kDesktopClientId,
        clientSecret: _kDesktopClientSecret,
      );
      if (tokens.idToken == null && tokens.accessToken == null) {
        throw const AuthException('Google sign-in failed.');
      }
      final credential = GoogleAuthProvider.credential(
        idToken: tokens.idToken,
        accessToken: tokens.accessToken,
      );
      await _auth.signInWithCredential(credential);
      return;
    }

    // Android / iOS / macOS via the native plugin.
    final googleUser = await GoogleSignIn(scopes: const ['email']).signIn();
    if (googleUser == null) return; // user cancelled
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    if (!kIsWeb && defaultTargetPlatform != TargetPlatform.windows) {
      try {
        await GoogleSignIn().signOut();
      } catch (_) {
        // Best effort; Firebase sign-out below is what matters.
      }
    }
    await _auth.signOut();
  }
}
