import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:intl/intl.dart';

class Price {
  static String formatAbbr(double value) {
    if (value >= 1e12) return '${(value / 1e12).toStringAsFixed(2)}T';
    if (value >= 1e9) return '${(value / 1e9).toStringAsFixed(2)}B';
    if (value >= 1e6) return '${(value / 1e6).toStringAsFixed(2)}M';
    if (value >= 1e3) return '${(value / 1e3).toStringAsFixed(2)}K';
    return formatCurrency(value);
  }

  static String formatCurrency(double value) {
    final str = value.toString();
    final parts = str.split('.');
    if (parts.length == 1) return '$str.00';
    if (parts[1].length == 1) return '${parts[0]}.${parts[1]}0';
    return str;
  }

  static String formatterBr(double? value) {
    final l10n = LocalizationService.instance.l10n;
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: l10n.moneySymbol,
    );
    return formatter.format(value);
  }
}
