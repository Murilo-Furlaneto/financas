import 'package:financas/data/repositories/charts/charts_repository.dart';
import 'package:financas/core/enum/enum_categories.dart';
import 'package:financas/ui/charts/cubit/charts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

class ChartsCubit extends Cubit<ChartsState> {
  final ChartsRepository _repository;

  ChartsCubit(this._repository) : super(ChartsInitial());

  Future<void> loadChartData({int? month, int? year, String? category}) async {
    try {
      log('Loading chart data with month=$month, year=$year, category=$category');
      emit(ChartsLoading());

      final now = DateTime.now();
      final selectedMonth = month ?? now.month;
      final selectedYear = year ?? now.year;
      final selectedCategory = category ?? "Serviços Públicos";

      final expensesByCategory = await _repository.getExpensesGroupedByCategory(
        selectedMonth,
        selectedYear,
        category: null,
      );

      log('Expenses by category fetched: ${expensesByCategory.length} categories');

      final expenses = await _repository.getExpensesByMonth(
        selectedMonth,
        selectedYear,
        category: null,
      );

      log('Expenses by month fetched: ${expenses.length}');

      final categories = ['', ...Categories.values.map((e) => e.label)];
      emit(ChartsLoaded(
        expensesByCategory: expensesByCategory,
        expenses: expenses,
        selectedMonth: selectedMonth,
        selectedYear: selectedYear,
        selectedCategory: selectedCategory,
        categories: categories,
      ));
      log('ChartsLoaded state emitted');
    } catch (e) {
      log('Error loading chart data: $e');
      emit(ChartsError('Erro ao carregar os dados do gráfico: $e'));
    }
  }
}
