import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/savings_goal_entity.dart';
import '../blocs/savings/savings_bloc.dart';
import '../blocs/savings/savings_event.dart';
import '../blocs/savings/savings_state.dart';
import '../widgets/savings_progress_card.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavingsBloc, SavingsState>(
      builder: (context, state) {
        if (state is SavingsLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.emeraldGreen),
          );
        }

        if (state is SavingsError) {
          return Center(child: Text(state.message));
        }

        if (state is SavingsLoaded) {
          if (state.goals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.savings,
                    size: 64,
                    color: AppColors.of(context).textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada target tabungan',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tekan + untuk menambahkan target',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: state.goals.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final goal = state.goals[index];
              return SavingsProgressCard(
                goal: goal,
                onAddAmount: () => _showAddAmountDialog(context, goal),
                onTap: () => _showGoalOptions(context, goal),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _showAddAmountDialog(BuildContext context, SavingsGoalEntity goal) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.of(dialogContext).cardColor,
        title: Text(
          'Tambah Tabungan',
          style: TextStyle(color: AppColors.of(dialogContext).textPrimary),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: TextStyle(color: AppColors.of(dialogContext).textPrimary),
          decoration: const InputDecoration(
            labelText: 'Jumlah',
            prefixText: 'Rp ',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Batal',
              style: TextStyle(
                color: AppColors.of(dialogContext).textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0 && goal.id != null) {
                context.read<SavingsBloc>().add(AddToSavings(goal.id!, amount));
                Navigator.pop(dialogContext);
              }
            },
            child: const Text(
              'Tambah',
              style: TextStyle(color: AppTheme.emeraldGreen),
            ),
          ),
        ],
      ),
    );
  }

  void _showGoalOptions(BuildContext context, SavingsGoalEntity goal) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.of(context).textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              goal.targetName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: AppTheme.roseRed,
              ),
              title: const Text(
                'Hapus Target',
                style: TextStyle(color: AppTheme.roseRed),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                if (goal.id != null) {
                  context.read<SavingsBloc>().add(DeleteSavingsGoal(goal.id!));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

void showAddSavingsGoalDialog(BuildContext context) {
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.of(dialogContext).cardColor,
      title: Text(
        'Target Tabungan Baru',
        style: TextStyle(color: AppColors.of(dialogContext).textPrimary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            style: TextStyle(color: AppColors.of(dialogContext).textPrimary),
            decoration: const InputDecoration(labelText: 'Nama Target'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(color: AppColors.of(dialogContext).textPrimary),
            decoration: const InputDecoration(
              labelText: 'Jumlah Target',
              prefixText: 'Rp ',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(
            'Batal',
            style: TextStyle(color: AppColors.of(dialogContext).textSecondary),
          ),
        ),
        TextButton(
          onPressed: () {
            final name = nameController.text.trim();
            final amount = double.tryParse(amountController.text);
            if (name.isNotEmpty && amount != null && amount > 0) {
              context.read<SavingsBloc>().add(
                AddSavingsGoal(
                  SavingsGoalEntity(
                    targetName: name,
                    targetAmount: amount,
                    currentAmount: 0,
                  ),
                ),
              );
              Navigator.pop(dialogContext);
            }
          },
          child: const Text(
            'Simpan',
            style: TextStyle(color: AppTheme.emeraldGreen),
          ),
        ),
      ],
    ),
  );
}
