import 'package:financas/core/database/local/sqlite.dart';
import 'package:financas/core/result/result.dart';
import 'package:financas/features/monthly_expenses/domain/repositories/monthly_expenses_repository.dart';
import 'package:financas/features/monthly_expenses/domain/entities/monthly_expenses_entity.dart';

class MonthlyExpensesRepositoryImpl implements MonthlyExpensesRepository {
  final SqliteDataBase _sqliteDatabase;

  MonthlyExpensesRepositoryImpl(this._sqliteDatabase);

  @override
  Future<Result<void>> createExpense(MonthlyExpenses expense) async {
    try {
      await _sqliteDatabase.createExpense(expense);
      return const Success(null);
    } catch (e) {
      return Failure('Erro ao criar despesa: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<MonthlyExpenses>>> getAllExpenses() async {
    try {
      final result = await _sqliteDatabase.getAllExpenses();
      return Success(result);
    } catch (e) {
      return Failure('Erro ao buscar despesas: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> updateExpense(MonthlyExpenses expense) async {
    try {
      await _sqliteDatabase.updateExpense(expense);
      return const Success(null);
    } catch (e) {
      return Failure('Erro ao atualizar despesa: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> deleteExpense(String id) async {
    try {
      await _sqliteDatabase.deleteExpense(id);
      return const Success(null);
    } catch (e) {
      return Failure('Erro ao deletar despesa: ${e.toString()}');
    }
  }
  
  @override
  Future<Result<List<MonthlyExpenses>>> getAllExpensesByMonth(int month, int year) async {
    try {
      final result = await _sqliteDatabase.getAllExpensesByMonth(month, year);
      return Success(result);
    } catch (e) {
      return Failure('Erro ao buscar despesas do mês: ${e.toString()}');
    }
  }
}
