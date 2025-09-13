import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:brasilcripto/app/presenter/models/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailsPriceWidget extends StatelessWidget {
  final Crypto crypto;
  const DetailsPriceWidget({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textStyle = theme.textTheme;

    final l10n = LocalizationService.instance.l10n;

    final currentPrice = crypto.currentPrice;
    final percentageChange = crypto.percentageChange;

    if (currentPrice == null) return const SizedBox.shrink();

    final isPositive = percentageChange != null && percentageChange >= 0;
    final changeColor = isPositive ? colors.primary : colors.inversePrimary;

    final changeBackgroundColor = isPositive
        ? colors.primaryFixedDim
        : colors.onPrimaryFixedVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            NumberFormat.currency(
              locale: 'pt_BR',
              symbol: 'R\$ ',
              decimalDigits: currentPrice < 1 ? 6 : 2,
            ).format(currentPrice),
            style: textStyle.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          if (percentageChange != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: changeBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    size: 16,
                    color: changeColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.valuePercentage(percentageChange.toStringAsFixed(2)),
                    style: textStyle.bodySmall?.copyWith(
                      color: changeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
