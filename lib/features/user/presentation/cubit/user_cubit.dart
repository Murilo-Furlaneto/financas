import 'dart:async';
import 'package:financas/features/auth/domain/entities/user_entity.dart';
import 'package:financas/features/user/presentation/cubit/user_cubit_state.dart';
import 'package:financas/features/user/domain/usecases/get_user_usecase.dart';
import 'package:financas/features/user/domain/usecases/save_user_usecase.dart';
import 'package:financas/core/result/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  final GetUserUseCase _getUserUseCase;
  final SaveUserUseCase _saveUserUseCase;

  UserCubit(
    this._getUserUseCase,
    this._saveUserUseCase,
  ) : super(UserInitial());

  Future<User?> getUser() async {
    emit(UserLoading());
    final result = await _getUserUseCase.execute();
    
    if (result is Success<User?>) {
      if (result.data != null) {
        emit(UserLoaded(result.data!));
        return result.data;
      } else {
        emit(UserError('Usuário não encontrado'));
        return null;
      }
    } else if (result is Failure) {
      emit(UserError((result as Failure).message));
      return null;
    }
    return null;
  }

  Future<void> saveUser(User user) async {
    emit(UserLoading());
    final result = await _saveUserUseCase.execute(user);
    if (result is Success) {
      emit(UserLoaded(user));
    } else if (result is Failure) {
      emit(UserError(result.message));
    }
  }
}
