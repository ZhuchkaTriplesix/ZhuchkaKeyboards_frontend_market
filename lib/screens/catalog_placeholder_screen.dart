import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../widgets/market_async_views.dart';

/// Placeholder until catalog API is wired (issue #7).
class CatalogPlaceholderScreen extends StatelessWidget {
  const CatalogPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.catalogTitle),
      ),
      body: MarketEmptyView(
        icon: Icons.storefront_outlined,
        title: l10n.catalogEmptyTitle,
        message: l10n.catalogEmptyBody,
      ),
    );
  }
}
