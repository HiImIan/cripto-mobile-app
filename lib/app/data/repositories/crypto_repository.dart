import 'package:brasilcripto/app/core/services/http/http_service.dart';
import 'package:brasilcripto/app/core/services/result/result.dart';
import 'package:brasilcripto/app/data/mappers/crypto_mapper.dart';
import 'package:brasilcripto/app/presenter/models/crypto.dart';

class CryptoRepository {
  final HttpService _http;

  CryptoRepository({required HttpService http}) : _http = http;

  Future<Result<List<Crypto>>> get({int? page, List<String>? ids}) async {
    final headers = {'x-cg-demo-api-key': 'CG-PfbR94AhHpC9ptTgk8SSX5fB'};
    final params = {
      "vs_currency": "brl",
      "per_page": ids?.length ?? 50,
      "ids": ids?.join(','),
      "page": page,
    };

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
