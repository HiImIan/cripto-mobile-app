import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:flutter/material.dart';

class CryptosLoadMoreWidget extends StatelessWidget {
  const CryptosLoadMoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textStyle = theme.textTheme;

    final l10n = LocalizationService.instance.l10n;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: Container(
        height: 80,
        color: colors.primaryContainer,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colors.primary, strokeWidth: 2),
            SizedBox(height: 12),
            Text(l10n.loadingMoreCryptos, style: textStyle.labelSmall),
          ],
        ),
      ),
    );
  }
}
