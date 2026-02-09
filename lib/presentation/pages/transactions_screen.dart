import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/category_entity.dart';
import '../blocs/category/category_bloc.dart';
import '../blocs/category/category_state.dart';
import '../blocs/dashboard/dashboard_bloc.dart';
import '../blocs/dashboard/dashboard_event.dart';
import '../blocs/transaction/transaction_bloc.dart';
import '../blocs/transaction/transaction_event.dart';
import '../blocs/transaction/transaction_state.dart';
import '../widgets/transaction_tile.dart';
import 'add_transaction_screen.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.emeraldGreen),
          );
        }

        if (state is TransactionError) {
          return Center(child: Text(state.message));
        }

        if (state is TransactionLoaded) {
          if (state.transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 64,
                    color: AppColors.of(context).textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada transaksi',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tekan + untuk menambahkan',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, catState) {
              final categories = catState is CategoryLoaded
                  ? catState.categories
                  : <CategoryEntity>[];

              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: state.transactions.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final transaction = state.transactions[index];
                  final category = categories
                      .where((c) => c.id == transaction.categoryId)
                      .firstOrNull;

                  return TransactionTile(
                    transaction: transaction,
                    category: category,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddTransactionScreen(
                            existingTransaction: transaction,
                          ),
                        ),
                      );
                    },
                    onDismissed: () {
                      if (transaction.id != null) {
                        context.read<TransactionBloc>().add(
                          DeleteTransaction(transaction.id!),
                        );
                        context.read<DashboardBloc>().add(RefreshDashboard());
                      }
                    },
                  );
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
