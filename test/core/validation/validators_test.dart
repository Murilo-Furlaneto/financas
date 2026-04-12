import 'package:financas/core/validation/email_validator.dart';
import 'package:financas/core/validation/name_validator.dart';
import 'package:financas/core/validation/password_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmailValidator', () {
    final validator = EmailValidator();

    test('deve retornar erro se o email for vazio', () {
      expect(validator.validate(''), 'O e-mail é obrigatório');
    });

    test('deve retornar erro se o email for inválido', () {
      expect(validator.validate('email'), 'E-mail inválido');
    });

    test('deve retornar null se o email for válido', () {
      expect(validator.validate('teste@email.com'), isNull);
    });
  });

  group('PasswordValidator', () {
    final validator = PasswordValidator();

    test('deve retornar erro se a senha for curta', () {
      expect(validator.validate('123'), 'A senha deve ter pelo menos 6 caracteres');
    });

    test('deve retornar erro se não tiver maiúscula', () {
      expect(validator.validate('senha123'), 'A senha deve conter pelo menos uma letra maiúscula');
    });

    test('deve retornar null se a senha for válida', () {
      expect(validator.validate('Senha123'), isNull);
    });
  });

  group('NameValidator', () {
    final validator = NameValidator();

    test('deve retornar erro se o nome for vazio', () {
      expect(validator.validate(''), 'O nome é obrigatório');
    });

    test('deve retornar erro se o nome for curto', () {
      expect(validator.validate('Ab'), 'O nome deve ter pelo menos 3 caracteres');
    });

    test('deve retornar null se o nome for válido', () {
      expect(validator.validate('Fulano'), isNull);
    });
  });
}
