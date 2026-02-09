import '../../core/constants/app_constants.dart';
import '../../domain/entities/savings_goal_entity.dart';
import '../../domain/repositories/savings_goal_repository.dart';
import '../datasources/database_helper.dart';
import '../models/savings_goal_model.dart';

class SavingsGoalRepositoryImpl implements SavingsGoalRepository {
  final DatabaseHelper _dbHelper;

  SavingsGoalRepositoryImpl(this._dbHelper);

  @override
  Future<List<SavingsGoalEntity>> getAllSavingsGoals() async {
    final db = await _dbHelper.database;
    final maps = await db.query(AppConstants.tableSavingsGoals);
    return maps.map(SavingsGoalModel.fromMap).toList();
  }

  @override
  Future<SavingsGoalEntity?> getSavingsGoalById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      AppConstants.tableSavingsGoals,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return SavingsGoalModel.fromMap(maps.first);
  }

  @override
  Future<int> insertSavingsGoal(SavingsGoalEntity goal) async {
    final db = await _dbHelper.database;
    return db.insert(
      AppConstants.tableSavingsGoals,
      SavingsGoalModel.fromEntity(goal).toMap(),
    );
  }

  @override
  Future<int> updateSavingsGoal(SavingsGoalEntity goal) async {
    final db = await _dbHelper.database;
    return db.update(
      AppConstants.tableSavingsGoals,
      SavingsGoalModel.fromEntity(goal).toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

  @override
  Future<int> deleteSavingsGoal(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      AppConstants.tableSavingsGoals,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> addToSavings(int id, double amount) async {
    final db = await _dbHelper.database;
    return db.rawUpdate(
      'UPDATE ${AppConstants.tableSavingsGoals} SET current_amount = current_amount + ? WHERE id = ?',
      [amount, id],
    );
  }
}
