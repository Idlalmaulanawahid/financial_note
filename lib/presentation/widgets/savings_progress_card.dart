import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/entities/savings_goal_entity.dart';

class SavingsProgressCard extends StatelessWidget {
  final SavingsGoalEntity goal;
  final VoidCallback? onTap;
  final VoidCallback? onAddAmount;

  const SavingsProgressCard({
    super.key,
    required this.goal,
    this.onTap,
    this.onAddAmount,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal.progressPercentage / 100;
    final progressColor = goal.isCompleted
        ? AppTheme.emeraldGreen
        : const Color(0xFF4FC3F7);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: progressColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    goal.isCompleted ? Icons.check_circle : Icons.savings,
                    color: progressColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.targetName,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${goal.progressPercentage.toStringAsFixed(0)}% tercapai',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: progressColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onAddAmount != null && !goal.isCompleted)
                  IconButton(
                    onPressed: onAddAmount,
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppTheme.emeraldGreen,
                    iconSize: 28,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.of(context).cardAltColor,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  CurrencyFormatter.format(goal.currentAmount),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.of(context).textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                Text(
                  CurrencyFormatter.format(goal.targetAmount),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
