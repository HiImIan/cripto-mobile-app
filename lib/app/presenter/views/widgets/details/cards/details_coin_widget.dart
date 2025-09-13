import 'package:brasilcripto/app/presenter/models/crypto.dart';
import 'package:flutter/material.dart';

class DetailsCoinWidget extends StatelessWidget {
  final Crypto crypto;
  const DetailsCoinWidget({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textStyle = theme.textTheme;

    final image = crypto.image;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          if (image != null)
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(image),
              backgroundColor: colors.surfaceContainerHighest,
            ),
          if (image != null) const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crypto.name,
                  style: textStyle.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  crypto.symbol.toUpperCase(),
                  style: textStyle.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
