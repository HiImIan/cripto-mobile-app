import 'package:brasilcripto/app/core/services/http/helpers/curl_interceptor.dart';
import 'package:brasilcripto/app/core/services/http/helpers/http_exception.dart';
import 'package:brasilcripto/app/core/services/http/helpers/http_response.dart';
import 'package:brasilcripto/app/core/services/http/http_service.dart';
import 'package:brasilcripto/app/core/services/result/result.dart';
import 'package:dio/dio.dart';

typedef _Request = Future<Response<Map<String, dynamic>>> Function();

class DioImpl implements HttpService {
  final Dio _dio;
  final String baseUrl;

  DioImpl(this._dio, {required this.baseUrl}) {
    _dio.interceptors.add(CurlInterceptor());

    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.sendTimeout = const Duration(seconds: 15);
    _dio.options.connectTimeout = const Duration(seconds: 15);

    _dio.options.baseUrl = baseUrl;
  }

  @override
  AsyncHttpResult<T> get<T>(
    String uri, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    return _connect<T>(
      () async => await _dio.get(
        uri,
        queryParameters: queryParams,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  AsyncHttpResult<T> post<T>(
    String uri,
    Map<String, dynamic>? data, {
    Map<String, dynamic>? headers,
  }) async {
    return _connect<T>(
      () async => await _dio.post(
        uri,
        data: data,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  AsyncHttpResult<T> put<T>(
    String uri,
    Map<String, dynamic> data, {
    Map<String, dynamic>? headers,
  }) async {
    return _connect<T>(
      () async => await _dio.put(
        uri,
        data: data,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  AsyncHttpResult<T> patch<T>(
    String uri,
    Map<String, dynamic> data, {
    Map<String, dynamic>? headers,
  }) async {
    return _connect<T>(
      () async => await _dio.patch(
        uri,
        data: data,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  AsyncHttpResult<T> delete<T>(
    String uri, {
    Map<String, dynamic>? headers,
  }) async {
    return _connect<T>(
      () async => await _dio.delete(uri, options: Options(headers: headers)),
    );
  }

  AsyncHttpResult<T> _connect<T>(_Request request) async {
    try {
      final response = await request();
      final handledResponse = _genResponse<T>(response);

      return Result.ok(handledResponse);
    } on DioException catch (e) {
      final response = e.response;
      return Result.error(
        HttpException(
          'Erro na requisiçao',
          statusCode: response?.statusCode ?? 500,
          innerException: e,
          response: response != null ? _genResponse<T>(response) : null,
        ),
      );
    } catch (e) {
      return Result.error(
        HttpException('Erro na requisiçao', statusCode: 500, innerException: e),
      );
    }
  }

  HttpResponse<T> _genResponse<T>(
    Response response, {
    int defaultStatusCode = 200,
  }) {
    return HttpResponse(statusCode: response.statusCode ?? 200);
  }
}
