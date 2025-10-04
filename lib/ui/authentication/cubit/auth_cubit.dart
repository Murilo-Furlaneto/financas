import 'package:financas/data/repositories/firebase/firebase_repository.dart';
import 'package:financas/data/repositories/user_repository.dart';
import 'package:financas/domain/model/user/user_model.dart';
import 'package:financas/ui/authentication/cubit/auth_cubit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthCubitState> {
  final UserRepository userRepository;
  final FirebaseRepository firebaseRepository;

  AuthCubit(this.userRepository, this.firebaseRepository)
      : super(AuthInitial());

  User _user = User(nome: '', email: '', senha: '');

  User get user => _user;

  Future<void> loginFirebase(
      String email, String senha, BuildContext context) async {
    emit(AuthLoading());
    try {
      await firebaseRepository.loginFirebase(email, senha, context);
      final user = await firebaseRepository.getCurrentUser();
      user.senha = senha;
      await userRepository.saveUser(user);
      _user = user;
      emit(AuthLoaded(user));
    } catch (e) {
      emit(AuthError('Erro ao fazer login: ${e.toString()}'));
      throw Exception('Erro ao fazer login: ${e.toString()}');
    }
  }

  Future<User?> getUser() async {
    emit(AuthLoading());
    try {
      final user = await userRepository.getUser();
      if (user == null) {
        emit(AuthError('Nenhum usuário encontrado'));
        return null;
      }
      _user = user;
      emit(AuthLoaded(user));
      return user;
    } catch (e) {
      emit(AuthError('Erro ao carregar as informações do usuário'));
      throw Exception('Erro ao carregar as informações do usuário');
    }
  }

  Future<void> saveUser(User user) async {
    emit(AuthLoading());
    try {
      await userRepository.saveUser(user);
      _user = user;
      emit(AuthLoaded(user));
    } catch (e) {
      emit(AuthError('Erro ao salvar o usuário'));
      throw Exception('Erro ao salvar o usuário');
    }
  }

  Future<void> updateUser(User user) async {
    emit(AuthLoading());
    try {
      await firebaseRepository.updateUser(user);
      await userRepository.updateUser(user);
      _user = user;
      emit(AuthLoaded(user));
    } on Exception {
      emit(AuthError('Erro ao atualizar as informações do usuário'));
      throw Exception('Erro ao atualizar as informações do usuário');
    } catch (e) {
      emit(AuthError(
          'Erro ao atualizar as informações do usuário: ${e.toString()}'));
      throw Exception(
          'Erro ao atualizar as informações do usuário: ${e.toString()}');
    }
  }

  Future<void> updatePassword(String newPassword) async {
    emit(AuthLoading());

    try {
      await firebaseRepository.updatePassword(newPassword);
      _user = _user.copyWith(senha: newPassword);
      await userRepository.updateUser(_user);
      emit(AuthLoaded(_user));
    } on Exception {
      emit(AuthError('Erro ao atualizar a senha'));
      throw Exception('Erro ao atualizar a senha');
    } catch (e) {
      throw Exception('Erro ao atualizar a senha');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthLoading());
    try {
      await firebaseRepository.sendPasswordResetEmail(email);
      emit(AuthPasswordResetEmailSent());
    } on Exception {
      emit(AuthError('Erro ao enviar o email de recuperação de senha'));
      throw Exception('Erro ao enviar o email de recuperação de senha');
    } catch (e) {
      throw Exception('Erro ao enviar o email de recuperação de senha');
    }
  }

  Future<User> getFirebaseCurrentUser() async {
    emit(AuthLoading());
    try {
      final user = await firebaseRepository.getCurrentUser();
      emit(AuthLoaded(user));
      return user;
    } on Exception {
      emit(AuthError('Erro ao obter as informações do usuário'));
      throw Exception('Erro ao obter as informações do usuário');
    } catch (e) {
      emit(AuthError(
          'Erro ao obter as informações do usuário: ${e.toString()}'));
      throw Exception(
          'Erro ao obter as informações do usuário: ${e.toString()}');
    }
  }
}
