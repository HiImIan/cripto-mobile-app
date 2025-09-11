import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:brasilcripto/app/presenter/view_models/crypto_view_model.dart';
import 'package:brasilcripto/app/presenter/views/widgets/cryptos/cryptos_list_widget.dart';
import 'package:brasilcripto/app/presenter/views/widgets/cryptos/exceptions/crypto_empty_list_widget.dart';
import 'package:brasilcripto/app/presenter/views/widgets/cryptos/exceptions/crypto_error_list_widget.dart';
import 'package:flutter/material.dart';

class CryptosPage extends StatefulWidget {
  final CryptoViewModel cryptosViewModel;
  const CryptosPage({super.key, required this.cryptosViewModel});

  @override
  State<CryptosPage> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<CryptosPage> {
  CryptoViewModel get cryptosViewModel => widget.cryptosViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => cryptosViewModel.load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = LocalizationService.instance.l10n;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: Text(l10n.brazilCrypto, style: theme.textTheme.titleLarge),

        actions: [
          IconButton(
            icon: const Icon(Icons.replay_outlined),
            splashRadius: 16,
            onPressed: cryptosViewModel.refresh,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: AnimatedBuilder(
          animation: cryptosViewModel,
          builder: (_, child) {
            final hasError = cryptosViewModel.error != null;
            final isLoading = cryptosViewModel.isLoading;

            if (isLoading && cryptosViewModel.cryptos.isEmpty) {
              return CryptoEmptyListWidget();
            }

            if (hasError) {
              return CryptoErrorListWidget(cryptoViewModel: cryptosViewModel);
            }

            return CryptosListWidget(cryptosViewModel: cryptosViewModel);
          },
        ),
      ),
    );
  }
}
