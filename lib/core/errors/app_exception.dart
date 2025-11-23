sealed class AppException implements Exception {
  const AppException(this.code, this.message);
  final String code;
  final String message;

  @override
  String toString() => 'AppException($code): $message';
}

class NetworkException extends AppException {
  const NetworkException(String message) : super('network', message);
}

class ServerException extends AppException {
  const ServerException(String message) : super('server', message);
}

class AuthException extends AppException {
  const AuthException(String message) : super('auth', message);
}

class DatabaseException extends AppException {
  const DatabaseException(String message) : super('database', message);
}

class UnknownException extends AppException {
  const UnknownException(String message) : super('unknown', message);
}