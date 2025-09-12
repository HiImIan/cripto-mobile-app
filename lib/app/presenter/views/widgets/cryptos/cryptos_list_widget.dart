import 'package:brasilcripto/app/presenter/view_models/cryptos_view_model.dart';
import 'package:brasilcripto/app/presenter/views/widgets/cryptos/exceptions/cryptos_load_more_widget.dart';
import 'package:brasilcripto/app/presenter/views/widgets/item_widget.dart';
import 'package:flutter/material.dart';

class CryptosListWidget extends StatelessWidget {
  final CryptosViewModel cryptosViewModel;
  const CryptosListWidget({super.key, required this.cryptosViewModel});

  @override
  Widget build(BuildContext context) {
    final cryptos = cryptosViewModel.cryptos;
    final length = cryptos.length;
    final hasSearchResults = cryptosViewModel.hasSearchResults;
    return RefreshIndicator(
      onRefresh: cryptosViewModel.refresh,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 4),
        itemCount: length + ((cryptosViewModel.hasMoreItems) ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == length - 3 && !hasSearchResults) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              cryptosViewModel.loadMore();
            });
          }

          if (index == length && cryptosViewModel.hasMoreItems) {
            return CryptosLoadMoreWidget(cryptosViewModel: cryptosViewModel);
          }

          final crypto = cryptos[index];
          return CryptosItemWidget(
            crypto: crypto,
            onFavoriteToggle: () {
              cryptosViewModel.toggleFavorite(crypto.id);
            },
          );
        },
      ),
    );
  }
}
