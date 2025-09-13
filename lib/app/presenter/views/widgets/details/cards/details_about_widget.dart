import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:brasilcripto/app/presenter/models/crypto.dart';
import 'package:flutter/material.dart';

class DetailsAboutWidget extends StatelessWidget {
  final Crypto crypto;
  const DetailsAboutWidget({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.instance.l10n;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final details = crypto.details!;
    final description = details.description;

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.aboutCoin(crypto.name),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (description != null)
                Text(
                  description.isNotEmpty ? description : l10n.noDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: colors.secondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
