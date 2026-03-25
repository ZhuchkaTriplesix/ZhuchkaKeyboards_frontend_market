import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zhuchka_market/http/dio_error_mapper.dart';

void main() {
  test('maps OAuth-style error body from badResponse', () {
    final e = DioException(
      requestOptions: RequestOptions(path: '/oauth/token'),
      response: Response(
        requestOptions: RequestOptions(path: '/oauth/token'),
        statusCode: 401,
        data: <String, dynamic>{
          'error': 'invalid_grant',
          'error_description': 'Refresh token expired',
        },
      ),
      type: DioExceptionType.badResponse,
    );
    final ex = authApiExceptionFromDio(e);
    expect(ex.statusCode, 401);
    expect(ex.message, 'invalid_grant: Refresh token expired');
  });

  test('maps network error without response', () {
    final e = DioException(
      requestOptions: RequestOptions(path: '/x'),
      type: DioExceptionType.connectionError,
      message: 'Connection refused',
    );
    final ex = authApiExceptionFromDio(e);
    expect(ex.statusCode, 0);
    expect(ex.message, 'Connection refused');
  });
}
