import 'package:financas/features/monthly_expenses/domain/entities/monthly_expenses_entity.dart';

abstract class ChartsState {}

class ChartsInitial extends ChartsState {}

class ChartsLoading extends ChartsState {}

class ChartsLoaded extends ChartsState {
  final Map<String, double> expensesByCategory;
  final List<MonthlyExpenses> expenses;
  final int selectedMonth;
  final int selectedYear;
  final String selectedCategory;
  final List<String> categories;

  ChartsLoaded({
    required this.expensesByCategory,
    required this.expenses,
    required this.selectedMonth,
    required this.selectedYear,
    required this.selectedCategory,
    required this.categories,
  });
}

class ChartsError extends ChartsState {
  final String message;

  ChartsError(this.message);
}
