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
    emit(AuthLoading());
    final result = await _loginUseCase.execute(email, senha);

    if (result is Success<User>) {
      _user = result.data;
      emit(AuthLoaded(result.data));
    } else if (result is Failure<User>) {
      emit(AuthError(result.message));
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await _signUpUseCase.execute(
      name: name,
      email: email,
      password: password,
    );

    if (result is Success) {
      final user = User(nome: name, email: email, senha: password);
      _user = user;
      emit(AuthLoaded(user));
    } else if (result is Failure) {
      emit(AuthError(result.message));
    }
  }

  Future<User?> getUser() async {
    emit(AuthLoading());
    final result = await _getUserUseCase.execute();
    if (result is Success<User?>) {
      if (result.data == null) {
        emit(AuthError('Nenhum usuário encontrado'));
        return null;
      }
      _user = result.data!;
      emit(AuthLoaded(result.data!));
      return result.data;
    } else if (result is Failure<User?>) {
      emit(AuthError(result.message));
      return null;
    }
    return null;
  }

  Future<void> saveUser(User user) async {
    emit(AuthLoading());
    final result = await userRepository.saveUser(user);
    if (result is Success) {
      _user = user;
      emit(AuthLoaded(user));
    } else if (result is Failure) {
      emit(AuthError((result).message));
    }
  }

  Future<void> updateUser(User user) async {
    emit(AuthLoading());
    final result = await _updateUserUseCase.execute(user);
    if (result is Success) {
      _user = user;
      emit(AuthLoaded(user));
    } else if (result is Failure) {
      emit(AuthError(result.message));
    }
  }

  Future<void> updatePassword(String newPassword) async {
    emit(AuthLoading());
    final result = await firebaseRepository.updatePassword(newPassword);
    if (result is Success) {
      final updatedUser = _user.copyWith(senha: newPassword);
      final localResult = await userRepository.updateUser(updatedUser);
      if (localResult is Success) {
        _user = updatedUser;
        emit(AuthLoaded(_user));
      } else if (localResult is Failure) {
        emit(AuthError(localResult.message));
      }
    } else if (result is Failure) {
      emit(AuthError(result.message));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthLoading());
    final result = await firebaseRepository.sendPasswordResetEmail(email);
    if (result is Success) {
      emit(AuthPasswordResetEmailSent());
    } else if (result is Failure) {
      emit(AuthError(result.message));
    }
  }

  Future<User?> getFirebaseCurrentUser() async {
    emit(AuthLoading());
    final result = await firebaseRepository.getCurrentUser();
    if (result is Success<User>) {
      emit(AuthLoaded(result.data));
      return result.data;
    } else if (result is Failure<User>) {
      emit(AuthError(result.message));
      return null;
    }
    return null;
  }
}
