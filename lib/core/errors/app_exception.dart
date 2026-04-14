sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => 'AppExceptio: $message';
}

class NetworkException extends AppException {
  const NetworkException(String message) : super(message);
}

class ServerException extends AppException {
  const ServerException(String message) : super(message);
}

class AuthException extends AppException {
  const AuthException(String message) : super(message);
}

class DatabaseException extends AppException {
  const DatabaseException(String message) : super(message);
}

class UnknownException extends AppException {
  const UnknownException(String message) : super(message);
}