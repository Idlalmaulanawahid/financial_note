import '../../core/constants/app_constants.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/database_helper.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final DatabaseHelper _dbHelper;

  TransactionRepositoryImpl(this._dbHelper);

  @override
  Future<List<TransactionEntity>> getAllTransactions() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      AppConstants.tableTransactions,
      orderBy: 'date DESC',
    );
    return maps.map(TransactionModel.fromMap).toList();
  }

  @override
  Future<List<TransactionEntity>> getTransactionsByMonth(
      int year, int month) async {
    final db = await _dbHelper.database;
    final startDate = DateTime(year, month, 1).toIso8601String();
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59).toIso8601String();

    final maps = await db.query(
      AppConstants.tableTransactions,
      where: 'date >= ? AND date <= ?',
      whereArgs: [startDate, endDate],
      orderBy: 'date DESC',
    );
    return maps.map(TransactionModel.fromMap).toList();
  }

  @override
  Future<List<TransactionEntity>> getRecentTransactions(int limit) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      AppConstants.tableTransactions,
      orderBy: 'date DESC',
      limit: limit,
    );
    return maps.map(TransactionModel.fromMap).toList();
  }

  @override
  Future<TransactionEntity?> getTransactionById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      AppConstants.tableTransactions,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return TransactionModel.fromMap(maps.first);
  }

  @override
  Future<int> insertTransaction(TransactionEntity transaction) async {
    final db = await _dbHelper.database;
    return db.insert(
      AppConstants.tableTransactions,
      TransactionModel.fromEntity(transaction).toMap(),
    );
  }

  @override
  Future<int> updateTransaction(TransactionEntity transaction) async {
    final db = await _dbHelper.database;
    return db.update(
      AppConstants.tableTransactions,
      TransactionModel.fromEntity(transaction).toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  @override
  Future<int> deleteTransaction(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      AppConstants.tableTransactions,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<double> getTotalBalance() async {
    final db = await _dbHelper.database;
    final incomeResult = await db.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) as total FROM ${AppConstants.tableTransactions} WHERE type = ?',
      [AppConstants.typeIncome],
    );
    final expenseResult = await db.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) as total FROM ${AppConstants.tableTransactions} WHERE type = ?',
      [AppConstants.typeExpense],
    );

    final income = (incomeResult.first['total'] as num).toDouble();
    final expense = (expenseResult.first['total'] as num).toDouble();
    return income - expense;
  }

  @override
  Future<double> getTotalIncomeByMonth(int year, int month) async {
    final db = await _dbHelper.database;
    final startDate = DateTime(year, month, 1).toIso8601String();
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59).toIso8601String();

    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) as total FROM ${AppConstants.tableTransactions} WHERE type = ? AND date >= ? AND date <= ?',
      [AppConstants.typeIncome, startDate, endDate],
    );
    return (result.first['total'] as num).toDouble();
  }

  @override
  Future<double> getTotalExpenseByMonth(int year, int month) async {
    final db = await _dbHelper.database;
    final startDate = DateTime(year, month, 1).toIso8601String();
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59).toIso8601String();

    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) as total FROM ${AppConstants.tableTransactions} WHERE type = ? AND date >= ? AND date <= ?',
      [AppConstants.typeExpense, startDate, endDate],
    );
    return (result.first['total'] as num).toDouble();
  }

  @override
  Future<Map<int, double>> getExpenseByCategory(int year, int month) async {
    final db = await _dbHelper.database;
    final startDate = DateTime(year, month, 1).toIso8601String();
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59).toIso8601String();

    final result = await db.rawQuery(
      'SELECT category_id, SUM(amount) as total FROM ${AppConstants.tableTransactions} WHERE type = ? AND date >= ? AND date <= ? GROUP BY category_id',
      [AppConstants.typeExpense, startDate, endDate],
    );

    return {
      for (final row in result)
        row['category_id'] as int: (row['total'] as num).toDouble(),
    };
  }
}
