import 'package:financas/data/database/local/sqlite.dart';
import 'package:financas/data/repositories/monthly_expenses_repository.dart';
import 'package:financas/domain/model/monthly_expenses/monthly_expenses_model.dart';

class MonthlyExpensesRepositoryImpl implements MonthlyExpensesRepository {
  final SqliteDataBase _sqliteDatabase;

  MonthlyExpensesRepositoryImpl(this._sqliteDatabase);

  @override
  Future<void> createExpense(MonthlyExpenses expense) async {
    await _sqliteDatabase.createExpense(expense);
  }

  @override
  Future<List<MonthlyExpenses>> getAllExpenses() async {
    return await _sqliteDatabase.getAllExpenses();
  }

  @override
  Future<void> updateExpense(MonthlyExpenses expense) async {
    await _sqliteDatabase.updateExpense(expense);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _sqliteDatabase.deleteExpense(id);
  }
}
