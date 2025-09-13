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
  String get loadingCryptos => 'Carregando criptomoedas';

  @override
  String get loadingFavorites => 'Carregando seus favoritos';

  @override
  String get loadingDetails => 'Carregando detalhes';

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
  String get volume => 'Volume';

  @override
  String get totalVolume => 'Volume no mercado';

  @override
  String get aDayVolume => 'Volume 24h';

  @override
  String valuePercentage(String percentage) {
    return '$percentage%';
  }

  @override
  String get price => 'Preço';

  @override
  String priceWithSymbol(String price) {
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

  @override
  String get moneySymbol => 'R\$';

  @override
  String get noValue => 'N/A';

  @override
  String get ranking => 'Ranking';

  @override
  String get marketStatistics => 'Estatísticas de Mercado';

  @override
  String get genesisDate => 'Data de Criação';

  @override
  String get website => 'Website';

  @override
  String linkError(String error) {
    return 'Erro ao abrir link: $error';
  }

  @override
  String aboutCoin(String coinName) {
    return 'Sobre $coinName - En/Us';
  }

  @override
  String get noDescription => 'Descrição não disponível.';

  @override
  String get noChartData => 'Gráfico sem informações';

  @override
  String noChartDetails(String name) {
    return 'Os dados das últimas 24h de $name não estão disponíveis no momento.';
  }

  @override
  String get lastTrades => 'Últimas Operações';
}
