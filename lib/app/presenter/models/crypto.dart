// ignore_for_file: public_member_api_docs, sort_constructors_first
class Crypto {
  final String id;
  final String symbol;
  final String name;
  final String? image;
  final double? currentPrice;
  final double? percentageChange;
  final double? totalVolume;
  final bool isFavorite;

  const Crypto({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    this.currentPrice,
    this.percentageChange,
    this.totalVolume,
    this.isFavorite = false,
  });

  Crypto copyWith({bool? isFavorite}) {
    return Crypto(
      id: id,
      symbol: symbol,
      name: name,
      image: image,
      currentPrice: currentPrice,
      percentageChange: percentageChange,
      totalVolume: totalVolume,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
