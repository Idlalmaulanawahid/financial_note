import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';

class BalanceCard extends StatelessWidget {
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpense;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.of(context).surfaceColor,
            AppColors.of(context).cardColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Saldo',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.of(context).textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.format(totalBalance),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: totalBalance >= 0
                  ? AppTheme.emeraldGreen
                  : AppTheme.roseRed,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _IncomeExpenseItem(
                  label: 'Pemasukan',
                  amount: monthlyIncome,
                  icon: Icons.arrow_downward_rounded,
                  color: AppTheme.emeraldGreen,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _IncomeExpenseItem(
                  label: 'Pengeluaran',
                  amount: monthlyExpense,
                  icon: Icons.arrow_upward_rounded,
                  color: AppTheme.roseRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IncomeExpenseItem extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;

  const _IncomeExpenseItem({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                CurrencyFormatter.format(amount),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: color, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
