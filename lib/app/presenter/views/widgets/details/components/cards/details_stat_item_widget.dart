import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsStatItemWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool isLink;

  const DetailsStatItemWidget({
    super.key,
    required this.label,
    required this.value,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textStyle = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: textStyle.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: isLink ? () => _openLink(context) : null,
          child: Text(
            value,
            style: textStyle.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: isLink ? colors.primary : colors.onSurface,
              decoration: isLink ? TextDecoration.underline : null,
              decorationColor: isLink ? colors.primary : null,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openLink(BuildContext context) async {
    try {
      final cleanLink = value.trim();
      final urlString = cleanLink.startsWith('http')
          ? cleanLink
          : 'https://$cleanLink';

      final uri = Uri.parse(urlString);

      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      final l10n = LocalizationService.instance.l10n;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.linkError(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
