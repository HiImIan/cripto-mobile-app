import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:brasilcripto/app/presenter/models/crypto.dart';
import 'package:flutter/material.dart';

class DetailsEmptyChartWidget extends StatelessWidget {
  final Crypto crypto;
  const DetailsEmptyChartWidget({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textStyle = theme.textTheme;

    final l10n = LocalizationService.instance.l10n;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.show_chart, size: 48, color: colors.outline),
            const SizedBox(height: 16),
            Text(
              l10n.noChartData,
              style: textStyle.titleMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noChartDetails(crypto.name),
              style: textStyle.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
