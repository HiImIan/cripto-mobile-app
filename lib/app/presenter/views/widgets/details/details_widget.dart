import 'package:brasilcripto/app/presenter/models/crypto.dart';
import 'package:brasilcripto/app/presenter/views/widgets/details/cards/details_about_widget.dart';
import 'package:brasilcripto/app/presenter/views/widgets/details/cards/details_graphic_widget.dart';
import 'package:brasilcripto/app/presenter/views/widgets/details/cards/details_market_widget.dart';
import 'package:flutter/material.dart';

class DetailsWidget extends StatelessWidget {
  final Crypto crypto;

  const DetailsWidget({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CryptoChartWidget(crypto: crypto),
          const SizedBox(height: 16),

          DetailsMarketWidget(crypto: crypto),

          const SizedBox(height: 16),

          DetailsAboutWidget(crypto: crypto),
        ],
      ),
    );
  }
}
