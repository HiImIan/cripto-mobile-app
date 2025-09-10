import 'package:brasilcripto/app/core/services/http/dio_impl.dart';
import 'package:brasilcripto/app/core/services/http/http_service.dart';
import 'package:brasilcripto/app/data/repositories/crypto_repository.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providers {
  return [
    Provider<HttpService>(
      create: (_) =>
          DioImpl(Dio(), baseUrl: "https://api.coingecko.com/api/v3"),
    ),
    Provider(create: (context) => CryptoRepository(http: context.read())),
  ];
}
