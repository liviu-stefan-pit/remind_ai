sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => 'AppException($message)';
}

final class NetworkException extends AppException {
  const NetworkException(super.message, {this.statusCode});

  final int? statusCode;
}

final class AuthException extends AppException {
  const AuthException(super.message);
}

final class DailyLimitException extends AppException {
  const DailyLimitException()
    : super('Daily free interpretation limit reached.');
}
