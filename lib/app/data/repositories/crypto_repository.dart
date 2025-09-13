import 'package:brasilcripto/app/core/services/http/http_service.dart';
import 'package:brasilcripto/app/core/services/result/result.dart';
import 'package:brasilcripto/app/data/mappers/crypto_details_mapper.dart';
import 'package:brasilcripto/app/data/mappers/crypto_mapper.dart';
import 'package:brasilcripto/app/presenter/models/crypto.dart';
import 'package:brasilcripto/app/presenter/models/crypto/crypto_details.dart';

class CryptoRepository {
  final HttpService _http;

  CryptoRepository({required HttpService http}) : _http = http;

  Future<Result<List<Crypto>>> get({int? page, List<String>? ids}) async {
    final headers = {'x-cg-demo-api-key': 'CG-PfbR94AhHpC9ptTgk8SSX5fB'};

    final params = <String, dynamic>{
      'vs_currency': 'brl',
      'per_page': ids?.length ?? 50,
    };

    if (page != null) params['page'] = page;

    params['ids'] = ids?.join(',');

    final result = await _http.get(
      '/coins/markets',
      headers: headers,
      queryParams: params,
    );

    return result.map((response) {
      return CryptoMapper.toMapList(List.from(response.body));
    });
  }

  Future<Result<List<Crypto>>> search(String search) async {
    final headers = {'x-cg-demo-api-key': 'CG-PfbR94AhHpC9ptTgk8SSX5fB'};

    final params = <String, dynamic>{'query': search};

    final result = await _http.get(
      '/search',
      headers: headers,
      queryParams: params,
    );

    return result.map((response) {
      final cryptos = response.body['coins'];
      return CryptoMapper.toMapList(List.from(cryptos));
    });
  }

  Future<Result<CryptoDetails>> getDetails(String id) async {
    final headers = {'x-cg-demo-api-key': 'CG-PfbR94AhHpC9ptTgk8SSX5fB'};

    final params = <String, dynamic>{
      'localization': 'false',
      'market_data': 'false',
      'community_data': 'false',
      'developer_data': 'false',
    };

    final result = await _http.get(
      '/coins/$id',
      headers: headers,
      queryParams: params,
    );

    return result.map((response) {
      return CryptoDetailsMapper.fromJson(response.body);
    });
  }
}
