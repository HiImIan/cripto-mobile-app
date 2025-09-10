import 'package:brasilcripto/app/presenter/models/crypto.dart';

abstract class CryptoMapper {
  static Crypto toMap(Map json) {
    return Crypto(
      id: json["id"].toString(),
      image: json["image"],
      name: json["name"],
      currentPrice: double.parse(json["current_price"].toString()),
      percentageChange: double.parse(
        json["price_change_percentage_24h"].toString(),
      ),
      totalVolume: double.parse(json["total_volume"].toString()),
    );
  }

  static List<Crypto> toMapList(List<Map> response) {
    return response.map(toMap).toList();
  }
}
