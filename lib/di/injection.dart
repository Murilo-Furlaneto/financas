import 'package:financas/core/validation/email_validator.dart';
import 'package:financas/core/validation/name_validator.dart';
import 'package:financas/core/validation/password_validator.dart';
import 'package:financas/core/database/local/sqlite.dart';
import 'package:financas/features/auth/data/repository/firebase_repository_impl.dart';
import 'package:financas/features/auth/domain/repository/firebase_repository.dart';
import 'package:financas/features/charts/data/repository/charts_repository_impl.dart';
import 'package:financas/features/charts/domain/repository/charts_repository.dart';
import 'package:financas/features/monthly_expenses/data/repository/monthly_expenses_repository_impl.dart';

import 'package:financas/features/monthly_expenses/domain/repository/monthly_expenses_repository.dart';

import 'package:financas/features/auth/domain/usecases/login_usecase.dart';
import 'package:financas/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:financas/features/auth/domain/usecases/get_user_usecase.dart'
    as auth_get_user;
import 'package:financas/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:financas/features/charts/domain/usecases/get_expenses_grouped_by_category_usecase.dart';
import 'package:financas/features/charts/domain/usecases/get_expenses_by_month_usecase.dart';
import 'package:financas/features/monthly_expenses/domain/usecases/create_expense_usecase.dart';
import 'package:financas/features/monthly_expenses/domain/usecases/update_expense_usecase.dart';
import 'package:financas/features/monthly_expenses/domain/usecases/delete_expense_usecase.dart';
import 'package:financas/features/monthly_expenses/domain/usecases/get_all_expenses_by_month_usecase.dart';
import 'package:financas/features/user/data/repository/user_repository_impl.dart';
import 'package:financas/features/user/domain/repository/user_repository.dart';
import 'package:financas/features/user/domain/usecases/get_user_usecase.dart'
    as user_get_user;
import 'package:financas/features/user/domain/usecases/save_user_usecase.dart';

// Cubits
import 'package:financas/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:financas/features/charts/presentation/cubit/charts_cubit.dart';
import 'package:financas/features/monthly_expenses/presentation/cubit/monthly_expenses_cubit.dart';
import 'package:financas/features/user/presentation/cubit/user_cubit.dart';

import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<SqliteDataBase>(SqliteDataBase.instance);

  getIt.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl());
  getIt
      .registerLazySingleton<UserRepository>(() => UserRepositoryImpl(getIt()));
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

  getIt.registerLazySingleton<auth_get_user.GetUserUseCase>(
      () => auth_get_user.GetUserUseCase(getIt()));
  getIt.registerLazySingleton<UpdateUserUseCase>(() => UpdateUserUseCase(
        firebaseRepository: getIt(),
        userRepository: getIt(),
      ));

  getIt.registerLazySingleton<CreateExpenseUseCase>(
      () => CreateExpenseUseCase(getIt()));
  getIt.registerLazySingleton<UpdateExpenseUseCase>(
      () => UpdateExpenseUseCase(getIt()));
  getIt.registerLazySingleton<DeleteExpenseUseCase>(
      () => DeleteExpenseUseCase(getIt()));
  getIt.registerLazySingleton<GetAllExpensesByMonthUseCase>(
      () => GetAllExpensesByMonthUseCase(getIt()));

  getIt.registerLazySingleton<GetExpensesGroupedByCategoryUseCase>(
      () => GetExpensesGroupedByCategoryUseCase(getIt()));
  getIt.registerLazySingleton<GetExpensesByMonthUseCase>(
      () => GetExpensesByMonthUseCase(getIt()));

  getIt.registerLazySingleton<user_get_user.GetUserUseCase>(
      () => user_get_user.GetUserUseCase(getIt()));
  getIt.registerLazySingleton<SaveUserUseCase>(() => SaveUserUseCase(getIt()));

  getIt.registerFactory<AuthCubit>(() => AuthCubit(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ));
  getIt.registerFactory<UserCubit>(() => UserCubit(getIt(), getIt()));
  getIt.registerFactory<MonthlyExpensesCubit>(() => MonthlyExpensesCubit(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ));
  getIt.registerFactory<ChartsCubit>(() => ChartsCubit(getIt(), getIt()));
}
