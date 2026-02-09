import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../blocs/dashboard/dashboard_bloc.dart';
import '../blocs/dashboard/dashboard_event.dart';
import '../blocs/dashboard/dashboard_state.dart';
import '../widgets/balance_card.dart';
import '../widgets/expense_pie_chart.dart';
import '../widgets/transaction_tile.dart';

class DashboardScreen extends StatelessWidget {
  final ValueChanged<int>? onTabSwitch;

  const DashboardScreen({super.key, this.onTabSwitch});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.emeraldGreen),
          );
        }

        if (state is DashboardError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppTheme.roseRed,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      context.read<DashboardBloc>().add(LoadDashboard()),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        if (state is DashboardLoaded) {
          return RefreshIndicator(
            color: AppTheme.emeraldGreen,
            onRefresh: () async {
              context.read<DashboardBloc>().add(RefreshDashboard());
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 8),
                BalanceCard(
                  totalBalance: state.totalBalance,
                  monthlyIncome: state.monthlyIncome,
                  monthlyExpense: state.monthlyExpense,
                ),
                const SizedBox(height: 24),
                ExpensePieChart(
                  expenseByCategory: state.expenseByCategory,
                  categories: state.categories,
                ),
                const SizedBox(height: 24),
                _buildRecentTransactions(context, state),
                const SizedBox(height: 80),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildRecentTransactions(BuildContext context, DashboardLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transaksi Terbaru',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => onTabSwitch?.call(1),
              child: const Text(
                'Lihat Semua',
                style: TextStyle(color: AppTheme.emeraldGreen),
              ),
            ),
          ],
        ),
        if (state.recentTransactions.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 48,
                    color: AppColors.of(context).textSecondary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Belum ada transaksi',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: state.recentTransactions.map((transaction) {
                final category = state.categories
                    .where((c) => c.id == transaction.categoryId)
                    .firstOrNull;
                return TransactionTile(
                  transaction: transaction,
                  category: category,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
