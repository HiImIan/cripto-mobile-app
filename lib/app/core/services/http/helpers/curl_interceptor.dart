import 'dart:convert';

import 'package:brasilcripto/app/core/services/log/log.dart';
import 'package:dio/dio.dart';

class CurlInterceptor extends Interceptor {
  const CurlInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _renderCurlRepresentation(options);

    return handler.next(options);
  }

  void _renderCurlRepresentation(RequestOptions requestOptions) {
    try {
      Log.log(_cURLRepresentation(requestOptions));
    } catch (err, st) {
      Log.error(
        'Unable to create a CURL representation of the requestOptions',
        error: err,
        stackTrace: st,
      );
    }
  }

  String _cURLRepresentation(RequestOptions options) {
    final components = ['curl -i'];

    components.add('-X ${options.method.toUpperCase()}');

    options.headers.forEach((k, v) {
      if (k != 'Cookie') {
        components.add('-H "$k: $v"');
      }
    });

    if (options.data != null) {
      final data = json.encode(options.data).replaceAll('"', '"');
      components.add('-d "$data"');
    }

    components.add('"${options.uri.toString()}"');

    return components.join(' \\n');
  }
}
