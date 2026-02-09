import 'package:equatable/equatable.dart';

import '../../../domain/entities/savings_goal_entity.dart';

abstract class SavingsEvent extends Equatable {
  const SavingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavingsGoals extends SavingsEvent {}

class AddSavingsGoal extends SavingsEvent {
  final SavingsGoalEntity goal;

  const AddSavingsGoal(this.goal);

  @override
  List<Object?> get props => [goal];
}

class UpdateSavingsGoal extends SavingsEvent {
  final SavingsGoalEntity goal;

  const UpdateSavingsGoal(this.goal);

  @override
  List<Object?> get props => [goal];
}

class DeleteSavingsGoal extends SavingsEvent {
  final int id;

  const DeleteSavingsGoal(this.id);

  @override
  List<Object?> get props => [id];
}

class AddToSavings extends SavingsEvent {
  final int id;
  final double amount;

  const AddToSavings(this.id, this.amount);

  @override
  List<Object?> get props => [id, amount];
}
