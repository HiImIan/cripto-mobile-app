// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get market => 'Market';

  @override
  String get favorites => 'Favorites';

  @override
  String get loading => 'Loading cryptocurrencies';

  @override
  String get loadingFavorites => 'Loading your favorites';

  @override
  String get searchEngineLabel => 'Search by name or symbol...';

  @override
  String get noFavoriteCryptos => 'You don’t have any favorite coins yet';

  @override
  String get searchMore => 'Browse more coins';

  @override
  String get clickOnIconToFavorite => 'Tap this icon to favorite';

  @override
  String get errorList => 'No cryptocurrencies found';

  @override
  String get tryAgain => 'Try again';

  @override
  String get loadingMoreCryptos => 'Loading more coins';

  @override
  String get brazilCrypto => 'Brazil Crypto';

  @override
  String get actualPrice => 'Current price';

  @override
  String get totalVolume => 'Market volume';

  @override
  String valuePercentage(String percentage) {
    return '$percentage%';
  }

  @override
  String price(String price) {
    return 'R\$ $price';
  }

  @override
  String get removeFavorite => 'Remove from favorites';

  @override
  String removeNameAndSymbol(String name, String symbol) {
    return 'Do you want to remove \'$name\' ($symbol) from favorites?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get remove => 'Remove';

  @override
  String get details => 'Ver detalhes';
}
