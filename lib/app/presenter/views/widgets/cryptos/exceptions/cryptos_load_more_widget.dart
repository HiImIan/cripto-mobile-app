import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:brasilcripto/app/presenter/view_models/cryptos_view_model.dart';
import 'package:flutter/material.dart';

class CryptosLoadMoreWidget extends StatelessWidget {
  final CryptosViewModel cryptosViewModel;
  const CryptosLoadMoreWidget({super.key, required this.cryptosViewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textStyle = theme.textTheme;

    final l10n = LocalizationService.instance.l10n;

    final hasSearchResults = !cryptosViewModel.hasSearchResults;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: Container(
        height: hasSearchResults ? 80 : 50,
        color: colors.primaryContainer,
        child: Visibility(
          visible: hasSearchResults,
          replacement: ElevatedButton.icon(
            label: Text(l10n.searchMore),
            icon: Icon(Icons.manage_search),
            onPressed: cryptosViewModel.searchCryptos,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: colors.primary, strokeWidth: 2),
              SizedBox(height: 12),
              Text(l10n.loadingMoreCryptos, style: textStyle.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
