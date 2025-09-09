class HttpResponse<T> {
  final int statusCode;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  const HttpResponse({required this.statusCode});
}
