import 'dart:developer';
import 'package:financas/core/database/local/sqlite.dart';
import 'package:financas/core/result/result.dart';
import 'package:financas/features/monthly_expenses/domain/repository/monthly_expenses_repository.dart';
import 'package:financas/features/monthly_expenses/domain/entities/monthly_expenses_entity.dart';
import 'package:flutter/foundation.dart';

class MonthlyExpensesRepositoryImpl implements MonthlyExpensesRepository {
  final SqliteDataBase _sqliteDatabase;

  MonthlyExpensesRepositoryImpl(this._sqliteDatabase);
  
  static List<MonthlyExpenses> _parseExpenses(List<Map<String, dynamic>> maps) {
    return maps.map((json) => MonthlyExpenses.fromMap(json)).toList();
  }

  @override
  Future<Result<void>> createExpense(MonthlyExpenses expense) async {
    try {
      log('Creating expense: ${expense.title}', name: 'MonthlyExpensesRepositoryImpl.createExpense');
      await _sqliteDatabase.createExpense(expense);
      log('Expense created successfully', name: 'MonthlyExpensesRepositoryImpl.createExpense');
      return const Success(null);
    } catch (e) {
      log('Error creating expense: $e', name: 'MonthlyExpensesRepositoryImpl.createExpense', error: e);
      return Failure('Erro ao criar despesa: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<MonthlyExpenses>>> getAllExpenses() async {
    try {
      log('Fetching all expenses', name: 'MonthlyExpensesRepositoryImpl.getAllExpenses');
      final db = await _sqliteDatabase.database;
      final List<Map<String,dynamic>> maps = await db.query('monthlyExpenses');
      log('Fetched ${maps.length} raw records, parsing with compute', name: 'MonthlyExpensesRepositoryImpl.getAllExpenses');
      final result = await compute(_parseExpenses, maps);
      log('Successfully parsed ${result.length} expenses', name: 'MonthlyExpensesRepositoryImpl.getAllExpenses');
      return Success(result);
    } catch (e) {
      log('Error fetching all expenses: $e', name: 'MonthlyExpensesRepositoryImpl.getAllExpenses', error: e);
      return Failure('Erro ao buscar despesas: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> updateExpense(MonthlyExpenses expense) async {
    try {
      log('Updating expense: ${expense.id}', name: 'MonthlyExpensesRepositoryImpl.updateExpense');
      await _sqliteDatabase.updateExpense(expense);
      log('Expense updated successfully', name: 'MonthlyExpensesRepositoryImpl.updateExpense');
      return const Success(null);
    } catch (e) {
      log('Error updating expense: $e', name: 'MonthlyExpensesRepositoryImpl.updateExpense', error: e);
      return Failure('Erro ao atualizar despesa: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> deleteExpense(String id) async {
    try {
      log('Deleting expense: $id', name: 'MonthlyExpensesRepositoryImpl.deleteExpense');
      await _sqliteDatabase.deleteExpense(id);
      log('Expense deleted successfully', name: 'MonthlyExpensesRepositoryImpl.deleteExpense');
      return const Success(null);
    } catch (e) {
      log('Error deleting expense: $e', name: 'MonthlyExpensesRepositoryImpl.deleteExpense', error: e);
      return Failure('Erro ao deletar despesa: ${e.toString()}');
    }
  }
  
  @override
  Future<Result<List<MonthlyExpenses>>> getAllExpensesByMonth(int month, int year) async {
    try {
      log('Fetching expenses for month: $month, year: $year', name: 'MonthlyExpensesRepositoryImpl.getAllExpensesByMonth');
      final result = await _sqliteDatabase.getAllExpensesByMonth(month, year);
      log('Successfully fetched ${result.length} expenses for month $month', name: 'MonthlyExpensesRepositoryImpl.getAllExpensesByMonth');
      return Success(result);
    } catch (e) {
      log('Error fetching expenses by month: $e', name: 'MonthlyExpensesRepositoryImpl.getAllExpensesByMonth', error: e);
      return Failure('Erro ao buscar despesas do mês: ${e.toString()}');
    }
  }
}
