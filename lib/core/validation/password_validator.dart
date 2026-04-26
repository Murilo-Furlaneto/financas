import 'package:financas/core/validation/validator.dart';

class PasswordValidator implements Validator<String?> {
  final int minLength;

  PasswordValidator({this.minLength = 8});

  static final _upperCaseRegex = RegExp(r'[A-Z]');
  static final _lowerCaseRegex = RegExp(r'[a-z]');
  static final _numberRegex = RegExp(r'[0-9]');
  static final _specialCharRegex = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'A senha é obrigatória';
    }

    if (value.length < minLength) {
      return 'A senha deve ter pelo menos $minLength caracteres';
    }

    if (!_upperCaseRegex.hasMatch(value)) {
      return 'A senha deve conter pelo menos uma letra maiúscula';
    }

    if (!_lowerCaseRegex.hasMatch(value)) {
      return 'A senha deve conter pelo menos uma letra minúscula';
    }

    if (!_numberRegex.hasMatch(value)) {
      return 'A senha deve conter pelo menos um número';
    }

    if (!_specialCharRegex.hasMatch(value)) {
      return 'A senha deve conter pelo menos um caractere especial';
    }

    return null;
  }
}
