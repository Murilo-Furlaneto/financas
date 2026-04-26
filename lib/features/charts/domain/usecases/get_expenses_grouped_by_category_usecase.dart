import 'package:financas/core/result/result.dart';
import 'package:financas/features/charts/domain/repository/charts_repository.dart';

class GetExpensesGroupedByCategoryUseCase {
  final ChartsRepository repository;

  GetExpensesGroupedByCategoryUseCase(this.repository);

  Future<Result<Map<String, double>>> execute(int month, int year, {String? category}) {
    return repository.getExpensesGroupedByCategory(month, year, category: category);
  }
}
