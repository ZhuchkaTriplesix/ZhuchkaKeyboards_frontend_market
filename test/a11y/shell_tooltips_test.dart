import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zhuchka_market/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  testWidgets('bottom nav exposes tooltips for screen readers', (tester) async {
    await tester.pumpWidget(const MyApp(debugLocale: Locale('ru')));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Витрина — главная страница'), findsOneWidget);
    expect(find.byTooltip('Каталог товаров'), findsOneWidget);
    expect(find.byTooltip('Корзина покупок'), findsOneWidget);
  });
}
