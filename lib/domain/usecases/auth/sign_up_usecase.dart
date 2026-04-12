import 'package:financas/core/validation/email_validator.dart';
import 'package:financas/core/validation/name_validator.dart';
import 'package:financas/core/validation/password_validator.dart';
import 'package:financas/data/repositories/firebase/firebase_repository.dart';
import 'package:financas/data/repositories/user/user_repository.dart';
import 'package:financas/domain/entities/user/user_entity.dart';

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

  Future<void> execute({
    required String name,
    required String email,
    required String password,
  }) async {
    // 1. Validação
    final nameError = nameValidator.validate(name);
    if (nameError != null) throw Exception(nameError);

    final emailError = emailValidator.validate(email);
    if (emailError != null) throw Exception(emailError);

    final passwordError = passwordValidator.validate(password);
    if (passwordError != null) throw Exception(passwordError);

    // 2. Registro no Firebase
    await firebaseRepository.signUpFirebase(name, email, password);

    // 3. Salvar localmente
    await userRepository.saveUser(User(nome: name, email: email, senha: password));
  }
}
