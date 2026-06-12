/// Tokens returned by a desktop browser OAuth flow.
typedef GoogleDesktopTokens = ({String? idToken, String? accessToken});

/// Stub used on platforms without `dart:io` (Web). The real loopback-based
/// implementation lives in `windows_google_auth.dart` and is selected via a
/// conditional import.
Future<GoogleDesktopTokens> signInWithGoogleDesktop({
  required String clientId,
  required String clientSecret,
}) {
  throw UnsupportedError(
    'Desktop Google sign-in is not available on this platform.',
  );
}
