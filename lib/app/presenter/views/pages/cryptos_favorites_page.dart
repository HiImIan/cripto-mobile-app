import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:brasilcripto/app/presenter/view_models/cryptos_view_model.dart';
import 'package:brasilcripto/app/presenter/views/widgets/favorites/favorites_list_widget.dart';
import 'package:brasilcripto/app/presenter/views/widgets/load_widget.dart';
import 'package:flutter/material.dart';

class CryptosFavoritePage extends StatefulWidget {
  final CryptosViewModel cryptosViewModel;
  const CryptosFavoritePage({super.key, required this.cryptosViewModel});

  @override
  State<CryptosFavoritePage> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptosFavoritePage> {
  CryptosViewModel get cryptosViewModel => widget.cryptosViewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.instance.l10n;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Builder(
          builder: (_) {
            final isLoading = cryptosViewModel.isLoading;

            if (isLoading && cryptosViewModel.favoriteCryptos.isEmpty) {
              return LoadWidget(label: l10n.loadingFavorites);
            }

            return FavoritesListWidget(cryptosViewModel: cryptosViewModel);
          },
        ),
      ),
    );
  }
}
