
import 'package:equatable/equatable.dart';
import 'package:financas/domain/model/monthly_expenses/monthly_expenses_model.dart';

abstract class ChartsState extends Equatable {
  const ChartsState();

  @override
  List<Object> get props => [];
}

class ChartsInitial extends ChartsState {}

class ChartsLoading extends ChartsState {}

class ChartsLoaded extends ChartsState {
  final Map<String, double> expensesByCategory;
  final List<MonthlyExpenses> expenses;
  final int selectedMonth;
  final int selectedYear;
  final String selectedCategory;
  final List<String> categories;

  const ChartsLoaded({
    required this.expensesByCategory,
    required this.expenses,
    required this.selectedMonth,
    required this.selectedYear,
    required this.selectedCategory,
    required this.categories,
  });

  @override
  List<Object> get props => [
        expensesByCategory,
        expenses,
        selectedMonth,
        selectedYear,
        categories,
      ];
}

class ChartsError extends ChartsState {
  final String message;

  const ChartsError(this.message);

  @override
  List<Object> get props => [message];
}