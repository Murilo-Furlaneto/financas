import 'package:financas/core/result/result.dart';
import 'package:financas/features/monthly_expenses/domain/entities/monthly_expenses_entity.dart';

abstract class ChartsRepository {
  Future<Result<Map<String, double>>> getExpensesGroupedByCategory(int month, int year, {String? category});
  Future<Result<List<MonthlyExpenses>>> getExpensesByMonth(int month, int year, {String? category});
}
