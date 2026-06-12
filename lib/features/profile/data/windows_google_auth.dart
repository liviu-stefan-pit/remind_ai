import 'dart:io';

import 'package:dio/dio.dart';
import 'package:remind_ai/core/errors/app_exception.dart';
import 'package:url_launcher/url_launcher.dart';

/// Tokens returned by a desktop browser OAuth flow.
typedef GoogleDesktopTokens = ({String? idToken, String? accessToken});

/// Performs the Google "Desktop app" OAuth flow used on Windows (and other
/// desktops): opens the system browser for consent, captures the redirect on a
/// transient localhost server, then exchanges the authorization code for an
/// id/access token pair that Firebase can consume via
/// `GoogleAuthProvider.credential`.
///
/// The desktop client secret is not truly secret per Google's installed-app
/// guidance, so passing it from a --dart-define is acceptable here.
Future<GoogleDesktopTokens> signInWithGoogleDesktop({
  required String clientId,
  required String clientSecret,
}) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  final redirectUri = 'http://localhost:${server.port}';
  final state = _randomString(24);

  final authUrl = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
    'client_id': clientId,
    'redirect_uri': redirectUri,
    'response_type': 'code',
    'scope': 'openid email profile',
    'state': state,
  });

  if (!await launchUrl(authUrl, mode: LaunchMode.externalApplication)) {
    await server.close(force: true);
    throw const AuthException('Could not open the browser for sign-in.');
  }

  try {
    final request = await server.first.timeout(const Duration(minutes: 3));
    final params = request.uri.queryParameters;
    final code = params['code'];

    request.response
      ..statusCode = 200
      ..headers.contentType = ContentType.html
      ..write(
        '<html><body style="font-family:sans-serif;text-align:center;'
        'margin-top:80px"><h2>Signed in to REMind-Ai</h2>'
        '<p>You can close this window and return to the app.</p>'
        '</body></html>',
      );
    await request.response.close();

    if (params['state'] != state || code == null) {
      throw const AuthException('Google sign-in was cancelled or failed.');
    }

    final dio = Dio();
    final tokenResp = await dio.post<Map<String, dynamic>>(
      'https://oauth2.googleapis.com/token',
      options: Options(contentType: Headers.formUrlEncodedContentType),
      data: {
        'code': code,
        'client_id': clientId,
        'client_secret': clientSecret,
        'redirect_uri': redirectUri,
        'grant_type': 'authorization_code',
      },
    );
    final data = tokenResp.data ?? const <String, dynamic>{};
    return (
      idToken: data['id_token'] as String?,
      accessToken: data['access_token'] as String?,
    );
  } on DioException catch (e) {
    throw NetworkException(
      'Token exchange with Google failed.',
      statusCode: e.response?.statusCode,
    );
  } finally {
    await server.close(force: true);
  }
}

String _randomString(int length) {
  const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final rand = DateTime.now().microsecondsSinceEpoch;
  final buffer = StringBuffer();
  var seed = rand;
  for (var i = 0; i < length; i++) {
    seed = (seed * 1103515245 + 12345) & 0x7fffffff;
    buffer.write(chars[seed % chars.length]);
  }
  return buffer.toString();
}
