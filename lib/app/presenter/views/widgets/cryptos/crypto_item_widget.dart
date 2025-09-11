import 'package:brasilcripto/app/core/assets/app_images.dart';
import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:brasilcripto/app/presenter/models/crypto.dart';
import 'package:brasilcripto/app/presenter/models/helpers/price_convertors.dart';
import 'package:flutter/material.dart';

class CryptoItemWidget extends StatelessWidget {
  final Crypto crypto;
  const CryptoItemWidget({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme;
    final colors = theme.colorScheme;
    final price = Price.formatCurrency(
      crypto.currentPrice ?? 0,
    ).replaceAll('.', ',');
    final percentage = crypto.percentageChange;
    final bool isPositive = percentage != null && percentage >= 0;
    final volume24h = crypto.totalVolume;
    final image = crypto.image;

    final l10n = LocalizationService.instance.l10n;
    return Card(
      color: colors.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: colors.primaryContainer,
                  backgroundImage: image != null
                      ? NetworkImage(image)
                      : AssetImage(AppImages.emptyImage),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: crypto.symbol,
                          style: textStyle.titleSmall?.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                        TextSpan(
                          text: ' \u2022 ',
                          style: textStyle.titleSmall?.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                        TextSpan(
                          text: crypto.name,
                          style: textStyle.bodyMedium?.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.favorite_border, color: colors.onSurface),
                ),
              ],
            ),
            // Main info
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.price(price),
                  style: textStyle.headlineSmall?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (percentage != null)
                  Text(
                    '${isPositive ? '\u2191' : '\u2193'} ${l10n.valuePercentage(percentage.toString())}',
                    style: textStyle.bodyMedium?.copyWith(
                      color: isPositive ? colors.primary : colors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (volume24h != null)
                  Text(
                    '${l10n.totalVolume} ${Price.formatAbbr(volume24h)}',
                    style: textStyle.bodyMedium?.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
              ],
            ),

            // Percentage change
          ],
        ),
      ),
    );
  }
}
