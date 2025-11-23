import 'package:financas/domain/entities/monthly_expenses/monthly_expenses_entity.dart';

class ExpenseDto {
  final String id;
  final String title;
  final String category;
  final double amount;
  final int dueDate;

  ExpenseDto({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.dueDate,
  });

  factory ExpenseDto.fromModel(MonthlyExpenses model) {
    return ExpenseDto(
      id: model.id,
      title: model.title,
      category: model.category.label,
      amount: model.amount,
      dueDate: model.dueDate,
    );
  }
}
