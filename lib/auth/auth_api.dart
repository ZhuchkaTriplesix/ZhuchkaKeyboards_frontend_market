import 'dart:convert';

import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../http/dio_error_mapper.dart';
import '../http/market_dio.dart';
import 'auth_api_exception.dart';

export 'auth_api_exception.dart';

/// Calls Zhuchka auth-service (federated login, userinfo, refresh) via [Dio].
class AuthApi {
  AuthApi({Dio? dio}) : _dio = dio ?? createMarketDio(), _ownsDio = dio == null;

  final Dio _dio;
  final bool _ownsDio;

  Map<String, dynamic> _decodeSuccess(Response<dynamic> res) {
    final data = res.data;
    if (data == null || data == '') {
      return {};
    }
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    if (data is String) {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    }
    throw AuthApiException('Unexpected response', res.statusCode ?? 0);
  }

  void _throwIfError(int? statusCode, Map<String, dynamic> map) {
    if (statusCode != null && statusCode >= 200 && statusCode < 300) {
      return;
    }
    final err = map['error']?.toString() ?? map['detail']?.toString() ?? 'error';
    final desc = map['error_description']?.toString();
    throw AuthApiException(
      desc != null ? '$err: $desc' : err,
      statusCode ?? 0,
    );
  }

  Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final res = await _dio.post<dynamic>(
        path,
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
        ),
      );
      final map = _decodeSuccess(res);
      _throwIfError(res.statusCode, map);
      return map;
    } on DioException catch (e) {
      throw authApiExceptionFromDio(e);
    }
  }

  Future<Map<String, dynamic>> getUserInfo(String accessToken) async {
    try {
      final res = await _dio.get<dynamic>(
        '/oauth/userinfo',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      final map = _decodeSuccess(res);
      _throwIfError(res.statusCode, map);
      return map;
    } on DioException catch (e) {
      throw authApiExceptionFromDio(e);
    }
  }

  /// OAuth2 form body (same as `curl -d grant_type=refresh_token ...`).
  Future<Map<String, dynamic>> refreshWithRefreshToken(String refreshToken) async {
    try {
      final res = await _dio.post<dynamic>(
        '/oauth/token',
        data: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': AppConfig.oauthPublicClientId,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final map = _decodeSuccess(res);
      _throwIfError(res.statusCode, map);
      return map;
    } on DioException catch (e) {
      throw authApiExceptionFromDio(e);
    }
  }

  Future<Map<String, dynamic>> loginWithGoogleIdToken(String idToken) {
    return postJson('/oauth/federated/google', {
      'client_id': AppConfig.oauthPublicClientId,
      'id_token': idToken,
    });
  }

  Future<Map<String, dynamic>> loginWithTelegram(Map<String, dynamic> telegramPayload) {
    return postJson('/oauth/federated/telegram', {
      'client_id': AppConfig.oauthPublicClientId,
      ...telegramPayload,
    });
  }

  void dispose() {
    if (_ownsDio) {
      _dio.close();
    }
  }
}
