import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:brasilcripto/app/presenter/models/crypto.dart';
import 'package:brasilcripto/app/presenter/view_models/cryptos_view_model.dart';
import 'package:brasilcripto/app/presenter/views/widgets/favorites/exceptions/favorites_no_item_widget.dart';
import 'package:brasilcripto/app/presenter/views/widgets/item_widget.dart';
import 'package:flutter/material.dart';

class FavoritesListWidget extends StatelessWidget {
  final CryptosViewModel cryptosViewModel;

  const FavoritesListWidget({super.key, required this.cryptosViewModel});

  @override
  Widget build(BuildContext context) {
    final favoriteCryptos = cryptosViewModel.favoriteCryptos;

    if (favoriteCryptos.isEmpty) return const FavoritesNoItemWidget();

    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 4),
      itemCount: favoriteCryptos.length,
      itemBuilder: (context, index) {
        final favoriteCrypto = favoriteCryptos[index];
        return CryptosItemWidget(
          crypto: favoriteCrypto,
          onFavoriteToggle: () =>
              _handleFavoriteToggle(context, favoriteCrypto.id),
        );
      },
    );
  }

  Future<void> _handleFavoriteToggle(
    BuildContext context,
    String cryptoId,
  ) async {
    final removeInfo = cryptosViewModel.getRemoveFavoriteInfo(cryptoId);

    if (removeInfo != null) {
      final shouldRemove = await _showRemoveConfirmation(context, removeInfo);
      if (shouldRemove) await cryptosViewModel.toggleFavorite(cryptoId);
    }
  }

  Future<bool> _showRemoveConfirmation(
    BuildContext context,
    Crypto info,
  ) async {
    final l10n = LocalizationService.instance.l10n;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.removeFavorite),
        content: Text(l10n.removeNameAndSymbol(info.name, info.symbol)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: colors.error),
            child: Text(l10n.remove),
          ),
        ],
      ),
    );

    return confirmed ?? false;
  }
}
