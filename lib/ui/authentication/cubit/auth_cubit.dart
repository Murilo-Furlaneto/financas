import 'package:financas/core/helpers/shared_preferences/preferences_helper.dart';
import 'package:financas/data/repositories/firebase/firebase_repository_impl.dart';
import 'package:financas/domain/model/user/user_model.dart';
import 'package:financas/ui/authentication/cubit/auth_cubit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthCubitState> {
  AuthCubit(this.firebaseRepository, this.preferencesHelper)
      : super(AuthInitial());

  final FirebaseRepositoryImpl firebaseRepository;
  final SharedPreferencesHelper preferencesHelper;

  User _user = User(nome: '', email: '', senha: '');

  User get user => _user;

  Future<User?> getUser() async {
    emit(AuthLoading());
    try {
      final User? user = await preferencesHelper.getUser();
      if (user == null) {
        emit(AuthError('Nenhum usuário encontrado'));
        return null;
      }
      _user = user;
      emit(AuthLoaded(_user));
      return user;
    } catch (e) {
      emit(AuthError('Erro ao carregar as informações do usuário'));
      throw Exception('Erro ao carregar as informações do usuário');
    }
  }

  Future<void> saveUser(User user) async {
    emit(AuthLoading());
    try {
      await preferencesHelper.saveUser(user);
      _user = user;
      emit(AuthLoaded(_user));
    } on Exception {
      emit(AuthError('Erro ao salvar o usuário'));
      throw Exception('Erro ao salvar o usuário');
    } catch (e) {
      // Log the error
    }
  }

  Future<void> updateUser(User user) async {
    emit(AuthLoading());
    try {
      await firebaseRepository.updateUser(user);
      _user = user;
      emit(AuthLoaded(_user));
    } on Exception {
      emit(AuthError('Erro ao atualizar as informações do usuário'));
      throw Exception('Erro ao atualizar as informações do usuário');
    } catch (e) {
      // Log the error
    }
  }

  Future<void> updatePassword(String newPassword) async {
    emit(AuthLoading());
    try {
      await firebaseRepository.updatePassword(newPassword);
      emit(AuthLoaded(_user));
    } on Exception {
      emit(AuthError('Erro ao atualizar a senha'));
      throw Exception('Erro ao atualizar a senha');
    } catch (e) {
      // Log the error
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthLoading());
    try {
      await firebaseRepository.sendPasswordResetEmail(email);
      emit(AuthLoaded(_user));
    } on Exception {
      emit(AuthError('Erro ao enviar o email de recuperação de senha'));
      throw Exception('Erro ao enviar o email de recuperação de senha');
    } catch (e) {
      // Log the error
    }
  }
}
