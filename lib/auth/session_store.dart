import 'package:shared_preferences/shared_preferences.dart';

/// Persists OAuth tokens from Zhuchka Auth federated/token responses.
class SessionStore {
  SessionStore._();

  static const _accessKey = 'zhuchka_oauth_access_token';
  static const _refreshKey = 'zhuchka_oauth_refresh_token';

  static Future<void> saveOAuthTokens(Map<String, dynamic> body) async {
    final access = body['access_token']?.toString();
    if (access == null || access.isEmpty) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, access);
    final refresh = body['refresh_token']?.toString();
    if (refresh != null && refresh.isNotEmpty) {
      await prefs.setString(_refreshKey, refresh);
    }
  }

  static Future<bool> hasAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString(_accessKey);
    return t != null && t.isNotEmpty;
  }

  static Future<String?> accessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessKey);
  }

  static Future<String?> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshKey);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
  }
}
