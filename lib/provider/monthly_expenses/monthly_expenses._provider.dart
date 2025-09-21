import 'package:financas/data/database/local/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:financas/model/monthly%20epenses/monthly_expenses_model.dart';

class MonthlyExpensesProvider extends ChangeNotifier {
  List<MonthlyExpenses> _expenses = [];
  final SqliteDataBase _sqliteDatabase;

  MonthlyExpensesProvider(this._sqliteDatabase);

  List<MonthlyExpenses> get getExpenses => _expenses;

  Future<void> saveLocalExpenses(MonthlyExpenses expenses) async {
    try {
      await _sqliteDatabase.createExpense(expenses);

      _expenses = await _sqliteDatabase.getAllExpenses();
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao salvar a conta: $e');
    }
  }

  Future<List<MonthlyExpenses>> loadLocalExpenses() async {
    try {
      _expenses = await _sqliteDatabase.getAllExpenses();
      notifyListeners();
      return _expenses;
    } catch (e) {
      throw Exception('Erro ao carregar as contas: $e');
    }
  }

  Future<void> updateExpense(MonthlyExpenses expense) async {
    try {
      await _sqliteDatabase.updateExpense(expense);
      _expenses = await _sqliteDatabase.getAllExpenses();
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao atualizar a conta: $e');
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _sqliteDatabase.deleteExpense(id);
      _expenses = await _sqliteDatabase.getAllExpenses();
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao deletar a conta: $e');
    }
  }
}
