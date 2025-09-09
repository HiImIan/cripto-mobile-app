import 'package:brasilcripto/app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class L10n {
  // List all supported locales here
  static final all = [const Locale('pt', 'BR'), const Locale('en', 'US')];

  // Helper method to get the current instance of AppLocalizations
  static AppLocalizations of(BuildContext context) =>
      AppLocalizations.of(context)!;
}

// Extension on BuildContext to easily access localization
extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

// Singleton service to access localization outside of widget tree
class LocalizationService {
  static LocalizationService? _instance;
  static LocalizationService get instance => _instance!;

  AppLocalizations? _localizations;
  AppLocalizations get l10n => _localizations!;

  // Initialize the service with the current AppLocalizations instance
  static void initialize(AppLocalizations localizations) {
    _instance = LocalizationService._();
    _instance!._localizations = localizations;
  }

  LocalizationService._();
}
