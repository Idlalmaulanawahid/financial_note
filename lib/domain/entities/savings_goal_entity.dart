import 'package:equatable/equatable.dart';

class SavingsGoalEntity extends Equatable {
  final int? id;
  final String targetName;
  final double targetAmount;
  final double currentAmount;
  final DateTime? deadline;

  const SavingsGoalEntity({
    this.id,
    required this.targetName,
    required this.targetAmount,
    required this.currentAmount,
    this.deadline,
  });

  double get progressPercentage {
    if (targetAmount <= 0) return 0;
    return (currentAmount / targetAmount * 100).clamp(0, 100);
  }

  bool get isCompleted => currentAmount >= targetAmount;

  double get remainingAmount => (targetAmount - currentAmount).clamp(0, double.infinity);

  SavingsGoalEntity copyWith({
    int? id,
    String? targetName,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
  }) {
    return SavingsGoalEntity(
      id: id ?? this.id,
      targetName: targetName ?? this.targetName,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
    );
  }

  @override
  List<Object?> get props => [id, targetName, targetAmount, currentAmount, deadline];
}
