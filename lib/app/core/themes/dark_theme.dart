import 'package:brasilcripto/app/core/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme => ThemeData.dark(useMaterial3: false).copyWith(
    scaffoldBackgroundColor: CustomColors.background,
    appBarTheme: AppBarTheme(
      color: CustomColors.background,
      elevation: 0,
      centerTitle: true,
      actionsIconTheme: IconThemeData(color: CustomColors.white),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: CustomColors.white),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: CustomColors.white),
      titleMedium: TextStyle(color: CustomColors.white),

      headlineSmall: TextStyle(color: CustomColors.white),

      bodyLarge: TextStyle(color: CustomColors.white),
      bodyMedium: TextStyle(color: CustomColors.black),
      bodySmall: TextStyle(color: CustomColors.graySwatch[400]),

      labelLarge: TextStyle(
        color: CustomColors.white,
        shadows: [Shadow(color: CustomColors.black, blurRadius: 4)],
      ),
      labelSmall: TextStyle(color: CustomColors.white),
    ),
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: CustomColors.white,
          brightness: Brightness.dark,
        ).copyWith(
          error: CustomColors.redSwatch,
          secondary: CustomColors.redSwatch.shade600,
          tertiary: CustomColors.amber,
          surface: CustomColors.background,
          primary: CustomColors.green,
          onSurface: CustomColors.white,
          primaryContainer: CustomColors.cardBackground,
          onPrimary: CustomColors.black,
        ),
  );
}
