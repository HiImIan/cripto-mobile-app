import 'package:brasilcripto/app/presenter/view_models/crypto_view_model.dart';
import 'package:brasilcripto/app/presenter/views/widgets/cryptos/crypto_item_widget.dart';
import 'package:brasilcripto/app/presenter/views/widgets/cryptos/exceptions/cryptos_load_more_widget.dart';
import 'package:flutter/material.dart';

class CryptosListWidget extends StatelessWidget {
  final CryptoViewModel cryptosViewModel;
  const CryptosListWidget({super.key, required this.cryptosViewModel});

  @override
  Widget build(BuildContext context) {
    final cryptos = cryptosViewModel.cryptos;
    final length = cryptos.length;
    return RefreshIndicator(
      onRefresh: cryptosViewModel.refresh,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 4),
        itemCount: length + ((cryptosViewModel.hasMoreItem) ? 1 : 0),
        itemBuilder: (context, index) {
          print("index: $index");
          if (index == length - 5) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (cryptosViewModel.hasMoreItem) cryptosViewModel.load();
              cryptosViewModel.incrementPartialCryptos();
            });
          }

          if (index == length && cryptosViewModel.hasMoreItem) {
            return const CryptosLoadMoreWidget();
          }

          final crypto = cryptos[index];
          return GestureDetector(
            onTap: () {
              cryptosViewModel.goToDetails(
                context,
                cryptos.indexOf(crypto).toString(),
              );
            },
            child: CryptoItemWidget(
              crypto: crypto,
              onFavoriteToggle: () =>
                  cryptosViewModel.toggleFavorite(crypto.id),
            ),
          );
        },
      ),
    );
  }
}
