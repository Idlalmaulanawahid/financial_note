import '../entities/savings_goal_entity.dart';

abstract class SavingsGoalRepository {
  Future<List<SavingsGoalEntity>> getAllSavingsGoals();
  Future<SavingsGoalEntity?> getSavingsGoalById(int id);
  Future<int> insertSavingsGoal(SavingsGoalEntity goal);
  Future<int> updateSavingsGoal(SavingsGoalEntity goal);
  Future<int> deleteSavingsGoal(int id);
  Future<int> addToSavings(int id, double amount);
}
