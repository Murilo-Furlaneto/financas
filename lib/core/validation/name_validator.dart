import 'package:financas/core/validation/validator.dart';

class NameValidator implements Validator<String?> {
  @override
  String? validate(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'O nome é obrigatório';
    }

    if (name.length < 3) {
      return 'O nome deve ter pelo menos 3 caracteres';
    }

    return null;
  }
}
