import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:flutter/material.dart';

class CryptoSearchField extends StatelessWidget {
  final Function(String) onChanged;

  const CryptoSearchField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.instance.l10n;
    return TextField(
      decoration: InputDecoration(
        hintText: l10n.searchEngineLabel,
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
