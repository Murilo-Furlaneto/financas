import 'package:financas/data/dto/expense_dto.dart';
import 'package:financas/domain/model/monthly_expenses/monthly_expenses_model.dart';

abstract class ChartsRepository {
  Future<Map<String, double>> getExpensesGroupedByCategory(int month, int year, {String? category});
  Future<List<MonthlyExpenses>> getExpensesByMonth(int month, int year, {String? category});
}
