import 'package:financas/core/validation/email_validator.dart';
import 'package:financas/core/validation/name_validator.dart';
import 'package:financas/core/validation/password_validator.dart';
import 'package:financas/data/repositories/firebase/firebase_repository.dart';
import 'package:financas/data/repositories/user/user_repository.dart';
import 'package:financas/domain/entities/user/user_entity.dart';
import 'package:financas/domain/usecases/auth/login_usecase.dart';
import 'package:financas/domain/usecases/auth/sign_up_usecase.dart';
import 'package:financas/ui/authentication/cubit/auth_cubit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthCubitState> {
  final UserRepository userRepository;
  final FirebaseRepository firebaseRepository;
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;

  AuthCubit(this.userRepository, this.firebaseRepository)
      : _loginUseCase = LoginUseCase(
          firebaseRepository: firebaseRepository,
          userRepository: userRepository,
          emailValidator: EmailValidator(),
          passwordValidator: PasswordValidator(),
        ),
        _signUpUseCase = SignUpUseCase(
          firebaseRepository: firebaseRepository,
          userRepository: userRepository,
          nameValidator: NameValidator(),
          emailValidator: EmailValidator(),
          passwordValidator: PasswordValidator(),
        ),
        super(AuthInitial());

  User _user = User(nome: '', email: '', senha: '');

  User get user => _user;

  Future<void> loginFirebase(
      String email, String senha, BuildContext context) async {
    emit(AuthLoading());
    try {
      final user = await _loginUseCase.execute(email, senha, context);
      _user = user;
      emit(AuthLoaded(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      rethrow;
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await _signUpUseCase.execute(
        name: name,
        email: email,
        password: password,
      );
      final user = User(nome: name, email: email, senha: password);
      _user = user;
      emit(AuthLoaded(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      rethrow;
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
