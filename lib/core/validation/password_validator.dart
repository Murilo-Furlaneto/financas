import 'package:financas/core/validation/validator.dart';

class PasswordValidator implements Validator<String?> {
  final int minLength;

  PasswordValidator({this.minLength = 6});

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'A senha é obrigatória';
    }

    if (value.length < minLength) {
      return 'A senha deve ter pelo menos $minLength caracteres';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'A senha deve conter pelo menos uma letra maiúscula';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'A senha deve conter pelo menos uma letra minúscula';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'A senha deve conter pelo menos um número';
    }

    return null;
  }
}
