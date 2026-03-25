import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../widgets/market_async_views.dart';

/// Placeholder until cart flow exists (issue #7).
class CartPlaceholderScreen extends StatelessWidget {
  const CartPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cartTitle),
      ),
      body: MarketEmptyView(
        icon: Icons.shopping_cart_outlined,
        title: l10n.cartEmptyTitle,
        message: l10n.cartEmptyBody,
      ),
    );
  }
}
