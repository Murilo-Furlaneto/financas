import 'package:financas/core/result/result.dart';
import 'package:financas/features/monthly_expenses/domain/entities/monthly_expenses_entity.dart';
import 'package:financas/features/monthly_expenses/presentation/cubit/monthly_expenses_state.dart';
import 'package:financas/features/monthly_expenses/domain/usecases/create_expense_usecase.dart';
import 'package:financas/features/monthly_expenses/domain/usecases/update_expense_usecase.dart';
import 'package:financas/features/monthly_expenses/domain/usecases/delete_expense_usecase.dart';
import 'package:financas/features/monthly_expenses/domain/usecases/get_all_expenses_by_month_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonthlyExpensesCubit extends Cubit<MonthlyExpensesState> {
  final CreateExpenseUseCase _createExpenseUseCase;
  final UpdateExpenseUseCase _updateExpenseUseCase;
  final DeleteExpenseUseCase _deleteExpenseUseCase;
  final GetAllExpensesByMonthUseCase _getAllExpensesByMonthUseCase;

  MonthlyExpensesCubit(
    this._createExpenseUseCase,
    this._updateExpenseUseCase,
    this._deleteExpenseUseCase,
    this._getAllExpensesByMonthUseCase,
  ) : super(MonthlyExpensesInitial());

  Future<void> addExpense(MonthlyExpenses expense) async {
    emit(MonthlyExpensesLoading());
    final result = await _createExpenseUseCase.execute(expense);

    if (result is Success<void>) {
      await loadExpenses();
    } else if (result is Failure) {
      emit(MonthlyExpensesError(result.message));
    }
  }

  Future<void> loadExpenses() async {
    emit(MonthlyExpensesLoading());
    final now = DateTime.now();
    final result = await _getAllExpensesByMonthUseCase.execute(now.month, now.year);

    if (result is Success<List<MonthlyExpenses>>) {
      emit(MonthlyExpensesLoaded(result.data));
    } else if (result is Failure) {
      emit(MonthlyExpensesError((result as Failure).message));
    }
  }

  Future<void> updateExpense(MonthlyExpenses expense) async {
    emit(MonthlyExpensesLoading());
    final result = await _updateExpenseUseCase.execute(expense);

    if (result is Success<void>) {
      await loadExpenses();
    } else if (result is Failure) {
      emit(MonthlyExpensesError(result.message));
    }
  }

  Future<void> deleteExpense(String id) async {
    emit(MonthlyExpensesLoading());
    final result = await _deleteExpenseUseCase.execute(id);

    if (result is Success<void>) {
      await loadExpenses();
    } else if (result is Failure) {
      emit(MonthlyExpensesError(result.message));
    }
  }
}
