import 'dart:developer';
import 'package:financas/core/result/result.dart';
import 'package:financas/features/auth/domain/entities/user_entity.dart';
import 'package:financas/features/auth/domain/repository/firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<void>> loginFirebase(String email, String senha) async {
    try {
      log('Attempting login for email: $email', name: 'FirebaseRepositoryImpl.loginFirebase');
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);
      log('Login successful', name: 'FirebaseRepositoryImpl.loginFirebase');
      return const Success(null);
    } catch (e) {
      log('Login failed: $e', name: 'FirebaseRepositoryImpl.loginFirebase', error: e);
      return Failure('Erro ao logar no Firebase: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> signUpFirebase(
      String nome, String email, String senha) async {
    try {
      log('Attempting signup for email: $email', name: 'FirebaseRepositoryImpl.signUpFirebase');
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: senha);
      
      if (userCredential.user != null) {
        log('User created in Auth, setting up Firestore document', name: 'FirebaseRepositoryImpl.signUpFirebase');
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'nome': nome,
          'email': email,
        });
      }
      log('Signup successful', name: 'FirebaseRepositoryImpl.signUpFirebase');
      return const Success(null);
    } catch (e) {
      log('Signup failed: $e', name: 'FirebaseRepositoryImpl.signUpFirebase', error: e);
      return Failure('Erro ao cadastrar no Firebase: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> exitAccountFirebase() async {
    try {
      log('Attempting sign out', name: 'FirebaseRepositoryImpl.exitAccountFirebase');
      await _firebaseAuth.signOut();
      log('Sign out successful', name: 'FirebaseRepositoryImpl.exitAccountFirebase');
      return const Success(null);
    } catch (e) {
      log('Sign out failed: $e', name: 'FirebaseRepositoryImpl.exitAccountFirebase', error: e);
      return Failure('Erro ao sair da conta: ${e.toString()}');
    }
  }

  @override
  Future<Result<User>> getUserInformation() async {
    try {
      log('Fetching user information', name: 'FirebaseRepositoryImpl.getUserInformation');
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        log('No user logged in', name: 'FirebaseRepositoryImpl.getUserInformation');
        return const Failure('Usuário não logado');
      }
      
      final doc = await _firestore.collection('users').doc(currentUser.uid).get();
      if (doc.exists) {
        log('User information fetched successfully', name: 'FirebaseRepositoryImpl.getUserInformation');
        return Success(User.fromMap(doc.data()!..addAll({'senha': ''})));
      }
      log('User document does not exist', name: 'FirebaseRepositoryImpl.getUserInformation');
      return const Failure('Dados do usuário não encontrados');
    } catch (e) {
      log('Failed to fetch user information: $e', name: 'FirebaseRepositoryImpl.getUserInformation', error: e);
      return Failure('Erro ao buscar informações: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> updateUser(User user) async {
    try {
      log('Updating user information', name: 'FirebaseRepositoryImpl.updateUser');
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        log('No user logged in', name: 'FirebaseRepositoryImpl.updateUser');
        return const Failure('Usuário não logado');
      }
      
      await _firestore.collection('users').doc(currentUser.uid).update(user.toMap());
      log('User information updated successfully', name: 'FirebaseRepositoryImpl.updateUser');
      return const Success(null);
    } catch (e) {
      log('Failed to update user: $e', name: 'FirebaseRepositoryImpl.updateUser', error: e);
      return Failure('Erro ao atualizar usuário: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> updatePassword(String novaSenha) async {
    try {
      log('Updating user password', name: 'FirebaseRepositoryImpl.updatePassword');
      await _firebaseAuth.currentUser?.updatePassword(novaSenha);
      log('Password updated successfully', name: 'FirebaseRepositoryImpl.updatePassword');
      return const Success(null);
    } catch (e) {
      log('Failed to update password: $e', name: 'FirebaseRepositoryImpl.updatePassword', error: e);
      return Failure('Erro ao atualizar senha: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    try {
      log('Sending password reset email to: $email', name: 'FirebaseRepositoryImpl.sendPasswordResetEmail');
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      log('Password reset email sent', name: 'FirebaseRepositoryImpl.sendPasswordResetEmail');
      return const Success(null);
    } catch (e) {
      log('Failed to send password reset email: $e', name: 'FirebaseRepositoryImpl.sendPasswordResetEmail', error: e);
      return Failure('Erro ao enviar email: ${e.toString()}');
    }
  }

  @override
  Future<Result<User>> getCurrentUser() async {
    log('Getting current user', name: 'FirebaseRepositoryImpl.getCurrentUser');
    return getUserInformation();
  }
}
