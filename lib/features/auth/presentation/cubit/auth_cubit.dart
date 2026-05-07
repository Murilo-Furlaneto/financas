import 'dart:developer';
import 'package:financas/core/result/result.dart';
import 'package:financas/features/auth/domain/entities/user_entity.dart';
import 'package:financas/features/auth/domain/repository/firebase_repository.dart';
import 'package:financas/features/auth/domain/usecases/login_usecase.dart';
import 'package:financas/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:financas/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:financas/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:financas/features/auth/presentation/cubit/auth_cubit_state.dart';
import 'package:financas/features/user/domain/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthCubitState> {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
  final GetUserUseCase _getUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final UserRepository userRepository;
  final FirebaseRepository firebaseRepository;

  AuthCubit(
    this._loginUseCase,
    this._signUpUseCase,
    this._getUserUseCase,
    this._updateUserUseCase,
    this.userRepository,
    this.firebaseRepository,
  ) : super(AuthInitial());

  User _user = User(nome: '', email: '', senha: '');

  User get user => _user;

  Future<void> loginFirebase(String email, String senha) async {
    log('Logging in with email: $email', name: 'AuthCubit.loginFirebase');
    emit(AuthLoading());
    final result = await _loginUseCase.execute(email, senha);

    if (result is Success<User>) {
      log('Login successful for: $email', name: 'AuthCubit.loginFirebase');
      _user = result.data;
      emit(AuthLoaded(result.data));
    } else if (result is Failure<User>) {
      log('Login failed: ${result.message}', name: 'AuthCubit.loginFirebase');
      emit(AuthError(result.message));
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    log('Signing up with email: $email', name: 'AuthCubit.signUp');
    emit(AuthLoading());
    final result = await _signUpUseCase.execute(
      name: name,
      email: email,
      password: password,
    );

    if (result is Success) {
      log('Signup successful for: $email', name: 'AuthCubit.signUp');
      final user = User(nome: name, email: email, senha: password);
      _user = user;
      emit(AuthLoaded(user));
    } else if (result is Failure) {
      log('Signup failed: ${result.message}', name: 'AuthCubit.signUp');
      emit(AuthError(result.message));
    }
  }

  Future<User?> getUser() async {
    log('Getting user', name: 'AuthCubit.getUser');
    emit(AuthLoading());
    final result = await _getUserUseCase.execute();
    if (result is Success<User?>) {
      if (result.data == null) {
        log('No user found', name: 'AuthCubit.getUser');
        emit(AuthError('Nenhum usuário encontrado'));
        return null;
      }
      log('User found: ${result.data!.email}', name: 'AuthCubit.getUser');
      _user = result.data!;
      emit(AuthLoaded(result.data!));
      return result.data;
    } else if (result is Failure<User?>) {
      log('Error getting user: ${result.message}', name: 'AuthCubit.getUser');
      emit(AuthError(result.message));
      return null;
    }
    return null;
  }

  Future<void> saveUser(User user) async {
    log('Saving user: ${user.email}', name: 'AuthCubit.saveUser');
    emit(AuthLoading());
    final result = await userRepository.saveUser(user);
    if (result is Success) {
      log('User saved successfully', name: 'AuthCubit.saveUser');
      _user = user;
      emit(AuthLoaded(user));
    } else if (result is Failure) {
      log('Error saving user: ${result.message}', name: 'AuthCubit.saveUser');
      emit(AuthError((result).message));
    }
  }

  Future<void> updateUser(User user) async {
    log('Updating user: ${user.email}', name: 'AuthCubit.updateUser');
    emit(AuthLoading());
    final result = await _updateUserUseCase.execute(user);
    if (result is Success) {
      log('User updated successfully', name: 'AuthCubit.updateUser');
      _user = user;
      emit(AuthLoaded(user));
    } else if (result is Failure) {
      log('Error updating user: ${result.message}', name: 'AuthCubit.updateUser');
      emit(AuthError(result.message));
    }
  }

  Future<void> updatePassword(String newPassword) async {
    log('Updating password', name: 'AuthCubit.updatePassword');
    emit(AuthLoading());
    final result = await firebaseRepository.updatePassword(newPassword);
    if (result is Success) {
      log('Firebase password updated, updating local database', name: 'AuthCubit.updatePassword');
      final updatedUser = _user.copyWith(senha: newPassword);
      final localResult = await userRepository.updateUser(updatedUser);
      if (localResult is Success) {
        log('Local password updated successfully', name: 'AuthCubit.updatePassword');
        _user = updatedUser;
        emit(AuthLoaded(_user));
      } else if (localResult is Failure) {
        log('Error updating local password: ${localResult.message}', name: 'AuthCubit.updatePassword');
        emit(AuthError(localResult.message));
      }
    } else if (result is Failure) {
      log('Error updating Firebase password: ${result.message}', name: 'AuthCubit.updatePassword');
      emit(AuthError(result.message));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    log('Sending password reset email to: $email', name: 'AuthCubit.sendPasswordResetEmail');
    emit(AuthLoading());
    final result = await firebaseRepository.sendPasswordResetEmail(email);
    if (result is Success) {
      log('Password reset email sent successfully', name: 'AuthCubit.sendPasswordResetEmail');
      emit(AuthPasswordResetEmailSent());
    } else if (result is Failure) {
      log('Error sending password reset email: ${result.message}', name: 'AuthCubit.sendPasswordResetEmail');
      emit(AuthError(result.message));
    }
  }

  Future<User?> getFirebaseCurrentUser() async {
    log('Getting current Firebase user', name: 'AuthCubit.getFirebaseCurrentUser');
    emit(AuthLoading());
    final result = await firebaseRepository.getCurrentUser();
    if (result is Success<User>) {
      log('Current user found: ${result.data.email}', name: 'AuthCubit.getFirebaseCurrentUser');
      emit(AuthLoaded(result.data));
      return result.data;
    } else if (result is Failure<User>) {
      log('Error getting current user: ${result.message}', name: 'AuthCubit.getFirebaseCurrentUser');
      emit(AuthError(result.message));
      return null;
    }
    return null;
  }
}
