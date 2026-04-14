import 'dart:async';
import 'package:financas/features/auth/domain/entities/user_entity.dart';
import 'package:financas/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:financas/features/user/presentation/cubit/user_cubit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  final AuthCubit authCubit;

  UserCubit(this.authCubit) : super(UserInitial());

  Future<User?> getUser() async {
    emit(UserLoading());
    try {
      final user = await authCubit.getUser();
      if (user != null) {
        emit(UserLoaded(user));
        return user;
      } else {
        emit(UserError('Usuário não encontrado'));
        return null;
      }
    } catch (e) {
      emit(UserError('Erro ao carregar usuário: ${e.toString()}'));
      return null;
    }
  }
}
