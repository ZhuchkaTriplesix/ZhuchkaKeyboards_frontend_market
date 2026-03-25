import 'package:dio/dio.dart';

/// Retries **GET** requests on transient network failures (timeouts, connection errors).
///
/// Mutating requests (POST, etc.) are not retried to avoid duplicate side effects.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({required this.dio, this.maxRetries = 2});

  final Dio dio;
  final int maxRetries;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.requestOptions.method != 'GET') {
      return handler.next(err);
    }
    if (!_isRetryable(err)) {
      return handler.next(err);
    }
    final extra = err.requestOptions.extra;
    final retry = (extra['retryCount'] as int?) ?? 0;
    if (retry >= maxRetries) {
      return handler.next(err);
    }
    extra['retryCount'] = retry + 1;
    await Future<void>.delayed(Duration(milliseconds: 200 * (retry + 1)));
    try {
      final response = await dio.fetch<Object?>(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  bool _isRetryable(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return false;
    }
  }
}
