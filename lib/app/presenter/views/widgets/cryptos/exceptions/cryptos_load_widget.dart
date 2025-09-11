import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:flutter/material.dart';

class CryptosLoadWidget extends StatelessWidget {
  const CryptosLoadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.instance.l10n;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textStyle = theme.textTheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.loading,
            textAlign: TextAlign.center,
            style: textStyle.titleLarge,
          ),
          SizedBox(height: 20),
          CircularProgressIndicator(color: colors.primary),
        ],
      ),
    );
  }
}
