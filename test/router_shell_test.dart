import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zhuchka_market/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  /// Avoid tapping feature cards on home that reuse the same labels as the bottom bar.
  Future<void> tapBottomNav(WidgetTester tester, String label) async {
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(label),
      ),
    );
  }

  testWidgets('shell NavigationBar opens catalog placeholder', (tester) async {
    await tester.pumpWidget(const MyApp(debugLocale: Locale('ru')));
    await tester.pumpAndSettle();
    expect(find.text('Zhuchka Keyboards'), findsOneWidget);

    await tapBottomNav(tester, 'Каталог');
    await tester.pumpAndSettle();

    expect(find.text('Каталог'), findsWidgets);
    expect(find.text('Каталог скоро здесь'), findsOneWidget);
    expect(
      find.textContaining('backend API'),
      findsOneWidget,
    );
  });

  testWidgets('shell NavigationBar opens cart placeholder', (tester) async {
    await tester.pumpWidget(const MyApp(debugLocale: Locale('ru')));
    await tester.pumpAndSettle();

    await tapBottomNav(tester, 'Корзина');
    await tester.pumpAndSettle();

    expect(find.text('Корзина'), findsWidgets);
    expect(find.text('Корзина пуста'), findsOneWidget);
    expect(
      find.textContaining('commerce backend'),
      findsOneWidget,
    );
  });

  testWidgets('shell returns to home from catalog', (tester) async {
    await tester.pumpWidget(const MyApp(debugLocale: Locale('ru')));
    await tester.pumpAndSettle();
    await tapBottomNav(tester, 'Каталог');
    await tester.pumpAndSettle();
    await tapBottomNav(tester, 'Главная');
    await tester.pumpAndSettle();
    expect(find.text('Zhuchka Keyboards'), findsOneWidget);
  });
}
