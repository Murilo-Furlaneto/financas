// ignore_for_file: unused_import

import 'package:financas/data/database/local/sqlite.dart';
import 'package:financas/data/dto/expense_dto.dart';
import 'package:financas/data/repositories/charts_repository.dart';
import 'package:financas/domain/model/monthly_expenses/monthly_expenses_model.dart';

class ChartsRepositoryImpl implements ChartsRepository {
  final SqliteDataBase _sqliteDatabase;

  ChartsRepositoryImpl(this._sqliteDatabase);

  @override
  Future<Map<String, double>> getExpensesGroupedByCategory(int month, int year, {String? category}) async {
    return await _sqliteDatabase.getExpensesGroupedByCategory(month, year, category: category);
  }

  @override
  Future<List<MonthlyExpenses>> getExpensesByMonth(int month, int year, {String? category}) async {
    return await _sqliteDatabase.getExpensesByMonth(month, year, category: category);
   // return expenses.map((e) => ExpenseDto.fromModel(e)).toList();
  }
}
