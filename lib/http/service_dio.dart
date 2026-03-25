import 'package:dio/dio.dart';

import 'retry_interceptor.dart';

/// [Dio] for catalog, commerce, or other storefront backends: timeouts, GET retries.
///
/// [baseUrl] must be non-empty (caller checks before calling).
Dio createServiceDio(String baseUrl) {
  final base = baseUrl.replaceAll(RegExp(r'/+$'), '');
  final dio = Dio(
    BaseOptions(
      baseUrl: base,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );
  dio.interceptors.add(RetryInterceptor(dio: dio));
  return dio;
}
