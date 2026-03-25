import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zhuchka_market/auth/auth_api.dart';

void main() {
  test('getUserInfo parses JSON success body', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://mock.test'));
    final adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;

    adapter.onGet(
      '/oauth/userinfo',
      (server) => server.reply(
        200,
        <String, dynamic>{
          'sub': 'user-1',
          'email': 'buyer@example.com',
        },
      ),
    );

    final api = AuthApi(dio: dio);
    final map = await api.getUserInfo('access-token');
    expect(map['sub'], 'user-1');
    expect(map['email'], 'buyer@example.com');
    api.dispose();
  });

  test('getUserInfo throws AuthApiException on 401 from mock', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://mock.test'));
    final adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;

    adapter.onGet(
      '/oauth/userinfo',
      (server) => server.reply(
        401,
        <String, dynamic>{
          'error': 'invalid_token',
        },
      ),
    );

    final api = AuthApi(dio: dio);
    await expectLater(
      api.getUserInfo('bad'),
      throwsA(
        predicate<Object?>((e) => e is AuthApiException && e.statusCode == 401),
      ),
    );
    api.dispose();
  });
}
