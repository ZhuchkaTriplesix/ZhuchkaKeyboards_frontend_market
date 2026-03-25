import 'package:flutter/foundation.dart';

import 'auth_api.dart';
import 'session_store.dart';

/// Profile from `GET /oauth/userinfo`.
class UserProfile {
  const UserProfile({required this.sub, this.email});

  final String sub;
  final String? email;
}

/// Loads userinfo; on 401 tries `refresh_token` grant then retries once.
class AuthSessionService {
  AuthSessionService({AuthApi? api}) : _api = api ?? AuthApi();

  final AuthApi _api;

  Future<UserProfile?> loadProfile() async {
    try {
      if (!await SessionStore.hasAccessToken()) {
        return null;
      }
      return await _loadWithRetry();
    } catch (e, st) {
      debugPrint('AuthSessionService.loadProfile: $e\n$st');
      return null;
    }
  }

  Future<UserProfile?> _loadWithRetry() async {
    var access = await SessionStore.accessToken();
    if (access == null) {
      return null;
    }
    try {
      return await _mapUserInfo(access);
    } on AuthApiException catch (e) {
      if (e.statusCode != 401) {
        rethrow;
      }
      final refreshed = await _tryRefresh();
      if (!refreshed) {
        return null;
      }
      access = await SessionStore.accessToken();
      if (access == null) {
        return null;
      }
      return await _mapUserInfo(access);
    }
  }

  Future<UserProfile?> _mapUserInfo(String access) async {
    final m = await _api.getUserInfo(access);
    return UserProfile(
      sub: m['sub']?.toString() ?? '',
      email: m['email']?.toString(),
    );
  }

  Future<bool> _tryRefresh() async {
    final refresh = await SessionStore.refreshToken();
    if (refresh == null || refresh.isEmpty) {
      await SessionStore.clear();
      return false;
    }
    try {
      final body = await _api.refreshWithRefreshToken(refresh);
      await SessionStore.saveOAuthTokens(body);
      return true;
    } catch (e, st) {
      debugPrint('refresh failed: $e\n$st');
      await SessionStore.clear();
      return false;
    }
  }

  void dispose() => _api.dispose();
}
