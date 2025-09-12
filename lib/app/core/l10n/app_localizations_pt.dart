// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get market => 'Mercado';

  @override
  String get favorites => 'Favoritos';

  @override
  String get loading => 'Carregando criptomoedas';

  @override
  String get loadingFavorites => 'Carregando seus favoritos';

  @override
  String get searchEngineLabel => 'Pesquisar por nome ou símbolo...';

  @override
  String get noFavoriteCryptos => 'Você ainda não tem moedas favoritas';

  @override
  String get searchMore => 'Procurar mais resultados';

  @override
  String get clickOnIconToFavorite => 'Clique nesse ícone';

  @override
  String get errorList => 'Nenhuma criptomoeda encontrada';

  @override
  String get tryAgain => 'Tentar Novamente';

  @override
  String get loadingMoreCryptos => 'Carregar mais Criptos';

  @override
  String get brazilCrypto => 'Brasil Criptos';

  @override
  String get actualPrice => 'Preço atual';

  @override
  String get totalVolume => 'Volume no mercado';

  @override
  String valuePercentage(String percentage) {
    return '$percentage%';
  }

  @override
  String price(String price) {
    return 'R\$ $price';
  }

  @override
  String get removeFavorite => 'Remover dos Favoritos';

  @override
  String removeNameAndSymbol(String name, String symbol) {
    return 'Deseja remover \'$name\' ($symbol) dos favoritos?';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get remove => 'Remove';

  @override
  String get details => 'Ver detalhes';
}
