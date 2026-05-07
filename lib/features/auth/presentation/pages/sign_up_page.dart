import 'package:financas/features/auth/presentation/widgets/sign_up_form_widget.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: SignUpFormWidget()),
    );
  }
}
