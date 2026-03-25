import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:zhuchka_market/l10n/app_localizations.dart';
import 'package:zhuchka_market/theme/market_theme.dart';
import 'package:zhuchka_market/widgets/backend_readiness_body.dart';

Widget _l10nApp(Widget home, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    theme: buildZhuchkaMarketTheme(),
    home: home,
  );
}

void main() {
  testWidgets('empty base URL shows offline empty state', (tester) async {
    await tester.pumpWidget(
      _l10nApp(
        const Scaffold(
          body: BackendReadinessBody(
            baseUrl: '',
            offlineIcon: Icons.storefront_outlined,
            offlineTitle: 'Offline title',
            offlineMessage: 'Offline message',
            awaitingIcon: Icons.cloud_done_outlined,
            awaitingTitle: 'Awaiting title',
            awaitingMessage: 'Awaiting message',
          ),
        ),
      ),
    );
    expect(find.text('Offline title'), findsOneWidget);
    expect(find.text('Offline message'), findsOneWidget);
  });

  testWidgets('successful health/live shows awaiting copy', (tester) async {
    final dio = Dio(BaseOptions(baseUrl: 'http://mock.test'));
    final adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;
    adapter.onGet(
      '/health/live',
      (server) => server.reply(200, <String, dynamic>{'status': 'ok'}),
    );

    await tester.pumpWidget(
      _l10nApp(
        Scaffold(
          body: BackendReadinessBody(
            baseUrl: 'http://mock.test',
            debugDio: dio,
            offlineIcon: Icons.storefront_outlined,
            offlineTitle: 'Offline title',
            offlineMessage: 'Offline message',
            awaitingIcon: Icons.cloud_done_outlined,
            awaitingTitle: 'Catalog service is up',
            awaitingMessage: 'Storefront product list is not wired yet.',
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Catalog service is up'), findsOneWidget);
    expect(find.text('Storefront product list is not wired yet.'), findsOneWidget);
  });

  testWidgets('failed health/live shows retry', (tester) async {
    final dio = Dio(BaseOptions(baseUrl: 'http://mock.test'));
    final adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;
    adapter.onGet(
      '/health/live',
      (server) => server.reply(503, <String, dynamic>{}),
    );

    await tester.pumpWidget(
      _l10nApp(
        Scaffold(
          body: BackendReadinessBody(
            baseUrl: 'http://mock.test',
            debugDio: dio,
            offlineIcon: Icons.storefront_outlined,
            offlineTitle: 'Offline title',
            offlineMessage: 'Offline message',
            awaitingIcon: Icons.cloud_done_outlined,
            awaitingTitle: 'Awaiting title',
            awaitingMessage: 'Awaiting message',
          ),
        ),
        locale: const Locale('ru'),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('HTTP 503'), findsOneWidget);
    expect(find.text('Повторить'), findsOneWidget);
  });
}
