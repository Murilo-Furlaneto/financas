import 'package:financas/domain/entities/monthly_expenses/monthly_expenses_entity.dart';

abstract class MonthlyExpensesRepository {
  Future<void> createExpense(MonthlyExpenses expense);
  Future<List<MonthlyExpenses>> getAllExpenses();
  Future<List<MonthlyExpenses>> getAllExpensesByMonth(int month, int year);
  Future<void> updateExpense(MonthlyExpenses expense);
  Future<void> deleteExpense(String id);
}
