import 'package:brasilcripto/app/core/services/http/http_service.dart';
import 'package:brasilcripto/app/core/services/result/result.dart';
import 'package:brasilcripto/app/data/mappers/crypto_mapper.dart';
import 'package:brasilcripto/app/presenter/models/crypto.dart';

class CryptoRepository {
  final HttpService _http;

  CryptoRepository({required HttpService http}) : _http = http;

  Future<Result<List<Crypto>>> get() async {
    final headers = {'x-cg-demo-api-key': 'CG-PfbR94AhHpC9ptTgk8SSX5fB'};
    final params = {"vs_currency": "usd"};

    final result = await _http.get(
      '/coins/markets',
      headers: headers,
      queryParams: params,
    );

    return result.map((response) {
      return CryptoMapper.toMapList(List.from(response.body));
    });
  }
}
