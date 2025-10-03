import 'dart:async';
import 'package:financas/ui/authentication/cubit/auth_cubit.dart';
import 'package:financas/ui/user/cubit/user_cubit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  final AuthCubit authCubit;

  UserCubit(this.authCubit) : super(UserInitial());

  Future<void> getUser() async {
    emit(UserLoading());
    try {
      final user = await authCubit.getUser();
      emit(UserLoaded(user!));
    } catch (e) {
      emit(UserError('Erro ao carregar usuário: $e'));
    }
  }
}
