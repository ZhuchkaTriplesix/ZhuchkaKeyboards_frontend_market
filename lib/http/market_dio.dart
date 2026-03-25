import 'package:dio/dio.dart';

import '../config/app_config.dart';
import 'retry_interceptor.dart';

/// Shared [Dio] for auth-service: timeouts, GET retries on transient failures.
Dio createMarketDio() {
  final base = AppConfig.authBaseUrl.replaceAll(RegExp(r'/+$'), '');
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
