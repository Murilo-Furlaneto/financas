import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  Future<void> loginFirebase(String email, String senha) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: senha);
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            throw Exception('Usuário não encontrado. Verifique o email.');
          case 'wrong-password':
            throw Exception('Senha incorreta. Tente novamente.');
          case 'invalid-email':
            throw Exception('O formato do email é inválido.');
          default:
            throw Exception('Erro desconhecido: ${e.message}');
        }
      } else {
        throw Exception('Ocorreu um erro inesperado.');
      }
    }
  }

  Future<void> signUpFirebase(
      String name, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.updateDisplayName(name);

      await userCredential.user?.reload();
    } catch (e) {
      throw Exception("Erro ao criar usuário: $e");
    }
  }

  Future<String> exitAccountFirebase() async {
    try {
      await FirebaseAuth.instance.signOut();
      return 'Você saiu da conta com sucesso!';
    } catch (e) {
      return 'Erro ao sair da conta: ${e.toString()}';
    }
  }
}
