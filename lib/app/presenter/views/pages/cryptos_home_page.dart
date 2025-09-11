import 'package:brasilcripto/app/presenter/view_models/cryptos_view_model.dart';
import 'package:brasilcripto/app/presenter/views/widgets/cryptos/cryptos_list_widget.dart';
import 'package:brasilcripto/app/presenter/views/widgets/cryptos/exceptions/cryptos_error_widget.dart';
import 'package:brasilcripto/app/presenter/views/widgets/cryptos/exceptions/cryptos_load_widget.dart';
import 'package:flutter/material.dart';

class CryptosHomePage extends StatefulWidget {
  final CryptosViewModel cryptosViewModel;
  const CryptosHomePage({super.key, required this.cryptosViewModel});

  @override
  State<CryptosHomePage> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptosHomePage> {
  CryptosViewModel get cryptosViewModel => widget.cryptosViewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Builder(
          builder: (_) {
            final hasError = cryptosViewModel.error != null;
            final isLoading = cryptosViewModel.isLoading;

            if (isLoading && cryptosViewModel.cryptos.isEmpty) {
              return CryptosLoadWidget();
            }

            if (hasError) return CryptosErrorWidget();

            return CryptosListWidget(cryptosViewModel: cryptosViewModel);
          },
        ),
      ),
    );
  }
}
