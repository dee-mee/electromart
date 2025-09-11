import 'package:intl/intl.dart';

String formatCurrencyKsh(double amount) {
  final formatter = NumberFormat.currency(
    locale: 'en_KE',
    symbol: 'KSH ',
    decimalDigits: 2,
  );
  return formatter.format(amount);
}
