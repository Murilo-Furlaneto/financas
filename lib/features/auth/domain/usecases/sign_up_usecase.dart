import 'package:financas/core/result/result.dart';
import 'package:financas/core/validation/email_validator.dart';
import 'package:financas/core/validation/name_validator.dart';
import 'package:financas/core/validation/password_validator.dart';
import 'package:financas/features/auth/data/repositories/firebase_repository.dart';
import 'package:financas/features/auth/data/repositories/user_repository.dart';
import 'package:financas/features/auth/domain/entities/user_entity.dart';

class SignUpUseCase {
  final FirebaseRepository firebaseRepository;
  final UserRepository userRepository;
  final NameValidator nameValidator;
  final EmailValidator emailValidator;
  final PasswordValidator passwordValidator;

  SignUpUseCase({
    required this.firebaseRepository,
    required this.userRepository,
    required this.nameValidator,
    required this.emailValidator,
    required this.passwordValidator,
  });

  Future<Result<void>> execute({
    required String name,
    required String email,
    required String password,
  }) async {
    final nameError = nameValidator.validate(name);
    if (nameError != null) return Failure(nameError);

    final emailError = emailValidator.validate(email);
    if (emailError != null) return Failure(emailError);

    final passwordError = passwordValidator.validate(password);
    if (passwordError != null) return Failure(passwordError);

    final signUpResult =
        await firebaseRepository.signUpFirebase(name, email, password);
    if (signUpResult is Failure) {
      return Failure((signUpResult).message);
    }

    await userRepository
        .saveUser(User(nome: name, email: email, senha: password));
    return const Success(null);
  }
}
