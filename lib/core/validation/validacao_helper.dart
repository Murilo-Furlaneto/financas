import 'package:flutter/material.dart';

class ValidacaoLogin {
  RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  RegExp passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).{6,}$');

  bool emailCheck(String value) {
    return emailRegex.hasMatch(value);
  }

  bool passwordCheck(String value) {
    return passwordRegex.hasMatch(value);
  }

  bool checkForm(TextEditingController email, TextEditingController senha,
      BuildContext context) {
    if (email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Digite um e-mail válido")),
      );
      return false;
    }

    if (senha.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Digite sua senha")),
      );
      return false;
    }

    if (!emailCheck(email.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("E-mail inválido")),
      );
      return false;
    }

    if (!passwordCheck(senha.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Senha inválida. A senha deve conter pelo menos uma letra maiúscula.")),
      );
      return false;
    }

    return true;
  }
}
