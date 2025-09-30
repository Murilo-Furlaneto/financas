import 'package:financas/core/helpers/shared_preferences/preferences_helper.dart';
import 'package:financas/data/database/local/sqlite.dart';
import 'package:financas/data/repositories/firebase/firebase_repository_impl.dart';
import 'package:financas/data/repositories/monthly_expenses_repository_impl.dart';
import 'package:financas/data/services/firebase_service.dart';
import 'package:financas/firebase_options.dart';
import 'package:financas/ui/authentication/cubit/auth_cubit.dart';
import 'package:financas/ui/authentication/pages/check_page.dart';
import 'package:financas/ui/monthly_expenses/cubit/monthly_expenses_cubit.dart';
import 'package:financas/ui/user/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(
            FirebaseRepositoryImpl(FirebaseService()),
            SharedPreferencesHelper(),
          ),
        ),
        BlocProvider<UserCubit>(
          create: (context) => UserCubit(context.read<AuthCubit>()),
        ),
        BlocProvider<MonthlyExpensesCubit>(
          create: (_) => MonthlyExpensesCubit(MonthlyExpensesRepositoryImpl(SqliteDataBase.instance)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      home: CheckPage(),
    );
  }
}