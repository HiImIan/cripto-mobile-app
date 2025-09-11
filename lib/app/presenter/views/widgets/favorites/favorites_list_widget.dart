import 'package:brasilcripto/app/core/routes/routes.dart';
import 'package:brasilcripto/app/presenter/view_models/cryptos_view_model.dart';
import 'package:brasilcripto/app/presenter/views/widgets/crypto_item_widget.dart';
import 'package:brasilcripto/app/presenter/views/widgets/favorites/exceptions/favorites_no_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FavoritesListWidget extends StatelessWidget {
  final CryptosViewModel cryptosViewModel;
  const FavoritesListWidget({super.key, required this.cryptosViewModel});

  @override
  Widget build(BuildContext context) {
    final favoriteCryptos = cryptosViewModel.favoriteCryptos;

    if (favoriteCryptos.isEmpty) return FavoritesNoItemWidget();

    final length = favoriteCryptos.length;

    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 4),
      itemCount: length,
      itemBuilder: (context, index) {
        final favoriteCrypto = favoriteCryptos[index];
        return GestureDetector(
          onTap: () => context.push(Routes.cryptoDetails(favoriteCrypto.id)),
          child: CryptosItemWidget(
            crypto: favoriteCrypto,
            onFavoriteToggle: () {
              cryptosViewModel.toggleFavorite(favoriteCrypto.id);
            },
          ),
        );
      },
    );
  }
}
