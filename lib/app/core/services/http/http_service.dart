import 'package:brasilcripto/app/core/services/http/helpers/http_response.dart';
import 'package:brasilcripto/app/core/services/result/result.dart';

typedef AsyncHttpResult<T> = Future<Result<HttpResponse<T>>>;

abstract class HttpService {
  AsyncHttpResult<T> get<T>(
    String uri, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  });

  AsyncHttpResult<T> post<T>(
    String uri,
    Map<String, dynamic>? data, {
    Map<String, dynamic>? headers,
  });

  AsyncHttpResult<T> put<T>(
    String uri,
    Map<String, dynamic> data, {
    Map<String, dynamic>? headers,
  });

  AsyncHttpResult<T> patch<T>(
    String uri,
    Map<String, dynamic> data, {
    Map<String, dynamic>? headers,
  });

  AsyncHttpResult<T> delete<T>(String uri, {Map<String, dynamic>? headers});
}
