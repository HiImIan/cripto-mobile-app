import 'package:brasilcripto/app/presenter/models/crypto/chart_data.dart';

abstract class CryptoChartDataMapper {
  static const String _priceKey = 'converted_last';
  static const String _volumeKey = 'converted_volume';
  static const String _timestampKey = 'timestamp';
  static const String _usdKey = 'usd';

  static ChartData fromJson(Map<String, dynamic> json) {
    try {
      final priceData = json[_priceKey] as Map<String, dynamic>?;
      final volumeData = json[_volumeKey] as Map<String, dynamic>?;
      final timestampString = json[_timestampKey] as String?;

      if (priceData == null || volumeData == null || timestampString == null) {
        throw const FormatException('Missing required fields in JSON');
      }

      final price = _parseToDouble(priceData[_usdKey]);
      final volume = _parseToDouble(volumeData[_usdKey]);
      final timestamp = DateTime.parse(timestampString);

      return ChartData(price: price, volume: volume, timestamp: timestamp);
    } catch (e) {
      throw FormatException('Failed to parse ChartData from JSON: $e');
    }
  }

  static List<ChartData> fromJsonList(List<Map<String, dynamic>> jsonList) {
    final results = <ChartData>[];

    for (int i = 0; i < jsonList.length; i++) {
      results.add(fromJson(jsonList[i]));
    }

    return results;
  }

  static double _parseToDouble(dynamic value) {
    if (value == null) {
      throw const FormatException('Value cannot be null');
    }

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }

    throw FormatException(
      'Cannot convert $value (${value.runtimeType}) to double',
    );
  }
}
