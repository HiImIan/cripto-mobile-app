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
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: CustomColors.background,
      selectedItemColor: CustomColors.white,
      unselectedItemColor: CustomColors.graySwatch.shade500,
      elevation: 0,
      showUnselectedLabels: false,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
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
    hintColor: CustomColors.graySwatch,
    colorScheme: ColorScheme.fromSeed(
      seedColor: CustomColors.graySwatch,
      brightness: Brightness.dark,
      surface: CustomColors.background,
      onSurface: CustomColors.white,
      onSurfaceVariant: CustomColors.graySwatch.shade300,
      primary: CustomColors.green,
      inversePrimary: CustomColors.redSwatch.shade400,
      primaryFixed: CustomColors.redSwatch.shade700,
      primaryContainer: CustomColors.cardBackground,
      onPrimary: CustomColors.black,
      error: CustomColors.redSwatch,
      secondary: CustomColors.graySwatch.shade300,
      tertiary: CustomColors.amber,
    ),
  );
}
