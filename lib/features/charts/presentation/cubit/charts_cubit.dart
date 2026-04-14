import 'package:financas/core/result/result.dart';
import 'package:financas/features/charts/data/repositories/charts_repository.dart';
import 'package:financas/core/enum/enum_categories.dart';
import 'package:financas/features/charts/presentation/cubit/charts_state.dart';
import 'package:financas/features/monthly_expenses/domain/entities/monthly_expenses_entity.dart';
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

      final groupedResult = await _repository.getExpensesGroupedByCategory(
        selectedMonth,
        selectedYear,
        category: null,
      );

      final expensesResult = await _repository.getExpensesByMonth(
        selectedMonth,
        selectedYear,
        category: null,
      );

      if (groupedResult is Success<Map<String, double>> &&
          expensesResult is Success<List<MonthlyExpenses>>) {
        final categories = ['', ...Categories.values.map((e) => e.label)];
        
        emit(ChartsLoaded(
          expensesByCategory: (groupedResult).data,
          expenses: (expensesResult).data,
          selectedMonth: selectedMonth,
          selectedYear: selectedYear,
          selectedCategory: selectedCategory,
          categories: categories,
        ));
        log('ChartsLoaded state emitted');
      } else {
        String errorMsg = 'Erro ao carregar dados';
        if (groupedResult is Failure) errorMsg = (groupedResult as Failure).message;
        if (expensesResult is Failure) errorMsg = (expensesResult as Failure).message;
        emit(ChartsError(errorMsg));
      }
    } catch (e) {
      log('Error loading chart data: $e');
      emit(ChartsError('Erro ao carregar os dados do gráfico: $e'));
    }
  }
}
