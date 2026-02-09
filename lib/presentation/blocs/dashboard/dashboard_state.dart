import 'package:equatable/equatable.dart';

import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/transaction_entity.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpense;
  final Map<int, double> expenseByCategory;
  final List<CategoryEntity> categories;
  final List<TransactionEntity> recentTransactions;

  const DashboardLoaded({
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.expenseByCategory,
    required this.categories,
    required this.recentTransactions,
  });

  @override
  List<Object?> get props => [
        totalBalance,
        monthlyIncome,
        monthlyExpense,
        expenseByCategory,
        categories,
        recentTransactions,
      ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
