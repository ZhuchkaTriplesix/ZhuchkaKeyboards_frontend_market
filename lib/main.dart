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
      builder: (context, child) {
        if (child == null) {
          return const SizedBox.shrink();
        }
        final mq = MediaQuery.of(context);
        final scaler = mq.textScaler.clamp(
          minScaleFactor: 0.85,
          maxScaleFactor: 2.5,
        );
        return MediaQuery(
          data: mq.copyWith(textScaler: scaler),
          child: child,
        );
      },
    );
  }
}
