import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final int categoryId;
  final String type; // 'income' or 'expense'
  final String? note;

  const TransactionEntity({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.categoryId,
    required this.type,
    this.note,
  });

  bool get isIncome => type == 'income';
  bool get isExpense => type == 'expense';

  TransactionEntity copyWith({
    int? id,
    String? title,
    double? amount,
    DateTime? date,
    int? categoryId,
    String? type,
    String? note,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [id, title, amount, date, categoryId, type, note];
}
