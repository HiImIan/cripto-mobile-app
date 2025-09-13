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
  String get loadingCryptos => 'Loading cryptocurrencies';

  @override
  String get loadingFavorites => 'Loading your favorites';

  @override
  String get loadingDetails => 'Loading details';

  @override
  String get searchEngineLabel => 'Search by name or symbol...';

  @override
  String get noFavoriteCryptos => 'You don’t have any favorite coins yet';

  @override
  String get searchMore => 'See more results';

  @override
  String get clickOnIconToFavorite => 'Tap the icon to favorite';

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
  String get volume => 'Volume';

  @override
  String get totalVolume => 'Market volume';

  @override
  String get aDayVolume => '24h volume';

  @override
  String valuePercentage(String percentage) {
    return '$percentage%';
  }

  @override
  String get price => 'Price';

  @override
  String priceWithSymbol(String price) {
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
  String get details => 'View details';

  @override
  String get moneySymbol => 'R\$';

  @override
  String get noValue => 'N/A';

  @override
  String get ranking => 'Ranking';

  @override
  String get marketStatistics => 'Market statistics';

  @override
  String get genesisDate => 'Launch date';

  @override
  String get website => 'Website';

  @override
  String linkError(String error) {
    return 'Couldn’t open link: $error';
  }

  @override
  String aboutCoin(String coinName) {
    return 'About $coinName';
  }

  @override
  String get noDescription => 'Description not available.';

  @override
  String get noChartData => 'No chart data available';

  @override
  String noChartDetails(String name) {
    return '24h data for $name is currently unavailable.';
  }

  @override
  String get lastTrades => 'Latest trades';
}
