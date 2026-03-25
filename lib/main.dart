import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'app/market_router.dart';
import 'l10n/app_localizations.dart';
import 'theme/market_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.debugLocale});

  /// Forces [Locale] in widget tests; in production leave null (browser / OS).
  final Locale? debugLocale;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router = createMarketRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      themeMode: ThemeMode.dark,
      theme: buildZhuchkaMarketTheme(),
      routerConfig: _router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: (locales, supported) {
        if (widget.debugLocale != null) {
          return widget.debugLocale!;
        }
        for (final loc in locales ?? const <Locale>[]) {
          if (loc.languageCode == 'en') {
            return const Locale('en');
          }
        }
        return const Locale('ru');
      },
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
