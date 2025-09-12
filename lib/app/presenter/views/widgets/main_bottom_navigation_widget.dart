import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:flutter/material.dart';

class CryptoBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CryptoBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.instance.l10n;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up, size: 20),
          activeIcon: Icon(Icons.trending_up, size: 24, color: colors.primary),
          label: l10n.market,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border, size: 20),
          activeIcon: Icon(
            Icons.favorite,
            size: 24,
            color: colors.primaryFixed,
          ),
          label: l10n.favorites,
        ),
      ],
    );
  }
}
