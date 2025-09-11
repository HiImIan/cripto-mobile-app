import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:brasilcripto/app/presenter/view_models/crypto_view_model.dart';
import 'package:flutter/material.dart';

class CryptoErrorListWidget extends StatelessWidget {
  final CryptoViewModel cryptoViewModel;
  const CryptoErrorListWidget({super.key, required this.cryptoViewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final l10n = LocalizationService.instance.l10n;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
          SizedBox(height: 16),
          Text(
            l10n.errorList,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: cryptoViewModel.refresh,
            child: Text(
              l10n.tryAgain,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
