class Crypto {
  final String id;
  final String name;
  final String? image;
  final double currentPrice;
  final double percentageChange;
  final double totalVolume;

  const Crypto({
    required this.id,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.percentageChange,
    required this.totalVolume,
  });
}
