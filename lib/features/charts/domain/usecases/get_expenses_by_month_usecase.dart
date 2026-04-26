import 'package:financas/core/result/result.dart';
import 'package:financas/features/charts/domain/repository/charts_repository.dart';
import 'package:financas/features/monthly_expenses/domain/entities/monthly_expenses_entity.dart';

class GetExpensesByMonthUseCase {
  final ChartsRepository repository;

  GetExpensesByMonthUseCase(this.repository);

  Future<Result<List<MonthlyExpenses>>> execute(int month, int year, {String? category}) {
    return repository.getExpensesByMonth(month, year, category: category);
  }
}
