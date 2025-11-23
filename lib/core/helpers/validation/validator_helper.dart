import 'package:flutter/material.dart';

enum PasswordRequirement {
  minLength(6),
  hasUppercase,
  hasLowercase,
  hasDigit,
  hasSpecialChar;

  const PasswordRequirement([this.value]);
  final int? value;
}

class LoginValidator {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9]([a-zA-Z0-9._-]*[a-zA-Z0-9])?@[a-zA-Z0-9]([a-zA-Z0-9.-]*[a-zA-Z0-9])?\.[a-zA-Z]{2,}$',
  );

  static bool isValidEmail(String email) {
    if (email.trim().isEmpty) return false;
    return _emailRegex.hasMatch(email.trim());
  }

  static (bool, String?) validatePassword(String password) {
    if (password.isEmpty) {
      return (false, 'A senha é obrigatória');
    }
    if (password.length < 6) {
      return (false, 'A senha deve ter pelo menos 6 caracteres');
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return (false, 'A senha deve conter pelo menos uma letra maiúscula');
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return (false, 'A senha deve conter pelo menos uma letra minúscula');
    }
    return (true, null);
  }

  static bool validateLoginForm({
    required String email,
    required String password,
    required BuildContext context,
  }) {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty) {
      _showError(context, 'Digite seu e-mail');
        return false;
    }

    if (!isValidEmail(trimmedEmail)) {
      _showError(context, 'E-mail inválido');
      return false;
    }

    if (password.isEmpty) {
      _showError(context, 'Digite sua senha');
      return false;
    }

    final (isValid, errorMessage) = validatePassword(password);
    if (!isValid) {
      _showError(context, errorMessage!);
      return false;
    }

    return true;
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
  }
}