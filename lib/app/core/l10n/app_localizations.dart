import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @market.
  ///
  /// In pt, this message translates to:
  /// **'Mercado'**
  String get market;

  /// No description provided for @favorites.
  ///
  /// In pt, this message translates to:
  /// **'Favoritos'**
  String get favorites;

  /// No description provided for @loading.
  ///
  /// In pt, this message translates to:
  /// **'Carregando criptomoedas'**
  String get loading;

  /// No description provided for @loadingFavorites.
  ///
  /// In pt, this message translates to:
  /// **'Carregando seus favoritos'**
  String get loadingFavorites;

  /// No description provided for @searchEngineLabel.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar por nome ou símbolo...'**
  String get searchEngineLabel;

  /// No description provided for @noFavoriteCryptos.
  ///
  /// In pt, this message translates to:
  /// **'Você ainda não tem moedas favoritas'**
  String get noFavoriteCryptos;

  /// No description provided for @searchMore.
  ///
  /// In pt, this message translates to:
  /// **'Procurar mais moedas'**
  String get searchMore;

  /// No description provided for @clickOnIconToFavorite.
  ///
  /// In pt, this message translates to:
  /// **'Clique nesse ícone'**
  String get clickOnIconToFavorite;

  /// No description provided for @errorList.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma criptomoeda encontrada'**
  String get errorList;

  /// No description provided for @tryAgain.
  ///
  /// In pt, this message translates to:
  /// **'Tentar Novamente'**
  String get tryAgain;

  /// No description provided for @loadingMoreCryptos.
  ///
  /// In pt, this message translates to:
  /// **'Carregar mais Criptos'**
  String get loadingMoreCryptos;

  /// No description provided for @brazilCrypto.
  ///
  /// In pt, this message translates to:
  /// **'Brasil Criptos'**
  String get brazilCrypto;

  /// No description provided for @actualPrice.
  ///
  /// In pt, this message translates to:
  /// **'Preço atual'**
  String get actualPrice;

  /// No description provided for @totalVolume.
  ///
  /// In pt, this message translates to:
  /// **'Volume no mercado'**
  String get totalVolume;

  /// {percentage}%
  ///
  /// In pt, this message translates to:
  /// **'{percentage}%'**
  String valuePercentage(String percentage);

  /// R$ {price}
  ///
  /// In pt, this message translates to:
  /// **'R\$ {price}'**
  String price(String price);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
