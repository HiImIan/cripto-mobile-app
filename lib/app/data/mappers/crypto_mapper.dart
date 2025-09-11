import 'package:brasilcripto/app/presenter/models/crypto.dart';

abstract class CryptoMapper {
  static Crypto toMap(Map json) {
    return Crypto(
      id: json["id"].toString(),
      image: json["image"],
      symbol: json["symbol"].toString().toUpperCase(),
      name: json["name"],
      currentPrice: double.tryParse(json["current_price"].toString()),
      percentageChange: double.tryParse(
        json["price_change_percentage_24h"].toString(),
      ),
      totalVolume: double.tryParse(json["total_volume"].toString()),
    );
  }

  static List<Crypto> toMapList(List<Map> response) {
    return response.map(toMap).toList();
  }
}
