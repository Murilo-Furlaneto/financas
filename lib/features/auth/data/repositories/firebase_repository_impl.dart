import 'package:financas/core/result/result.dart';
import 'package:financas/features/auth/domain/repository/firebase_repository.dart';
import 'package:financas/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<void>> loginFirebase(String email, String senha) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);
      return const Success(null);
    } catch (e) {
      return Failure('Erro ao logar no Firebase: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> signUpFirebase(
      String nome, String email, String senha) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: senha);
      
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'nome': nome,
          'email': email,
        });
      }
      return const Success(null);
    } catch (e) {
      return Failure('Erro ao cadastrar no Firebase: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> exitAccountFirebase() async {
    try {
      await _firebaseAuth.signOut();
      return const Success(null);
    } catch (e) {
      return Failure('Erro ao sair da conta: ${e.toString()}');
    }
  }

  @override
  Future<Result<User>> getUserInformation() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) return const Failure('Usuário não logado');
      
      final doc = await _firestore.collection('users').doc(currentUser.uid).get();
      if (doc.exists) {
        return Success(User.fromMap(doc.data()!..addAll({'senha': ''})));
      }
      return const Failure('Dados do usuário não encontrados');
    } catch (e) {
      return Failure('Erro ao buscar informações: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> updateUser(User user) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) return const Failure('Usuário não logado');
      
      await _firestore.collection('users').doc(currentUser.uid).update(user.toMap());
      return const Success(null);
    } catch (e) {
      return Failure('Erro ao atualizar usuário: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> updatePassword(String novaSenha) async {
    try {
      await _firebaseAuth.currentUser?.updatePassword(novaSenha);
      return const Success(null);
    } catch (e) {
      return Failure('Erro ao atualizar senha: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Success(null);
    } catch (e) {
      return Failure('Erro ao enviar email: ${e.toString()}');
    }
  }

  @override
  Future<Result<User>> getCurrentUser() async {
    return getUserInformation();
  }
}
