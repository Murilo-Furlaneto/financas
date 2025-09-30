import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
            'Foi enviado um email para cadastrar nova senha',
            style: TextStyle(fontSize: 20, color: Colors.black),
          )),
    );
  }
}
