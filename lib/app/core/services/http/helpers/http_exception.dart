import 'package:brasilcripto/app/core/exceptions/app_exception.dart';
import 'package:brasilcripto/app/core/services/http/helpers/http_response.dart';

class HttpException extends AppException {
  final int statusCode;
  final Object innerException;
  final HttpResponse? response;

  HttpException(
    super.message, {
    required this.statusCode,
    required this.innerException,
    this.response,
  });
}
