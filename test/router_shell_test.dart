import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zhuchka_market/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  testWidgets('shell NavigationBar opens catalog placeholder', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('Витрина для покупателей'), findsOneWidget);

    await tester.tap(find.text('Каталог'));
    await tester.pumpAndSettle();

    expect(find.text('Каталог'), findsWidgets);
    expect(
      find.text('Раздел каталога — заглушка до подключения backend.'),
      findsOneWidget,
    );
  });

  testWidgets('shell NavigationBar opens cart placeholder', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Корзина'));
    await tester.pumpAndSettle();

    expect(find.text('Корзина'), findsWidgets);
    expect(
      find.textContaining('Корзина — заглушка'),
      findsOneWidget,
    );
  });

  testWidgets('shell returns to home from catalog', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Каталог'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Главная'));
    await tester.pumpAndSettle();
    expect(find.text('Витрина для покупателей'), findsOneWidget);
  });
}
