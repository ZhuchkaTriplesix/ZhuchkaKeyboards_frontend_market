import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';

/// Calls Zhuchka auth-service federated endpoints.
class AuthApi {
  AuthApi({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  final http.Client _http;

  Uri _u(String path) => Uri.parse('${AppConfig.authBaseUrl}$path');

  Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    final res = await _http.post(
      _u(path),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode(body),
    );
    final map = jsonDecode(res.body);
    if (map is! Map<String, dynamic>) {
      throw AuthApiException('Unexpected response', res.statusCode);
    }
    if (res.statusCode < 200 || res.statusCode >= 300) {
      final err = map['error']?.toString() ?? 'error';
      final desc = map['error_description']?.toString();
      throw AuthApiException(desc != null ? '$err: $desc' : err, res.statusCode);
    }
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
