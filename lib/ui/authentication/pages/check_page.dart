import 'package:financas/core/helpers/shared_preferences/preferences_helper.dart';
import 'package:financas/domain/model/user/user_model.dart';
import 'package:financas/ui/authentication/cubit/auth_cubit.dart';
import 'package:financas/ui/authentication/pages/sign_up_page.dart';
import 'package:financas/ui/home/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckPage extends StatefulWidget {
  CheckPage({Key? key}) : super(key: key);
  final prefs = SharedPreferencesHelper();

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      
      final User? user = await context.read<AuthCubit>().getUser();

      if (!mounted) return;

      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SignUpPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
