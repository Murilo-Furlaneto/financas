import 'package:financas/core/errors/error.dart';
import 'package:financas/data/repositories/firebase/firebase_repository.dart';
import 'package:financas/data/services/firebase_service.dart';
import 'package:financas/domain/model/user/user_model.dart' as user;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseService firebaseService;

  FirebaseRepositoryImpl(this.firebaseService);

  @override
  Future<void> loginFirebase(
      String email, String senha, BuildContext context) async {
    try {
      await firebaseService.loginFirebase(email, senha,);
    } on Exception {
      FirebaseError("Erro ao fazer o login");
    } catch (e) {
      // Log the error to a logging service
    }
  }

  @override
  Future<void> signUpFirebase(String nome, String email, String senha) async {
    try {
      await firebaseService.signUpFirebase(nome, email, senha);
    } on Exception {
      FirebaseError("Erro ao fazer o cadastro");
    } catch (e) {
      // Log the error to a logging service
    }
  }

  @override
  Future<void> exitAccoutnFirebase() async {
    try {
      await firebaseService.exitAccountFirebase();
    } on Exception {
      FirebaseError("Erro ao fazer logout Firebase");
    } catch (e) {
      // Log the error to a logging service
    }
  }

  @override
  Future<user.User> getUserInformation() async {
    try {
      User firebaseUser = FirebaseAuth.instance.currentUser!;
      user.User userModel =
          user.User(nome: firebaseUser.displayName!, email: firebaseUser.email!, senha: '');
      return userModel;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Erro ao obter informações do usuário');
    }
  }

  @override
  Future<void> updateUser(user.User user) async {
    try {
      User userFirebase = FirebaseAuth.instance.currentUser!;

      // Comparar nome e email para verificar se há mudanças
      if (user.nome != userFirebase.displayName) {
        await FirebaseAuth.instance.currentUser!.updateDisplayName(user.nome);
      }

      if (user.email != userFirebase.email) {
        await FirebaseAuth.instance.currentUser!.updateEmail(user.email);
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Erro ao atualizar informações do usuário');
    }
  }

  @override
  Future<void> updatePassword(String novaSenha) async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      await user.updatePassword(novaSenha);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<user.User> getCurrentUser() async {
    User firebaseUser = FirebaseAuth.instance.currentUser!;
      user.User userModel =
          user.User(nome: firebaseUser.displayName!, email: firebaseUser.email!, senha: '');
      return userModel;
  }
}
