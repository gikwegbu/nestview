// lib/core/utils/currency_formatter.dart
import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final _gbpFormatter = NumberFormat.currency(
    locale: 'en_GB',
    symbol: '£',
    decimalDigits: 0,
  );

  static final _gbpFormatterWithPence = NumberFormat.currency(
    locale: 'en_GB',
    symbol: '£',
    decimalDigits: 2,
  );

  static String format(double amount, {bool includePence = false}) {
    if (includePence) return _gbpFormatterWithPence.format(amount);
    return _gbpFormatter.format(amount);
  }

  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return '£${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 100000) {
      return '£${(amount / 1000).toStringAsFixed(0)}k';
    }
    return format(amount);
  }

  static String formatPerMonth(double amount) {
    return '${format(amount)}/pcm';
  }

  static String formatRange(double min, double max) {
    return '${formatCompact(min)} – ${formatCompact(max)}';
  }

  static double parseGBP(String value) {
    return double.tryParse(value.replaceAll(RegExp(r'[£,\s]'), '')) ?? 0;
  }
}
