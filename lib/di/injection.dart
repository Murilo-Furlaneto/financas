import 'package:financas/core/validation/email_validator.dart';
import 'package:financas/core/validation/name_validator.dart';
import 'package:financas/core/validation/password_validator.dart';
import 'package:financas/core/database/local/sqlite.dart';
import 'package:financas/features/charts/data/repositories/charts_repository_impl.dart';
import 'package:financas/features/monthly_expenses/data/repositories/monthly_expenses_repository_impl.dart';

import 'package:financas/features/auth/domain/usecases/login_usecase.dart';
import 'package:financas/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:financas/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:financas/features/charts/data/repositories/charts_repository.dart';
import 'package:financas/features/charts/presentation/cubit/charts_cubit.dart';
import 'package:financas/features/monthly_expenses/domain/repositories/monthly_expenses_repository.dart';
import 'package:financas/features/monthly_expenses/presentation/cubit/monthly_expenses_cubit.dart';
import 'package:financas/features/user/presentation/cubit/user_cubit.dart';

import 'package:get_it/get_it.dart';


final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<SqliteDataBase>(SqliteDataBase.instance);
  // getIt.registerLazySingleton<FirebaseRepository>(() => FirebaseRepositoryImpl(getIt()));
  // getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(getIt()));

  getIt.registerLazySingleton<MonthlyExpensesRepository>(
      () => MonthlyExpensesRepositoryImpl(getIt()));
  getIt.registerLazySingleton<ChartsRepository>(
      () => ChartsRepositoryImpl(getIt()));

  getIt.registerLazySingleton<EmailValidator>(() => EmailValidator());
  getIt.registerLazySingleton<PasswordValidator>(() => PasswordValidator());
  getIt.registerLazySingleton<NameValidator>(() => NameValidator());

  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(
        firebaseRepository: getIt(),
        userRepository: getIt(),
        emailValidator: getIt(),
        passwordValidator: getIt(),
      ));
  getIt.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(
        firebaseRepository: getIt(),
        userRepository: getIt(),
        nameValidator: getIt(),
        emailValidator: getIt(),
        passwordValidator: getIt(),
      ));

  getIt.registerFactory<AuthCubit>(() => AuthCubit(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ));
  getIt.registerFactory<UserCubit>(() => UserCubit(getIt()));
  getIt.registerFactory<MonthlyExpensesCubit>(
      () => MonthlyExpensesCubit(getIt()));
  getIt.registerFactory<ChartsCubit>(() => ChartsCubit(getIt()));
}
