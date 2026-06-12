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
    : super('Daily interpretation limit reached.');
}

/// Raised when a non-Pro user attempts to run a Pro-only interpretation style.
final class ProRequiredException extends AppException {
  const ProRequiredException()
    : super('This interpretation style requires Pro.');
}

/// Raised when submissions arrive faster than the minimum allowed interval.
/// Light client-side friction against scripted/bot abuse.
final class RateLimitException extends AppException {
  const RateLimitException()
    : super('You are going too fast. Wait a moment and try again.');
}

final class PurchaseException extends AppException {
  const PurchaseException(super.message);
}
