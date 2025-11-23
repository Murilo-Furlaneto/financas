import 'package:financas/domain/entities/user/user_entity.dart';

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

class AuthPasswordResetEmailSent extends AuthCubitState {}
