import 'package:financas/features/monthly_expenses/domain/entities/monthly_expenses_entity.dart';

abstract class MonthlyExpensesState {}

class MonthlyExpensesInitial extends MonthlyExpensesState {}

class MonthlyExpensesLoading extends MonthlyExpensesState {}

class MonthlyExpensesLoaded extends MonthlyExpensesState {
  final List<MonthlyExpenses> expenses;

  MonthlyExpensesLoaded(this.expenses);

  double get totalAmount => expenses.fold(0, (sum, item) => sum + item.amount);
}

class MonthlyExpensesError extends MonthlyExpensesState {
  final String message;

  MonthlyExpensesError(this.message);
}
