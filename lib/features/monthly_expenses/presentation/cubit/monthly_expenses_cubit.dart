import 'package:financas/core/result/result.dart';
import 'package:financas/features/monthly_expenses/domain/entities/monthly_expenses_entity.dart';
import 'package:financas/features/monthly_expenses/domain/repositories/monthly_expenses_repository.dart';
import 'package:financas/features/monthly_expenses/presentation/cubit/monthly_expenses_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonthlyExpensesCubit extends Cubit<MonthlyExpensesState> {
  final MonthlyExpensesRepository _repository;

  MonthlyExpensesCubit(this._repository) : super(MonthlyExpensesInitial());

  Future<void> addExpense(MonthlyExpenses expense) async {
    emit(MonthlyExpensesLoading());
    final result = await _repository.createExpense(expense);

    if (result is Success<void>) {
      await loadExpenses();
    } else if (result is Failure) {
      emit(MonthlyExpensesError(result.message));
    }
  }

  Future<void> loadExpenses() async {
    emit(MonthlyExpensesLoading());
    final now = DateTime.now();
    final result = await _repository.getAllExpensesByMonth(now.month, now.year);

    if (result is Success<List<MonthlyExpenses>>) {
      emit(MonthlyExpensesLoaded(result.data));
    } else if (result is Failure) {
      emit(MonthlyExpensesError((result as Failure).message));
    }
  }

  Future<void> updateExpense(MonthlyExpenses expense) async {
    emit(MonthlyExpensesLoading());
    final result = await _repository.updateExpense(expense);

    if (result is Success<void>) {
      await loadExpenses();
    } else if (result is Failure) {
      emit(MonthlyExpensesError(result.message));
    }
  }

  Future<void> deleteExpense(String id) async {
    emit(MonthlyExpensesLoading());
    final result = await _repository.deleteExpense(id);

    if (result is Success<void>) {
      await loadExpenses();
    } else if (result is Failure) {
      emit(MonthlyExpensesError(result.message));
    }
  }
}
