import 'package:financas/core/result/result.dart';
import 'package:financas/core/validation/email_validator.dart';
import 'package:financas/core/validation/password_validator.dart';
import 'package:financas/features/auth/domain/repository/firebase_repository.dart';
import 'package:financas/features/user/domain/repository/user_repository.dart';
import 'package:financas/features/auth/domain/entities/user_entity.dart';
import 'package:financas/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseRepositryMock extends Mock implements FirebaseRepository {}

class UserRepositoryMock extends Mock implements UserRepository {}

class MockUser extends Mock implements User {}


void main() {
  late FirebaseRepository firebaseRepository;
  late UserRepository userRepository;
  late EmailValidator emailValidator;
  late PasswordValidator passwordValidator;
  
  setUp(() {
    firebaseRepository = FirebaseRepositryMock();
    userRepository = UserRepositoryMock();
    emailValidator = EmailValidator();
    passwordValidator = PasswordValidator();
  });

  setUpAll((){
    registerFallbackValue(MockUser());
  });

  test(' Should return failure if passwors is invalid', () async {
    final loginUseCase = LoginUseCase(firebaseRepository: firebaseRepository, userRepository: userRepository, emailValidator: emailValidator, passwordValidator: passwordValidator);
    const email = 'teste@gmail.com';
    const password = '123';

    final result  = await loginUseCase.execute(email, password);

    expect(result, isA<Failure>());
  });

  test('Should return failure if email is invalid', () async {
    final useCase = LoginUseCase(firebaseRepository: firebaseRepository, userRepository: userRepository, emailValidator: emailValidator, passwordValidator: passwordValidator);
    const email = 'teste';
    const password = 'EasyPassword123/';

    final result = await useCase.execute(email, password);

    expect(result, isA<Failure>());

  });

  test('Should return success if email and password are valid', () async {
    const email = 'userteste@gmail.com';
    const password = 'EasyPassword123/';

    when(() => firebaseRepository.loginFirebase(email, password)).thenAnswer((_) async => const Success<void>(null));
    when(() => firebaseRepository.getCurrentUser()).thenAnswer((_) async =>  Success(User(nome: 'user', email: email, senha: password)));
    when(() => userRepository.saveUser(any())).thenAnswer((_) async => const Success(null));

});


test('Should return failure if login fails', () async {
    const email = 'test12@gmail.com';
    const password = 'Myname1976/w';

    when(() => firebaseRepository.loginFirebase(email, password)).thenAnswer((_) async => const Failure('Login failed'));
    when(() => firebaseRepository.getCurrentUser()).thenAnswer((_) async =>  Success(User(nome: 'user', email: email, senha: password)));
    when(() => userRepository.saveUser(any())).thenAnswer((_) async => const Success(null));


    });
}