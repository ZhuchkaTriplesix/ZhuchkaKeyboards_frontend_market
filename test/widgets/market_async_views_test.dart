import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zhuchka_market/theme/market_theme.dart';
import 'package:zhuchka_market/widgets/market_async_views.dart';

void main() {
  group('MarketLoadingView', () {
    testWidgets('shows progress indicator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildZhuchkaMarketTheme(),
          home: const Scaffold(body: MarketLoadingView()),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows message when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildZhuchkaMarketTheme(),
          home: const Scaffold(
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
        MaterialApp(
          theme: buildZhuchkaMarketTheme(),
          home: const Scaffold(
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
        MaterialApp(
          theme: buildZhuchkaMarketTheme(),
          home: Scaffold(
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
        MaterialApp(
          theme: buildZhuchkaMarketTheme(),
          home: Scaffold(
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
