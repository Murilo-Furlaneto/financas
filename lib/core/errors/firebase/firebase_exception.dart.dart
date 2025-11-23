import '../app_exception.dart';

class FirebaseAuthException extends AuthException {
  const FirebaseAuthException(String code, String message)
      : super('Firebase Auth: $code - $message');

  factory FirebaseAuthException.fromFirebase(Exception e) {
    if (e is FirebaseAuthException) {
      return FirebaseAuthException(
        e.code,
        _firebaseCodeToMessage[e.code] ?? e.message ?? 'Erro de autenticação',
      );
    }
    return FirebaseAuthException('unknown', e.toString());
  }
}

const Map<String, String> _firebaseCodeToMessage = {
  'weak-password': 'A senha é muito fraca (mínimo 6 caracteres)',
  'email-already-in-use': 'Este e-mail já está sendo usado',
  'user-not-found': 'Usuário não encontrado',
  'wrong-password': 'Senha incorreta',
  'invalid-email': 'E-mail inválido',
  'user-disabled': 'Esta conta foi desativada',
  'too-many-requests': 'Muitas tentativas. Tente novamente mais tarde',
  'operation-not-allowed': 'Operação não permitida',
  'network-request-failed': 'Sem conexão com a internet',
};