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
    visualDensity: VisualDensity.standard,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: colorScheme.surfaceContainerHighest,
      surfaceTintColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: colorScheme.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 3,
      height: 72,
      backgroundColor: colorScheme.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      indicatorColor: colorScheme.secondaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final base = TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
        );
        if (states.contains(WidgetState.selected)) {
          return base.copyWith(color: colorScheme.onSecondaryContainer);
        }
        return base;
      }),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: colorScheme.surfaceContainerLow,
      elevation: 0,
      indicatorColor: colorScheme.secondaryContainer,
      selectedIconTheme: IconThemeData(color: colorScheme.onSecondaryContainer),
      unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
      selectedLabelTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      unselectedLabelTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
