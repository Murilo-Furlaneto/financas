import 'package:financas/core/result/result.dart';
import 'package:financas/core/validation/email_validator.dart';
import 'package:financas/core/validation/password_validator.dart';
import 'package:financas/features/auth/data/repositories/firebase_repository.dart';
import 'package:financas/features/auth/data/repositories/user_repository.dart';
import 'package:financas/features/auth/domain/entities/user_entity.dart';

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

  Future<Result<User>> execute(String email, String password) async {
    final emailError = emailValidator.validate(email);
    if (emailError != null) return Failure<User>(emailError);

    final passwordError = passwordValidator.validate(password);
    if (passwordError != null) return Failure<User>(passwordError);

    final loginResult = await firebaseRepository.loginFirebase(email, password);
    if (loginResult is Failure<void>) {
      return Failure<User>(loginResult.message);
    }

    final userResult = await firebaseRepository.getCurrentUser();
    if (userResult is Success<User>) {
      final user = userResult.data;
      user.senha = password;
      await userRepository.saveUser(user);
      return Success<User>(user);
    } else if (userResult is Failure<User>) {
      return Failure<User>(userResult.message);
    }
    
    return const Failure<User>('Erro desconhecido ao realizar login');
  }
}
