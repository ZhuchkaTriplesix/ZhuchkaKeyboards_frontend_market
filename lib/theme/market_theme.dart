import 'package:flutter/material.dart';

/// Accent seed for [ColorScheme] (Material 3 dark).
///
/// UI bar: [`docs/frontend-requirements.md`](https://github.com/ZhuchkaTriplesix/ZhuchkaKeyboards/blob/dev/docs/frontend-requirements.md)
/// (OLED `#000000` scaffold, M3 surfaces).
const Color kZhuchkaMarketBrandSeed = Color(0xFF2D2640);

/// Project surface tokens layered on Material 3.
@immutable
class ZhuchkaMarketTokens extends ThemeExtension<ZhuchkaMarketTokens> {
  const ZhuchkaMarketTokens({
    this.oledBlack = const Color(0xFF000000),
  });

  /// Root scaffold / app background — strict OLED black (spec §2.1).
  final Color oledBlack;

  @override
  ZhuchkaMarketTokens copyWith({Color? oledBlack}) {
    return ZhuchkaMarketTokens(oledBlack: oledBlack ?? this.oledBlack);
  }

  @override
  ZhuchkaMarketTokens lerp(ThemeExtension<ZhuchkaMarketTokens>? other, double t) {
    if (other is! ZhuchkaMarketTokens) return this;
    return ZhuchkaMarketTokens(
      oledBlack: Color.lerp(oledBlack, other.oledBlack, t)!,
    );
  }
}

/// Dark-only storefront theme: M3, OLED black scaffold, generated [ColorScheme].
ThemeData buildZhuchkaMarketTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: kZhuchkaMarketBrandSeed,
    brightness: Brightness.dark,
  );

  const tokens = ZhuchkaMarketTokens();

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: tokens.oledBlack,
    extensions: const [tokens],
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surfaceContainerHighest,
      surfaceTintColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
    ),
  );
}
