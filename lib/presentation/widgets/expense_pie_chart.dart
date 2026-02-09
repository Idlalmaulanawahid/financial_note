import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/entities/category_entity.dart';

class ExpensePieChart extends StatelessWidget {
  final Map<int, double> expenseByCategory;
  final List<CategoryEntity> categories;

  const ExpensePieChart({
    super.key,
    required this.expenseByCategory,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    if (expenseByCategory.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.pie_chart_outline,
                size: 48,
                color: AppColors.of(context).textSecondary,
              ),
              const SizedBox(height: 12),
              Text(
                'Belum ada pengeluaran bulan ini',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    final totalExpense = expenseByCategory.values.fold(
      0.0,
      (sum, val) => sum + val,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengeluaran Bulan Ini',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: _buildSections(totalExpense),
                centerSpaceRadius: 50,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ..._buildLegend(context, totalExpense),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(double totalExpense) {
    return expenseByCategory.entries.map((entry) {
      final category = categories.where((c) => c.id == entry.key).firstOrNull;
      final percentage = (entry.value / totalExpense * 100);
      final color = category != null
          ? Color(int.parse('FF${category.colorHex}', radix: 16))
          : Colors.grey;

      return PieChartSectionData(
        value: entry.value,
        title: '${percentage.toStringAsFixed(0)}%',
        color: color,
        radius: 35,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();
  }

  List<Widget> _buildLegend(BuildContext context, double totalExpense) {
    return expenseByCategory.entries.map((entry) {
      final category = categories.where((c) => c.id == entry.key).firstOrNull;
      final color = category != null
          ? Color(int.parse('FF${category.colorHex}', radix: 16))
          : Colors.grey;

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                category?.name ?? 'Lainnya',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text(
              CurrencyFormatter.format(entry.value),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.of(context).textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
