import 'package:financas/core/validation/validator.dart';

class EmailValidator implements Validator<String?> {
  static final RegExp _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  @override
  String? validate(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'O e-mail é obrigatório';
    }

    if (!_emailRegex.hasMatch(email)) {
      return 'E-mail inválido';
    }

    return null;
  }
}
