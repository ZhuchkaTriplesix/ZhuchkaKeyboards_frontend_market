import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zhuchka_market/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  testWidgets('Storefront shows title and login', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(debugLocale: Locale('ru')));
    await tester.pumpAndSettle();
    expect(find.text('Zhuchka Market'), findsWidgets);
    expect(find.text('Войти'), findsWidgets);
  });
}
