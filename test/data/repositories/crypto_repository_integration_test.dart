import 'package:brasilcripto/app/core/services/http/dio_impl.dart';
import 'package:brasilcripto/app/core/services/result/result.dart';
import 'package:brasilcripto/app/data/repositories/crypto_repository.dart';
import 'package:brasilcripto/app/presenter/models/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CryptoRepository Integration', () {
    late CryptoRepository repository;

    setUp(() {
      final http = DioImpl(Dio(), baseUrl: "https://api.coingecko.com/api/v3");
      repository = CryptoRepository(http: http);
    });

    test('should fetch and map cryptos correctly', () async {
      final result = await repository.get(page: 1);
      expect(result.asOk, isA<Ok>());
      final cryptos = result.asOk.value;
      expect(cryptos, isNotNull);
      expect(cryptos, isNotEmpty);
      final first = cryptos.first;
      expect(first, isA<Crypto>());
      expect(first.id, isNotEmpty);
      expect(first.name, isNotEmpty);
      expect(first.currentPrice, greaterThan(0));
    });
  });
}
