abstract class AppException implements Exception {
  const AppException(this.message, {this.statusCode, this.cause});

  final String message;
  final int? statusCode;
  final Object? cause;

  @override
  String toString() {
    return '$runtimeType(message: $message, statusCode: $statusCode)';
  }
}

class NetworkException extends AppException {
  const NetworkException({
    String message = 'No internet connection.',
    Object? cause,
  }) : super(message, cause: cause);
}

class RequestTimeoutException extends AppException {
  const RequestTimeoutException({
    String message = 'The request timed out.',
    Object? cause,
  }) : super(message, cause: cause);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    String message = 'You are not authorized to perform this action.',
    Object? cause,
  }) : super(message, statusCode: 401, cause: cause);
}

class NotFoundException extends AppException {
  const NotFoundException({
    String message = 'The requested resource was not found.',
    Object? cause,
  }) : super(message, statusCode: 404, cause: cause);
}

class ServerException extends AppException {
  const ServerException({
    String message = 'A server error occurred.',
    int? statusCode,
    Object? cause,
  }) : super(message, statusCode: statusCode, cause: cause);
}

class ParsingException extends AppException {
  const ParsingException({
    String message = 'The response could not be processed.',
    Object? cause,
  }) : super(message, cause: cause);
}

class UnknownApiException extends AppException {
  const UnknownApiException({
    String message = 'An unexpected error occurred.',
    int? statusCode,
    Object? cause,
  }) : super(message, statusCode: statusCode, cause: cause);
}
