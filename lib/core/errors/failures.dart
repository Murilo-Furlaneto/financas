abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Erro no servidor']) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Erro de autenticação']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Dados inválidos']) : super(message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure([String message = 'Sem conexão com a internet']) : super(message);
}
