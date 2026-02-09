import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/category_repository.dart';
import '../../../domain/repositories/transaction_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final TransactionRepository _transactionRepository;
  final CategoryRepository _categoryRepository;

  DashboardBloc(this._transactionRepository, this._categoryRepository)
      : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    await _loadData(emit);
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    await _loadData(emit);
  }

  Future<void> _loadData(Emitter<DashboardState> emit) async {
    try {
      final now = DateTime.now();

      final balance = await _transactionRepository.getTotalBalance();
      final income = await _transactionRepository.getTotalIncomeByMonth(
          now.year, now.month);
      final expense = await _transactionRepository.getTotalExpenseByMonth(
          now.year, now.month);
      final expenseByCategory =
          await _transactionRepository.getExpenseByCategory(
              now.year, now.month);
      final categories = await _categoryRepository.getAllCategories();
      final recentTransactions =
          await _transactionRepository.getRecentTransactions(5);

      emit(DashboardLoaded(
        totalBalance: balance,
        monthlyIncome: income,
        monthlyExpense: expense,
        expenseByCategory: expenseByCategory,
        categories: categories,
        recentTransactions: recentTransactions,
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
