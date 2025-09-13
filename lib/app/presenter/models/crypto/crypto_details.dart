import 'package:brasilcripto/app/presenter/models/crypto/chart_data.dart';

class CryptoDetails {
  final List<String> tags;
  final String? description;
  final DateTime? genesisDate;
  final String? link;
  final int marketRank;
  final List<ChartData> chartDatas;

  CryptoDetails({
    required this.tags,
    required this.description,
    required this.genesisDate,
    required this.link,
    required this.marketRank,
    required this.chartDatas,
  });
}
