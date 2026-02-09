import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String format(double amount) {
    return _formatter.format(amount);
  }

  static String formatCompact(double amount) {
    if (amount.abs() >= 1e9) {
      return 'Rp ${(amount / 1e9).toStringAsFixed(1)}M';
    } else if (amount.abs() >= 1e6) {
      return 'Rp ${(amount / 1e6).toStringAsFixed(1)}Jt';
    } else if (amount.abs() >= 1e3) {
      return 'Rp ${(amount / 1e3).toStringAsFixed(0)}Rb';
    }
    return format(amount);
  }
}
