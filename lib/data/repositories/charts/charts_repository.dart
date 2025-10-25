// ignore_for_file: unused_import

import 'package:financas/data/dto/expense_dto.dart';
import 'package:financas/domain/entities/monthly_expenses/monthly_expenses_entity.dart';

abstract class ChartsRepository {
  Future<Map<String, double>> getExpensesGroupedByCategory(int month, int year, {String? category});
  Future<List<MonthlyExpenses>> getExpensesByMonth(int month, int year, {String? category});
}
