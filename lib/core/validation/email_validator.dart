import 'package:email_validator/email_validator.dart' as pkg;
import 'package:financas/core/validation/validator.dart';

class EmailValidator implements Validator<String?> {
  @override
  String? validate(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'O e-mail é obrigatório';
    }

    if (!pkg.EmailValidator.validate(email)) {
      return 'E-mail inválido';
    }

    return null;
  }
}
