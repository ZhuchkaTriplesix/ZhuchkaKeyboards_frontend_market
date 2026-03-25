import 'package:flutter/material.dart';

/// Material 3–style breakpoint: at or above this width we use [NavigationRail] (desktop web).
const double kMarketWideLayoutMinWidth = 840;

/// Wider rail with extended labels (logo + text destinations).
const double kMarketRailExtendedMinWidth = 1040;

bool marketUseWideLayout(BuildContext context) {
  return MediaQuery.sizeOf(context).width >= kMarketWideLayoutMinWidth;
}

bool marketUseExtendedRail(BuildContext context) {
  return MediaQuery.sizeOf(context).width >= kMarketRailExtendedMinWidth;
}
