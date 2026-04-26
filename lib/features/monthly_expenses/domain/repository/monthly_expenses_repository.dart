import 'package:financas/core/result/result.dart';
import 'package:financas/features/monthly_expenses/domain/entities/monthly_expenses_entity.dart';

abstract class MonthlyExpensesRepository {
  Future<Result<void>> createExpense(MonthlyExpenses expense);
  Future<Result<List<MonthlyExpenses>>> getAllExpenses();
  Future<Result<List<MonthlyExpenses>>> getAllExpensesByMonth(int month, int year);
  Future<Result<void>> updateExpense(MonthlyExpenses expense);
  Future<Result<void>> deleteExpense(String id);
}
