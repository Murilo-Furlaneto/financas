import 'package:financas/data/repositories/monthly_expenses_repository.dart';
import 'package:financas/domain/model/monthly_expenses/monthly_expenses_model.dart';
import 'package:financas/ui/monthly_expenses/cubit/monthly_expenses_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonthlyExpensesCubit extends Cubit<MonthlyExpensesState> {
  final MonthlyExpensesRepository _repository;

  MonthlyExpensesCubit(this._repository) : super(MonthlyExpensesInitial());

  Future<void> addExpense(MonthlyExpenses expense) async {
    try {
      emit(MonthlyExpensesLoading());
      await _repository.createExpense(expense);
      final updatedExpenses = await _repository.getAllExpenses();
      emit(MonthlyExpensesLoaded(updatedExpenses));
    } catch (e) {
      emit(MonthlyExpensesError('Erro ao salvar a conta: $e'));
    }
  }

  Future<void> loadExpenses() async {
    try {
      emit(MonthlyExpensesLoading());
      final expensesList = await _repository.getAllExpenses();
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
