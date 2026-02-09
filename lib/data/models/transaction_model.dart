import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    super.id,
    required super.title,
    required super.amount,
    required super.date,
    required super.categoryId,
    required super.type,
    super.note,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      categoryId: map['category_id'] as int,
      type: map['type'] as String,
      note: map['note'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category_id': categoryId,
      'type': type,
      'note': note,
    };
  }

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      date: entity.date,
      categoryId: entity.categoryId,
      type: entity.type,
      note: entity.note,
    );
  }
}
