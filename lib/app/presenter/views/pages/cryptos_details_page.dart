import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:brasilcripto/app/presenter/view_models/cryptos_view_model.dart';
import 'package:brasilcripto/app/presenter/views/widgets/cryptos/exceptions/cryptos_error_widget.dart';
import 'package:brasilcripto/app/presenter/views/widgets/details/details_widget.dart';
import 'package:brasilcripto/app/presenter/views/widgets/load_widget.dart';
import 'package:flutter/material.dart';

class CryptosDetailsPage extends StatefulWidget {
  final CryptosViewModel cryptosViewModel;

  const CryptosDetailsPage({super.key, required this.cryptosViewModel});

  @override
  State<CryptosDetailsPage> createState() => _CryptosDetailsPageState();
}

class _CryptosDetailsPageState extends State<CryptosDetailsPage> {
  CryptosViewModel get cryptosViewModel => widget.cryptosViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await cryptosViewModel.loadDetails(cryptosViewModel.currentCrypto!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = LocalizationService.instance.l10n;
    return AnimatedBuilder(
      animation: cryptosViewModel,
      builder: (_, __) {
        final crypto = cryptosViewModel.currentCrypto!;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: colors.primary,
            automaticallyImplyLeading: true,
            title: Text(
              l10n.details,
              style: theme.textTheme.titleLarge!.copyWith(
                color: colors.surface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Builder(
              builder: (_) {
                final hasError = cryptosViewModel.error != null;
                final isLoading = cryptosViewModel.isLoading;

                final hasDetails = crypto.details != null;
                if (isLoading || !hasDetails) {
                  return LoadWidget(label: l10n.loadingDetails);
                }

                if (hasError) return CryptosErrorWidget();

                return DetailsWidget(crypto: crypto);
              },
            ),
          ),
        );
      },
    );
  }
}
