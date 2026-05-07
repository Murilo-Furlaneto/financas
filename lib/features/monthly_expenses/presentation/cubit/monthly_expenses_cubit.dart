import 'dart:developer';
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
    log('Adding expense: ${expense.title}', name: 'MonthlyExpensesCubit.addExpense');
    emit(MonthlyExpensesLoading());
    final result = await _createExpenseUseCase.execute(expense);

    if (result is Success<void>) {
      log('Expense added successfully', name: 'MonthlyExpensesCubit.addExpense');
      await loadExpenses();
    } else if (result is Failure) {
      log('Failed to add expense: ${(result).message}', name: 'MonthlyExpensesCubit.addExpense');
      emit(MonthlyExpensesError(result.message));
    }
  }

  Future<void> loadExpenses() async {
    log('Loading expenses', name: 'MonthlyExpensesCubit.loadExpenses');
    emit(MonthlyExpensesLoading());
    final now = DateTime.now();
    final result = await _getAllExpensesByMonthUseCase.execute(now.month, now.year);

    if (result is Success<List<MonthlyExpenses>>) {
      log('Successfully loaded ${(result as Success).data.length} expenses', name: 'MonthlyExpensesCubit.loadExpenses');
      emit(MonthlyExpensesLoaded(result.data));
    } else if (result is Failure) {
      log('Failed to load expenses: ${(result as Failure).message}', name: 'MonthlyExpensesCubit.loadExpenses');
      emit(MonthlyExpensesError((result as Failure).message));
    }
  }

  Future<void> updateExpense(MonthlyExpenses expense) async {
    log('Updating expense: ${expense.id}', name: 'MonthlyExpensesCubit.updateExpense');
    emit(MonthlyExpensesLoading());
    final result = await _updateExpenseUseCase.execute(expense);

    if (result is Success<void>) {
      log('Expense updated successfully', name: 'MonthlyExpensesCubit.updateExpense');
      await loadExpenses();
    } else if (result is Failure) {
      log('Failed to update expense: ${(result).message}', name: 'MonthlyExpensesCubit.updateExpense');
      emit(MonthlyExpensesError(result.message));
    }
  }

  Future<void> deleteExpense(String id) async {
    log('Deleting expense: $id', name: 'MonthlyExpensesCubit.deleteExpense');
    emit(MonthlyExpensesLoading());
    final result = await _deleteExpenseUseCase.execute(id);

    if (result is Success<void>) {
      log('Expense deleted successfully', name: 'MonthlyExpensesCubit.deleteExpense');
      await loadExpenses();
    } else if (result is Failure) {
      log('Failed to delete expense: ${(result).message}', name: 'MonthlyExpensesCubit.deleteExpense');
      emit(MonthlyExpensesError(result.message));
    }
  }
}
