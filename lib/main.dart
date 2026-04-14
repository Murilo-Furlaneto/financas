import 'package:financas/di/injection.dart';
import 'package:financas/firebase_options.dart';
import 'package:financas/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:financas/features/auth/presentation/pages/check_page.dart';
import 'package:financas/features/charts/presentation/cubit/charts_cubit.dart';
import 'package:financas/features/monthly_expenses/presentation/cubit/monthly_expenses_cubit.dart';
import 'package:financas/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => getIt<AuthCubit>(),
        ),
        BlocProvider<UserCubit>(
          create: (context) => getIt<UserCubit>(),
        ),
        BlocProvider<MonthlyExpensesCubit>(
          create: (_) => getIt<MonthlyExpensesCubit>(),
        ),
        BlocProvider<ChartsCubit>(
          create: (context) => getIt<ChartsCubit>(),
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
      home: const CheckPage(),
    );
  }
}
