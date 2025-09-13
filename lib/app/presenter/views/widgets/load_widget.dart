import 'package:flutter/material.dart';

class LoadWidget extends StatelessWidget {
  final String label;
  const LoadWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textStyle = theme.textTheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, textAlign: TextAlign.center, style: textStyle.titleLarge),
          SizedBox(height: 20),
          CircularProgressIndicator(color: colors.primary),
        ],
      ),
    );
  }
}
