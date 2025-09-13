import 'package:brasilcripto/app/presenter/models/crypto/crypto_details.dart';

class Crypto {
  final String id;
  final String symbol;
  final String name;
  final String? image;
  final double? currentPrice;
  final double? percentageChange;
  final double? totalVolume;
  final bool isFavorite;
  final CryptoDetails? details;

  const Crypto({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    this.currentPrice,
    this.percentageChange,
    this.totalVolume,
    this.isFavorite = false,
    this.details,
  });

  Crypto copyWith({
    double? currentPrice,
    double? percentageChange,
    double? totalVolume,
    bool? isFavorite,
    CryptoDetails? details,
  }) {
    return Crypto(
      id: id,
      symbol: symbol,
      name: name,
      image: image,
      currentPrice: currentPrice ?? this.currentPrice,
      percentageChange: percentageChange ?? this.percentageChange,
      totalVolume: totalVolume ?? this.totalVolume,
      isFavorite: isFavorite ?? this.isFavorite,
      details: details ?? this.details,
    );
  }
}
