import 'package:financas/core/validation/email_validator.dart';
import 'package:financas/core/validation/password_validator.dart';
import 'package:financas/data/repositories/firebase/firebase_repository.dart';
import 'package:financas/data/repositories/user/user_repository.dart';
import 'package:financas/domain/entities/user/user_entity.dart';
import 'package:flutter/material.dart';

class LoginUseCase {
  final FirebaseRepository firebaseRepository;
  final UserRepository userRepository;
  final EmailValidator emailValidator;
  final PasswordValidator passwordValidator;

  LoginUseCase({
    required this.firebaseRepository,
    required this.userRepository,
    required this.emailValidator,
    required this.passwordValidator,
  });

  Future<User> execute(String email, String password, BuildContext context) async {
    // 1. Validação Sintática/Negócio
    final emailError = emailValidator.validate(email);
    if (emailError != null) throw Exception(emailError);

    final passwordError = passwordValidator.validate(password);
    if (passwordError != null) throw Exception(passwordError);

    // 2. Chamada ao repositório
    await firebaseRepository.loginFirebase(email, password, context);
    
    // 3. Persistência local e retorno
    final user = await firebaseRepository.getCurrentUser();
    user.senha = password;
    await userRepository.saveUser(user);
    
    return user;
  }
}
