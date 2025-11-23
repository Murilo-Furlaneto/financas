import 'package:financas/core/errors/app_exception.dart';
import 'package:financas/core/errors/firebase/firebase_exception.dart.dart';
import 'package:financas/data/repositories/firebase/firebase_repository.dart';
import 'package:financas/data/services/firebase_service.dart';
import 'package:financas/domain/entities/user/user_entity.dart' as user_entity;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseService firebaseService;

  FirebaseRepositoryImpl(this.firebaseService);

  @override
  Future<void> loginFirebase(String email, String senha, BuildContext context) async {
    try {
      await firebaseService.loginFirebase(email, senha);
    } on firebase_auth.FirebaseAuthException catch (e) {
      final appError = FirebaseAuthException.fromFirebase(e);
      throw appError; 
    } catch (e, stackTrace) {
      developer.log('Erro inesperado no login', error: e, stackTrace: stackTrace);
      const error = UnknownException('Falha ao fazer login. Tente novamente.');
      throw error;
    }
  }

  @override
  Future<void> signUpFirebase(String nome, String email, String senha) async {
    try {
      await firebaseService.signUpFirebase(nome, email, senha);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FirebaseAuthException.fromFirebase(e);
    } catch (e, stackTrace) {
      developer.log('Erro no cadastro', error: e, stackTrace: stackTrace);
      throw UnknownException('Erro ao criar conta: ${e.toString()}');
    }
  }

  @override
  Future<void> exitAccoutnFirebase() async {
    try {
      await firebaseService.exitAccountFirebase();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FirebaseAuthException.fromFirebase(e);
    } catch (e, stackTrace) {
      developer.log('Erro no logout', error: e, stackTrace: stackTrace);
      throw const UnknownException('Erro ao sair da conta');
    }
  }

  @override
  Future<user_entity.User> getUserInformation() async {
    final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      throw const AuthException('Usuário não está autenticado');
    }

    try {
      return user_entity.User(
        nome: firebaseUser.displayName ?? 'Usuário',
        email: firebaseUser.email ?? '',
        senha: '',
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FirebaseAuthException.fromFirebase(e);
    } catch (e) {
      throw const UnknownException('Erro ao carregar dados do usuário');
    }
  }

  @override
  Future<void> updateUser(user_entity.User user) async {
    final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      throw const AuthException('Usuário não autenticado');
    }

    try {
      final futures = <Future>[];

      if (user.nome != firebaseUser.displayName) {
        futures.add(firebaseUser.updateDisplayName(user.nome));
      }
      if (user.email != firebaseUser.email) {
        futures.add(firebaseUser.updateEmail(user.email));
      }

      if (futures.isNotEmpty) {
        await Future.wait(futures);
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FirebaseAuthException.fromFirebase(e);
    } catch (e) {
      throw const UnknownException('Falha ao atualizar perfil');
    }
  }

  @override
  Future<void> updatePassword(String novaSenha) async {
    final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      throw const AuthException('Usuário não autenticado');
    }

    try {
      await firebaseUser.updatePassword(novaSenha);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FirebaseAuthException.fromFirebase(e);
    } catch (e) {
      throw const UnknownException('Erro ao alterar senha. Faça login novamente.');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await firebase_auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FirebaseAuthException.fromFirebase(e);
    } catch (e) {
      throw const UnknownException('Erro ao enviar e-mail de recuperação');
    }
  }

  @override
  Future<user_entity.User> getCurrentUser() async {
    final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

    return user_entity.User(
      nome: firebaseUser!.displayName ?? 'Usuário',
      email: firebaseUser.email ?? '',
      senha: '',
    );
  }
}