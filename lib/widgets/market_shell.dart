import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';

/// App chrome: primary destinations + [child] from [GoRouter] [ShellRoute].
class MarketShell extends StatelessWidget {
  const MarketShell({
    required this.location,
    required this.child,
    super.key,
  });

  final String location;
  final Widget child;

  int get _selectedIndex {
    if (location.startsWith('/catalog')) return 1;
    if (location.startsWith('/cart')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Expanded(child: child),
        NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
                context.go('/');
              case 1:
                context.go('/catalog');
              case 2:
                context.go('/cart');
            }
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: l10n.navHome,
              tooltip: l10n.navHomeTooltip,
            ),
            NavigationDestination(
              icon: const Icon(Icons.storefront_outlined),
              selectedIcon: const Icon(Icons.storefront),
              label: l10n.navCatalog,
              tooltip: l10n.navCatalogTooltip,
            ),
            NavigationDestination(
              icon: const Icon(Icons.shopping_cart_outlined),
              selectedIcon: const Icon(Icons.shopping_cart),
              label: l10n.navCart,
              tooltip: l10n.navCartTooltip,
            ),
          ],
        ),
      ],
    );
  }
}
