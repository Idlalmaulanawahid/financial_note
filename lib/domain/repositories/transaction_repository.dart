import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<List<TransactionEntity>> getAllTransactions();
  Future<List<TransactionEntity>> getTransactionsByMonth(int year, int month);
  Future<List<TransactionEntity>> getRecentTransactions(int limit);
  Future<TransactionEntity?> getTransactionById(int id);
  Future<int> insertTransaction(TransactionEntity transaction);
  Future<int> updateTransaction(TransactionEntity transaction);
  Future<int> deleteTransaction(int id);
  Future<double> getTotalBalance();
  Future<double> getTotalIncomeByMonth(int year, int month);
  Future<double> getTotalExpenseByMonth(int year, int month);
  Future<Map<int, double>> getExpenseByCategory(int year, int month);
}
