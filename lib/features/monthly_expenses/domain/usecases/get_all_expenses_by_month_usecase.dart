import 'package:financas/core/result/result.dart';
import 'package:financas/features/monthly_expenses/domain/entities/monthly_expenses_entity.dart';
import 'package:financas/features/monthly_expenses/domain/repository/monthly_expenses_repository.dart';

class GetAllExpensesByMonthUseCase {
  final MonthlyExpensesRepository repository;

  GetAllExpensesByMonthUseCase(this.repository);

  Future<Result<List<MonthlyExpenses>>> execute(int month, int year) {
    return repository.getAllExpensesByMonth(month, year);
  }
}
