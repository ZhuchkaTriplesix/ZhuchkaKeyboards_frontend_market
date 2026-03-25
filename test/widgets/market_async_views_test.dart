import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zhuchka_market/l10n/app_localizations.dart';
import 'package:zhuchka_market/theme/market_theme.dart';
import 'package:zhuchka_market/widgets/market_async_views.dart';

Widget _l10nApp(Widget home) {
  return MaterialApp(
    locale: const Locale('ru'),
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
  group('MarketLoadingView', () {
    testWidgets('shows progress indicator', (tester) async {
      await tester.pumpWidget(
        _l10nApp(const Scaffold(body: MarketLoadingView())),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows message when provided', (tester) async {
      await tester.pumpWidget(
        _l10nApp(
          const Scaffold(
            body: MarketLoadingView(message: 'Загрузка теста'),
          ),
        ),
      );
      expect(find.text('Загрузка теста'), findsOneWidget);
    });
  });

  group('MarketEmptyView', () {
    testWidgets('renders title and message', (tester) async {
      await tester.pumpWidget(
        _l10nApp(
          const Scaffold(
            body: MarketEmptyView(
              icon: Icons.inbox_outlined,
              title: 'Пусто',
              message: 'Нет данных',
            ),
          ),
        ),
      );
      expect(find.text('Пусто'), findsOneWidget);
      expect(find.text('Нет данных'), findsOneWidget);
    });

    testWidgets('renders action when callback set', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _l10nApp(
          Scaffold(
            body: MarketEmptyView(
              icon: Icons.inbox_outlined,
              title: 'Пусто',
              message: 'Нет данных',
              actionLabel: 'Обновить',
              onAction: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Обновить'));
      expect(tapped, isTrue);
    });
  });

  group('MarketErrorView', () {
    testWidgets('shows message and retry', (tester) async {
      var retries = 0;
      await tester.pumpWidget(
        _l10nApp(
          Scaffold(
            body: MarketErrorView(
              message: 'Сеть недоступна',
              onRetry: () => retries++,
            ),
          ),
        ),
      );
      expect(find.text('Сеть недоступна'), findsOneWidget);
      await tester.tap(find.text('Повторить'));
      expect(retries, 1);
    });
  });
}
