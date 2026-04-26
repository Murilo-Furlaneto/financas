import 'package:financas/core/result/result.dart';
import 'package:financas/core/enum/enum_categories.dart';
import 'package:financas/features/charts/presentation/cubit/charts_state.dart';
import 'package:financas/features/charts/domain/usecases/get_expenses_grouped_by_category_usecase.dart';
import 'package:financas/features/charts/domain/usecases/get_expenses_by_month_usecase.dart';
import 'package:financas/features/monthly_expenses/domain/entities/monthly_expenses_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

class ChartsCubit extends Cubit<ChartsState> {
  final GetExpensesGroupedByCategoryUseCase _groupedUseCase;
  final GetExpensesByMonthUseCase _monthUseCase;

  ChartsCubit(this._groupedUseCase, this._monthUseCase) : super(ChartsInitial());

  Future<void> loadChartData({int? month, int? year, String? category}) async {
    try {
      log('Loading chart data with month=$month, year=$year, category=$category');
      emit(ChartsLoading());

      final now = DateTime.now();
      final selectedMonth = month ?? now.month;
      final selectedYear = year ?? now.year;
      final selectedCategory = category ?? "Serviços Públicos";

      final groupedResult = await _groupedUseCase.execute(
        selectedMonth,
        selectedYear,
        category: null,
      );

      final expensesResult = await _monthUseCase.execute(
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
