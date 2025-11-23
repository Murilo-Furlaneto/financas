import 'package:financas/data/repositories/monthly_expenses/monthly_expenses_repository.dart';
import 'package:financas/domain/entities/monthly_expenses/monthly_expenses_entity.dart';
import 'package:financas/ui/monthly_expenses/cubit/monthly_expenses_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonthlyExpensesCubit extends Cubit<MonthlyExpensesState> {
  final MonthlyExpensesRepository _repository;

  MonthlyExpensesCubit(this._repository) : super(MonthlyExpensesInitial());

  Future<void> addExpense(MonthlyExpenses expense) async {
    try {
      emit(MonthlyExpensesLoading());
      await _repository.createExpense(expense);

      final now = DateTime.now();
      final updatedExpenses = await _repository.getAllExpensesByMonth(
        now.month,
        now.year,
      );

      emit(MonthlyExpensesLoaded(updatedExpenses));
    } catch (e) {
      emit(MonthlyExpensesError('Erro ao salvar a conta: $e'));
    }
  }

  Future<void> loadExpenses() async {
    try {
      emit(MonthlyExpensesLoading());
      final now = DateTime.now();
      final expensesList =
          await _repository.getAllExpensesByMonth(now.month, now.year);
      emit(MonthlyExpensesLoaded(expensesList));
    } catch (e) {
      emit(MonthlyExpensesError('Erro ao carregar as contas: $e'));
    }
  }

  Future<void> updateExpense(MonthlyExpenses expense) async {
    try {
      emit(MonthlyExpensesLoading());
      await _repository.updateExpense(expense);
      final expensesList = await _repository.getAllExpenses();
      emit(MonthlyExpensesLoaded(expensesList));
    } catch (e) {
      emit(MonthlyExpensesError('Erro ao atualizar a conta: $e'));
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      emit(MonthlyExpensesLoading());
      await _repository.deleteExpense(id);
      final expensesList = await _repository.getAllExpenses();
      emit(MonthlyExpensesLoaded(expensesList));
    } catch (e) {
      emit(MonthlyExpensesError('Erro ao deletar a conta: $e'));
    }
  }
}
