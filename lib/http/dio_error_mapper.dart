import 'dart:convert';

import 'package:dio/dio.dart';

import '../auth/auth_api_exception.dart';

/// Maps [DioException] to [AuthApiException] using OAuth-style JSON bodies when present.
AuthApiException authApiExceptionFromDio(DioException e) {
  final res = e.response;
  if (res != null) {
    final status = res.statusCode ?? 0;
    final map = _tryJsonMap(res.data);
    if (map.isNotEmpty) {
      final err = map['error']?.toString() ?? map['detail']?.toString() ?? 'error';
      final desc = map['error_description']?.toString();
      return AuthApiException(
        desc != null ? '$err: $desc' : err,
        status,
      );
    }
    return AuthApiException(e.message ?? 'error', status);
  }
  return AuthApiException(e.message ?? 'network error', 0);
}

Map<String, dynamic> _tryJsonMap(dynamic data) {
  if (data is Map<String, dynamic>) {
    return data;
  }
  if (data is Map) {
    return Map<String, dynamic>.from(data);
  }
  if (data is String && data.isNotEmpty) {
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}
  }
  return {};
}
