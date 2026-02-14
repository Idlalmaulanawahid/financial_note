class AppConstants {
  AppConstants._();

  static const String appName = 'Financial Privacy';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
  static const String dbName = 'note_money.db';
  static const int dbVersion = 1;

  // Table names
  static const String tableTransactions = 'transactions';
  static const String tableCategories = 'categories';
  static const String tableSavingsGoals = 'savings_goals';

  // Transaction types
  static const String typeIncome = 'income';
  static const String typeExpense = 'expense';

  // Default categories
  static const List<Map<String, dynamic>> defaultCategories = [
    {'name': 'Makanan', 'icon_code': 0xe25a, 'color_hex': 'FF8A65'},
    {'name': 'Transportasi', 'icon_code': 0xe1d5, 'color_hex': '64B5F6'},
    {'name': 'Belanja', 'icon_code': 0xef52, 'color_hex': 'BA68C8'},
    {'name': 'Hiburan', 'icon_code': 0xe40f, 'color_hex': 'FFD54F'},
    {'name': 'Kesehatan', 'icon_code': 0xe559, 'color_hex': 'E57373'},
    {'name': 'Pendidikan', 'icon_code': 0xeb44, 'color_hex': '4DB6AC'},
    {'name': 'Gaji', 'icon_code': 0xe0af, 'color_hex': '81C784'},
    {'name': 'Investasi', 'icon_code': 0xe8e5, 'color_hex': '4FC3F7'},
    {'name': 'Lainnya', 'icon_code': 0xe8fe, 'color_hex': '90A4AE'},
  ];
}
