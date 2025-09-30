import 'package:financas/domain/model/user/user_model.dart';

abstract class AuthCubitState {}

class AuthInitial extends AuthCubitState {}

class AuthLoading extends AuthCubitState {}

class AuthLoaded extends AuthCubitState {
  final User user;

  AuthLoaded(this.user);
}

class AuthError extends AuthCubitState {
  final String message;

  AuthError(this.message);
}
