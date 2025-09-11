import 'package:brasilcripto/app/core/assets/app_images.dart';
import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:brasilcripto/app/presenter/models/crypto.dart';
import 'package:brasilcripto/app/presenter/models/helpers/price_convertors.dart';
import 'package:flutter/material.dart';

class CryptosItemWidget extends StatelessWidget {
  final Crypto crypto;
  final VoidCallback? onFavoriteToggle;
  const CryptosItemWidget({
    super.key,
    required this.crypto,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    // theme
    final theme = Theme.of(context);
    final textStyle = theme.textTheme;
    final colors = theme.colorScheme;

    // crypto datas
    final currentPrice = crypto.currentPrice;
    final hasPrice = currentPrice != null;
    final percentage = crypto.percentageChange;
    final bool isPositive = percentage != null && percentage >= 0;
    final volume24h = crypto.totalVolume;
    final image = crypto.image;
    final isFavorite = crypto.isFavorite;

    // colors
    final favoriteIconColor = isFavorite
        ? colors.primaryFixed
        : colors.onSurface;
    final favoriteHoverColor = !isFavorite
        ? colors.primaryFixed
        : colors.onSurfaceVariant;

    final l10n = LocalizationService.instance.l10n;
    return Card(
      color: colors.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Icon, symbol, name and favorite
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
                    overflow: TextOverflow.ellipsis,
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
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  color: favoriteIconColor,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                  splashRadius: 20,
                  splashColor: favoriteHoverColor,
                  onPressed: onFavoriteToggle,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Price, percentage change
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (hasPrice)
                  Text(
                    l10n.price(
                      Price.formatCurrency(currentPrice).replaceAll('.', ','),
                    ),
                    style: textStyle.headlineSmall?.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (percentage != null)
                  Text(
                    '${isPositive ? '\u2191' : '\u2193'} ${l10n.valuePercentage(percentage.toString())}',
                    style: textStyle.bodyMedium?.copyWith(
                      color: isPositive
                          ? colors.primary
                          : colors.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Volume
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
          ],
        ),
      ),
    );
  }
}
