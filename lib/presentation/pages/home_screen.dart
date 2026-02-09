import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/theme/theme_cubit.dart';
import '../../core/utils/pdf_export_service.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import 'add_transaction_screen.dart';
import 'dashboard_screen.dart';
import 'savings_screen.dart';
import 'transactions_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _switchTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          if (_currentIndex == 0)
            IconButton(
              onPressed: () => _showAppInfo(context),
              icon: const Icon(Icons.info_outline_rounded),
              tooltip: 'Info Aplikasi',
            ),
          if (_currentIndex == 1)
            IconButton(
              onPressed: () => _showExportDialog(context),
              icon: const Icon(Icons.download_rounded),
              tooltip: 'Export PDF',
            ),
          IconButton(
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            icon: Icon(
              context.watch<ThemeCubit>().isDark
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
            tooltip: 'Ganti Tema',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardScreen(onTabSwitch: _switchTab),
          const TransactionsScreen(),
          const SavingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _switchTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings_rounded),
            label: 'Tabungan',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onFabPressed(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onFabPressed(BuildContext context) {
    if (_currentIndex == 2) {
      showAddSavingsGoalDialog(context);
    } else {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const AddTransactionScreen()));
    }
  }

  void _showExportDialog(BuildContext parentContext) {
    final now = DateTime.now();
    int selectedYear = now.year;
    int selectedMonth = now.month;

    showModalBottomSheet(
      context: parentContext,
      backgroundColor: AppColors.of(parentContext).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (_, setSheetState) {
            final monthName = DateFormat(
              'MMMM yyyy',
              'id_ID',
            ).format(DateTime(selectedYear, selectedMonth));

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.of(parentContext).textSecondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Export Laporan PDF',
                    style: Theme.of(parentContext).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setSheetState(() {
                            if (selectedMonth == 1) {
                              selectedMonth = 12;
                              selectedYear--;
                            } else {
                              selectedMonth--;
                            }
                          });
                        },
                        icon: Icon(
                          Icons.chevron_left,
                          color: AppColors.of(parentContext).textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        monthName,
                        style: Theme.of(parentContext).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed:
                            (selectedYear < now.year ||
                                selectedMonth < now.month)
                            ? () {
                                setSheetState(() {
                                  if (selectedMonth == 12) {
                                    selectedMonth = 1;
                                    selectedYear++;
                                  } else {
                                    selectedMonth++;
                                  }
                                });
                              }
                            : null,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _doExport(parentContext, selectedYear, selectedMonth);
                      },
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text(
                        'Export & Bagikan',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.emeraldGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _doExport(BuildContext context, int year, int month) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Membuat laporan PDF...',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        backgroundColor: AppColors.of(context).cardColor,
        duration: Duration(seconds: 1),
      ),
    );

    try {
      final transactionRepo = context.read<TransactionRepository>();
      final categoryRepo = context.read<CategoryRepository>();

      final transactions = await transactionRepo.getTransactionsByMonth(
        year,
        month,
      );
      final categories = await categoryRepo.getAllCategories();
      final totalIncome = await transactionRepo.getTotalIncomeByMonth(
        year,
        month,
      );
      final totalExpense = await transactionRepo.getTotalExpenseByMonth(
        year,
        month,
      );

      final file = await PdfExportService.generatePdf(
        transactions: transactions,
        categories: categories,
        year: year,
        month: month,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
      );

      if (context.mounted) {
        _showExportResultSheet(context, file, year, month);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal export: $e'),
            backgroundColor: AppTheme.roseRed,
          ),
        );
      }
    }
  }

  void _showExportResultSheet(
    BuildContext context,
    File file,
    int year,
    int month,
  ) {
    final monthName = DateFormat(
      'MMMM yyyy',
      'id_ID',
    ).format(DateTime(year, month));
    final fileName = file.path.split('/').last;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(24),
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
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.emeraldGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppTheme.emeraldGreen,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'PDF Berhasil Dibuat!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Laporan $monthName',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                fileName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: AppColors.of(context).textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          PdfExportService.openPdf(file);
                        },
                        icon: const Icon(Icons.visibility_rounded),
                        label: const Text('Buka PDF'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.of(
                            sheetContext,
                          ).textPrimary,
                          side: BorderSide(
                            color: AppColors.of(sheetContext).textSecondary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: Builder(
                        builder: (btnContext) {
                          return ElevatedButton.icon(
                            onPressed: () {
                              final box =
                                  btnContext.findRenderObject() as RenderBox;
                              final origin =
                                  box.localToGlobal(Offset.zero) & box.size;
                              Navigator.pop(sheetContext);
                              PdfExportService.sharePdf(
                                file,
                                year: year,
                                month: month,
                                origin: origin,
                              );
                            },
                            icon: const Icon(Icons.share_rounded),
                            label: const Text('Bagikan'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.emeraldGreen,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showAppInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
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
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.emeraldGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppTheme.emeraldGreen,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Financial Privacy',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Versi ${AppConstants.appVersion}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Aplikasi pencatatan keuangan pribadi.\nData tersimpan lokal di perangkat Anda.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  static const _titles = ['Dashboard', 'Transaksi', 'Tabungan'];
}
