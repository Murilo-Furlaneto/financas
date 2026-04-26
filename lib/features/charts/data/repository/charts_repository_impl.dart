import 'package:financas/core/database/local/sqlite.dart';
import 'package:financas/core/result/result.dart';
import 'package:financas/features/charts/domain/repository/charts_repository.dart';
import 'package:financas/features/monthly_expenses/domain/entities/monthly_expenses_entity.dart';

class ChartsRepositoryImpl implements ChartsRepository {
  final SqliteDataBase _sqliteDatabase;

  ChartsRepositoryImpl(this._sqliteDatabase);

  @override
  Future<Result<Map<String, double>>> getExpensesGroupedByCategory(
      int month, int year,
      {String? category}) async {
    try {
      final result = await _sqliteDatabase
          .getExpensesGroupedByCategory(month, year, category: category);
      return Success(result);
    } catch (e) {
      return Failure(
          'Erro ao obter despesas agrupadas por categoria: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<MonthlyExpenses>>> getExpensesByMonth(int month, int year,
      {String? category}) async {
    try {
      final result = await _sqliteDatabase.getExpensesByMonth(month, year,
          category: category);
      return Success(result);
    } catch (e) {
      return Failure('Erro ao obter despesas por mês: ${e.toString()}');
    }
  }
}
