abstract final class Routes {
  static const String cryptos = "/crypto-list";
  static String cryptoDetails(String cryptoId) => "$cryptos/$cryptoId";
}
