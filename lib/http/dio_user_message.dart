import 'package:dio/dio.dart';

/// Short user-visible message for [MarketErrorView] from a failed HTTP call.
String userMessageFromDio(DioException e) {
  final res = e.response;
  if (res != null) {
    final code = res.statusCode;
    return code != null ? 'HTTP $code' : (e.message ?? 'Request failed');
  }
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return e.message ?? 'Timeout';
    case DioExceptionType.connectionError:
      return e.message ?? 'Connection failed';
    default:
      return e.message ?? 'Network error';
  }
}
