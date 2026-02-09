import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/database_helper.dart';
import 'data/repositories/category_repository_impl.dart';
import 'data/repositories/savings_goal_repository_impl.dart';
import 'data/repositories/transaction_repository_impl.dart';
import 'domain/repositories/category_repository.dart';
import 'domain/repositories/savings_goal_repository.dart';
import 'domain/repositories/transaction_repository.dart';
import 'presentation/blocs/category/category_bloc.dart';
import 'presentation/blocs/category/category_event.dart';
import 'presentation/blocs/dashboard/dashboard_bloc.dart';
import 'presentation/blocs/dashboard/dashboard_event.dart';
import 'presentation/blocs/savings/savings_bloc.dart';
import 'presentation/blocs/savings/savings_event.dart';
import 'presentation/blocs/transaction/transaction_bloc.dart';
import 'presentation/blocs/transaction/transaction_event.dart';
import 'presentation/blocs/theme/theme_cubit.dart';
import 'presentation/pages/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  final dbHelper = DatabaseHelper.instance;
  final transactionRepo = TransactionRepositoryImpl(dbHelper);
  final categoryRepo = CategoryRepositoryImpl(dbHelper);
  final savingsRepo = SavingsGoalRepositoryImpl(dbHelper);

  runApp(
    FinancialPrivacyApp(
      transactionRepository: transactionRepo,
      categoryRepository: categoryRepo,
      savingsGoalRepository: savingsRepo,
    ),
  );
}

class FinancialPrivacyApp extends StatelessWidget {
  final TransactionRepository transactionRepository;
  final CategoryRepository categoryRepository;
  final SavingsGoalRepository savingsGoalRepository;

  const FinancialPrivacyApp({
    super.key,
    required this.transactionRepository,
    required this.categoryRepository,
    required this.savingsGoalRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TransactionRepository>.value(
          value: transactionRepository,
        ),
        RepositoryProvider<CategoryRepository>.value(value: categoryRepository),
        RepositoryProvider<SavingsGoalRepository>.value(
          value: savingsGoalRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                DashboardBloc(transactionRepository, categoryRepository)
                  ..add(LoadDashboard()),
          ),
          BlocProvider(
            create: (_) =>
                TransactionBloc(transactionRepository)..add(LoadTransactions()),
          ),
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(
            create: (_) =>
                CategoryBloc(categoryRepository)..add(LoadCategories()),
          ),
          BlocProvider(
            create: (_) =>
                SavingsBloc(savingsGoalRepository)..add(LoadSavingsGoals()),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, mode) {
            return MaterialApp(
              title: 'Financial Privacy',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: mode,
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
