import 'package:financas/domain/entities/monthly_expenses/monthly_expenses_entity.dart';

abstract class MonthlyExpensesState {}

class MonthlyExpensesInitial extends MonthlyExpensesState {}

class MonthlyExpensesLoading extends MonthlyExpensesState {}

class MonthlyExpensesLoaded extends MonthlyExpensesState {
  final List<MonthlyExpenses> expenses;

  double get totalAmount => expenses.fold(0.0, (sum, item) => sum + item.amount);

  MonthlyExpensesLoaded(this.expenses);
}

class MonthlyExpensesError extends MonthlyExpensesState {
  final String message;

  MonthlyExpensesError(this.message);
}
