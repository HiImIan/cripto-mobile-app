// ignore_for_file: public_member_api_docs, sort_constructors_first

class ChartData {
  final double price;
  final double volume;
  final DateTime timestamp;

  const ChartData({
    required this.price,
    required this.volume,
    required this.timestamp,
  });
}
