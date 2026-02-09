import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionTile extends StatelessWidget {
  final TransactionEntity transaction;
  final CategoryEntity? category;
  final VoidCallback? onTap;
  final VoidCallback? onDismissed;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.category,
    this.onTap,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == AppConstants.typeIncome;
    final amountColor = isIncome ? AppTheme.emeraldGreen : AppTheme.roseRed;
    final prefix = isIncome ? '+' : '-';
    final categoryColor = category != null
        ? Color(int.parse('FF${category!.colorHex}', radix: 16))
        : Colors.grey;

    Widget tile = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                category != null
                    ? IconData(category!.iconCode, fontFamily: 'MaterialIcons')
                    : Icons.category,
                color: categoryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    DateFormatter.relativeDate(transaction.date),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              '$prefix${CurrencyFormatter.format(transaction.amount)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: amountColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );

    if (onDismissed != null) {
      tile = Dismissible(
        key: ValueKey(transaction.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: AppTheme.roseRed.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.delete_outline, color: AppTheme.roseRed),
        ),
        onDismissed: (_) => onDismissed!(),
        child: tile,
      );
    }

    return tile;
  }
}
