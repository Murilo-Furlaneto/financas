import 'package:financas/core/result/result.dart';
import 'package:financas/features/monthly_expenses/domain/entities/monthly_expenses_entity.dart';
import 'package:financas/features/monthly_expenses/domain/repository/monthly_expenses_repository.dart';

class UpdateExpenseUseCase {
  final MonthlyExpensesRepository repository;

  UpdateExpenseUseCase(this.repository);

  Future<Result<void>> execute(MonthlyExpenses expense) {
    return repository.updateExpense(expense);
  }
}
