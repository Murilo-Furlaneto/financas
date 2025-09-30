import 'dart:convert';

import 'package:financas/shared/enum/enum_categories.dart';

class MonthlyExpenses {
  final String id;
  final String title;
  final Categories category;
  final double amount;
  final int dueDate;

  MonthlyExpenses({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.dueDate,
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
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'category': category.label,
      'amount': amount,
      'dueDate': dueDate,
    };
  }

  factory MonthlyExpenses.fromMap(Map<String, dynamic> map) {
    return MonthlyExpenses(
      id: map['id'] as String,
      title: map['title'] as String,
      category: Categories.values.firstWhere((element) => element.label == map['category']),
      amount: map['amount'] as double,
      dueDate: map['dueDate'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory MonthlyExpenses.fromJson(String source) =>
      MonthlyExpenses.fromMap(json.decode(source) as Map<String, dynamic>);
}
