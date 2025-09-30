import 'package:financas/core/helpers/shared_preferences/preferences_helper.dart';
import 'package:financas/domain/model/user/user_model.dart';
import 'package:financas/ui/authentication/pages/sign_up_page.dart';
import 'package:financas/ui/home/view/home_page.dart';
import 'package:flutter/material.dart';

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
      final User? user = await widget.prefs.getUser();

      if (user != null) {
        return Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        return Navigator.push(context,
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
