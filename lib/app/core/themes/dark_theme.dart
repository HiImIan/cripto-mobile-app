import 'package:brasilcripto/app/core/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme => ThemeData.dark(useMaterial3: false).copyWith(
    scaffoldBackgroundColor: CustomColors.background,
    appBarTheme: AppBarTheme(
      color: CustomColors.background,
      titleTextStyle: TextStyle(
        color: CustomColors.background,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: CustomColors.background),
      elevation: 0,
      centerTitle: true,
      actionsIconTheme: IconThemeData(color: CustomColors.white),
    ),
    cardTheme: CardThemeData(
      color: CustomColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
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
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(CustomColors.background),
        foregroundColor: WidgetStatePropertyAll(CustomColors.white),
        textStyle: WidgetStateProperty.all(
          TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
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
    dialogTheme: DialogThemeData(
      backgroundColor: CustomColors.cardBackground,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
    hintColor: CustomColors.graySwatch,
    colorScheme: ColorScheme.fromSeed(
      seedColor: CustomColors.graySwatch,
      brightness: Brightness.dark,
      surface: CustomColors.background,
      onSurface: CustomColors.white,
      outlineVariant: CustomColors.transparentGreenOutline,
      onSurfaceVariant: CustomColors.graySwatch.shade300,
      primary: CustomColors.green,
      primaryFixedDim: CustomColors.transparentGreen,
      inversePrimary: CustomColors.redSwatch.shade400,
      primaryFixed: CustomColors.redSwatch.shade700,
      onPrimaryFixedVariant: CustomColors.transparentRed,
      primaryContainer: CustomColors.cardBackground,
      onPrimary: CustomColors.black,
      error: CustomColors.redSwatch,
      secondary: CustomColors.graySwatch.shade300,
      tertiary: CustomColors.amber,
    ),
  );
}
