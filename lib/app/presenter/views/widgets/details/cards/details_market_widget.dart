import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:brasilcripto/app/presenter/models/crypto.dart';
import 'package:brasilcripto/app/presenter/models/helpers/price_convertors.dart';
import 'package:brasilcripto/app/presenter/views/widgets/details/components/cards/details_stat_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailsMarketWidget extends StatelessWidget {
  final Crypto crypto;
  const DetailsMarketWidget({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme;
    final l10n = LocalizationService.instance.l10n;

    final details = crypto.details!;
    final genesisDate = details.genesisDate;
    final totalVolume = crypto.totalVolume;
    final link = details.link;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.marketStatistics,
              style: textStyle.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                DetailsStatItemWidget(
                  label: l10n.ranking,
                  value: '#${details.marketRank}',
                ),
                if (totalVolume != null)
                  DetailsStatItemWidget(
                    label: l10n.totalVolume,
                    value: Price.formatAbbr(totalVolume),
                  ),
                if (genesisDate != null)
                  DetailsStatItemWidget(
                    label: l10n.genesisDate,
                    value: DateFormat('dd/MM/yyyy').format(genesisDate),
                  ),
                if (link != null)
                  DetailsStatItemWidget(
                    label: l10n.website,
                    value: link,
                    isLink: true,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
