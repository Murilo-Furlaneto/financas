import 'package:financas/core/enum/enum_categories.dart';

class MonthlyExpenses {
  final String id;
  final String title;
  final Categories category;
  final double amount;
  final int dueDate;
  final int createdAt;

  MonthlyExpenses({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.dueDate,
    required this.createdAt,
  });

  MonthlyExpenses copyWith({
    String? id,
    String? title,
    Categories? category,
    double? amount,
    int? dueDate,
  }) {
    return MonthlyExpenses(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category.label,
      'amount': amount,
      'dueDate': dueDate,
      'createdAt': createdAt,
    };
  }

  factory MonthlyExpenses.fromMap(Map<String, dynamic> map) {
    return MonthlyExpenses(
      id: map['id'],
      title: map['title'],
      category: Categories.values.firstWhere((e) => e.label == map['category']),
      amount: map['amount'],
      dueDate: map['dueDate'],
      createdAt: map['createdAt'],
    );
  }
}
