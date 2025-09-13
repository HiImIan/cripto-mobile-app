import 'package:brasilcripto/app/data/mappers/crypto_chart_data_mapper.dart';
import 'package:brasilcripto/app/presenter/models/crypto/chart_data.dart';
import 'package:brasilcripto/app/presenter/models/crypto/crypto_details.dart';

abstract class CryptoDetailsMapper {
  static CryptoDetails fromJson(Map<String, dynamic> json) {
    return CryptoDetails(
      tags: _extractTags(json),
      description: _extractDescription(json),
      genesisDate: _extractGenesisDate(json),
      link: _extractHomepageLink(json),
      marketRank: _extractMarketRank(json),
      chartDatas: _extractChartData(json),
    );
  }

  static List<String> _extractTags(Map<String, dynamic> json) {
    final categories = json['categories'];
    if (categories is List) {
      return categories.map((e) => e.toString()).toList();
    }
    return <String>[];
  }

  static String _extractDescription(Map<String, dynamic> json) {
    final description = json['description'];
    if (description is Map && description['en'] is String) {
      return description['en'];
    }
    return '';
  }

  static DateTime? _extractGenesisDate(Map<String, dynamic> json) {
    final genesisDate = json['genesis_date'];
    if (genesisDate is String) {
      return DateTime.tryParse(genesisDate);
    }
    return null;
  }

  static String? _extractHomepageLink(Map<String, dynamic> json) {
    final links = json['links'];
    if (links is Map) {
      final homepages = links['homepage'];
      if (homepages is List && homepages.isNotEmpty) {
        return homepages[0] as String?;
      }
    }
    return null;
  }

  static int _extractMarketRank(Map<String, dynamic> json) {
    final marketRank = json['market_cap_rank'];
    if (marketRank is int) {
      return marketRank;
    }
    return 0;
  }

  static List<ChartData> _extractChartData(Map<String, dynamic> json) {
    final tickers = json['tickers'];
    if (tickers is List && tickers.isNotEmpty) {
      final tickersMapList = tickers
          .whereType<Map<String, dynamic>>()
          .cast<Map<String, dynamic>>()
          .toList();
      return CryptoChartDataMapper.fromJsonList(tickersMapList);
    }
    return <ChartData>[];
  }
}
