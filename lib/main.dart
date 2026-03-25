import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app/market_router.dart';
import 'theme/market_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router = createMarketRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Zhuchka Market',
      themeMode: ThemeMode.dark,
      theme: buildZhuchkaMarketTheme(),
      routerConfig: _router,
    );
  }
}
