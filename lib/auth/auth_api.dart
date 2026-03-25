import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';

/// Calls Zhuchka auth-service (federated login, userinfo, refresh).
class AuthApi {
  AuthApi({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  final http.Client _http;

  Uri _u(String path) => Uri.parse('${AppConfig.authBaseUrl}$path');

  Map<String, dynamic> _decodeJsonMap(http.Response res) {
    final raw = res.body;
    if (raw.isEmpty) {
      return {};
    }
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw AuthApiException('Unexpected response', res.statusCode);
    }
    return decoded;
  }

  void _throwIfError(http.Response res, Map<String, dynamic> map) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return;
    }
    final err = map['error']?.toString() ?? map['detail']?.toString() ?? 'error';
    final desc = map['error_description']?.toString();
    throw AuthApiException(
      desc != null ? '$err: $desc' : err,
      res.statusCode,
    );
  }

  Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    final res = await _http.post(
      _u(path),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode(body),
    );
    final map = _decodeJsonMap(res);
    _throwIfError(res, map);
    return map;
  }

  Future<Map<String, dynamic>> getUserInfo(String accessToken) async {
    final res = await _http.get(
      _u('/oauth/userinfo'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    final map = _decodeJsonMap(res);
    _throwIfError(res, map);
    return map;
  }

  /// OAuth2 form body (same as `curl -d grant_type=refresh_token ...`).
  Future<Map<String, dynamic>> refreshWithRefreshToken(String refreshToken) async {
    final res = await _http.post(
      _u('/oauth/token'),
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'client_id': AppConfig.oauthPublicClientId,
      },
    );
    final map = _decodeJsonMap(res);
    _throwIfError(res, map);
    return map;
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

  void dispose() => _http.close();
}

class AuthApiException implements Exception {
  AuthApiException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  String toString() => 'AuthApiException($statusCode): $message';
}
