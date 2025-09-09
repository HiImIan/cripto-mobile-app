import 'package:brasilcripto/app/core/exceptions/app_exception.dart';

abstract class Result<T> {
  const Result();

  factory Result.ok(T value) = Ok._;

  factory Result.error(AppException error) = ResultError._;

  Ok<T> get asOk => this as Ok<T>;

  ResultError<T> get asError => this as ResultError<T>;

  Result<R> map<R>(R Function(T value) onOk) {
    return fold(
      (error) => Result<R>.error(error),
      (ok) => Result<R>.ok(onOk(ok)),
    );
  }

  R fold<R>(R Function(AppException error) onError, R Function(T value) onOk);
}

final class Ok<T> extends Result<T> {
  final T value;

  const Ok._(this.value);

  @override
  R fold<R>(R Function(AppException error) onError, R Function(T value) onOk) {
    return onOk(value);
  }
}

final class ResultError<T> extends Result<T> {
  final AppException error;

  ResultError._(this.error);

  @override
  R fold<R>(R Function(AppException error) onError, R Function(T value) onOk) {
    return onError(error);
  }
}
