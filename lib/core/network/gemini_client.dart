import 'package:dio/dio.dart';
import 'package:remind_ai/core/errors/app_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemini_client.g.dart';

const _kEndpoint =
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent';

@Riverpod(keepAlive: true)
GeminiClient geminiClient(Ref ref) {
  const apiKey = String.fromEnvironment('GEMINI_API_KEY');
  if (apiKey.isEmpty) {
    throw const AuthException(
      'GEMINI_API_KEY is not set. '
      'Pass it at build time: --dart-define=GEMINI_API_KEY=<your_key>',
    );
  }
  return GeminiClient(
    Dio(
      BaseOptions(
        headers: {'x-goog-api-key': apiKey, 'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
      ),
    ),
  );
}

class GeminiClient {
  const GeminiClient(this._dio);

  final Dio _dio;

  Future<String> generate({
    required String prompt,
    required String systemInstruction,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _kEndpoint,
        data: {
          'systemInstruction': {
            'parts': [
              {'text': systemInstruction},
            ],
          },
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {'temperature': 0.7, 'maxOutputTokens': 512},
        },
      );

      final text = _extractText(response.data);
      if (text == null || text.trim().isEmpty) {
        throw const NetworkException('Gemini returned an empty response.');
      }
      return text.trim();
    } on DioException catch (e) {
      final serverMessage = e.response?.data?['error']?['message'] as String?;
      throw NetworkException(
        serverMessage ?? e.message ?? 'Gemini request failed.',
        statusCode: e.response?.statusCode,
      );
    }
  }

  String? _extractText(Map<String, dynamic>? data) {
    final candidates = data?['candidates'] as List<dynamic>?;
    final parts =
        candidates?.firstOrNull?['content']?['parts'] as List<dynamic>?;
    return parts?.firstOrNull?['text'] as String?;
  }
}
