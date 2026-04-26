import 'package:financas/core/result/result.dart';
import 'package:financas/features/monthly_expenses/domain/repository/monthly_expenses_repository.dart';

class DeleteExpenseUseCase {
  final MonthlyExpensesRepository repository;

  DeleteExpenseUseCase(this.repository);

  Future<Result<void>> execute(String id) {
    return repository.deleteExpense(id);
  }
}
