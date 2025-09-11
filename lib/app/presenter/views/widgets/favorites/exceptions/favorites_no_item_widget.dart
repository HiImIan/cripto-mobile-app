import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:flutter/material.dart';

class FavoritesNoItemWidget extends StatelessWidget {
  const FavoritesNoItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = LocalizationService.instance.l10n;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: colors.tertiary,
            child: Icon(Icons.attach_money, color: colors.surface, size: 40),
          ),
          SizedBox(height: 16),
          Text(
            l10n.noFavoriteCryptos,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
