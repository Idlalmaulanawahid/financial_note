import '../../domain/entities/savings_goal_entity.dart';

class SavingsGoalModel extends SavingsGoalEntity {
  const SavingsGoalModel({
    super.id,
    required super.targetName,
    required super.targetAmount,
    required super.currentAmount,
    super.deadline,
  });

  factory SavingsGoalModel.fromMap(Map<String, dynamic> map) {
    return SavingsGoalModel(
      id: map['id'] as int?,
      targetName: map['target_name'] as String,
      targetAmount: (map['target_amount'] as num).toDouble(),
      currentAmount: (map['current_amount'] as num).toDouble(),
      deadline: map['deadline'] != null
          ? DateTime.parse(map['deadline'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'target_name': targetName,
      'target_amount': targetAmount,
      'current_amount': currentAmount,
      'deadline': deadline?.toIso8601String(),
    };
  }

  factory SavingsGoalModel.fromEntity(SavingsGoalEntity entity) {
    return SavingsGoalModel(
      id: entity.id,
      targetName: entity.targetName,
      targetAmount: entity.targetAmount,
      currentAmount: entity.currentAmount,
      deadline: entity.deadline,
    );
  }
}
