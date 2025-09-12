import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:brasilcripto/app/presenter/view_models/cryptos_view_model.dart';
import 'package:flutter/material.dart';

class CryptoSearchField extends StatelessWidget {
  final bool showSearchField;
  final CryptosViewModel cryptosViewModel;

  const CryptoSearchField({
    super.key,
    required this.cryptosViewModel,
    required this.showSearchField,
  });

  bool get _shouldShowSearchField =>
      (cryptosViewModel.cryptos.isNotEmpty ||
          cryptosViewModel.hasSearchResults) &&
      showSearchField;

  final defaultDuration = const Duration(milliseconds: 300);
  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.instance.l10n;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textStyle = theme.textTheme;
    return AnimatedSize(
      duration: defaultDuration,
      curve: Curves.easeInOut,
      child: ClipRect(
        child: AnimatedAlign(
          duration: defaultDuration,
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          heightFactor: _shouldShowSearchField ? 1.0 : 0.0,
          child: AnimatedSlide(
            duration: defaultDuration,
            curve: Curves.easeInOut,
            offset: _shouldShowSearchField
                ? const Offset(0, 0)
                : const Offset(0, -1),
            child: AnimatedOpacity(
              duration: defaultDuration,
              opacity: _shouldShowSearchField ? 1.0 : 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: cryptosViewModel.searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colors.primaryContainer,
                    hintText: l10n.searchEngineLabel,
                    hintStyle: textStyle.bodyLarge,
                    contentPadding: const EdgeInsets.only(left: 5),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Visibility(
                      visible:
                          cryptosViewModel.searchController.text.isNotEmpty,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: cryptosViewModel.refresh,
                      ),
                    ),
                  ),
                  onChanged: cryptosViewModel.searchByName,
                  onSubmitted: (value) => cryptosViewModel.searchCryptos,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
