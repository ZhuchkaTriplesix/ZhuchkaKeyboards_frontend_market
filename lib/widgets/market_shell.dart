import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../theme/market_breakpoints.dart';

/// App chrome: [NavigationRail] on wide viewports, [NavigationBar] on phones —
/// [child] is the active route from [GoRouter] [ShellRoute].
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

  void _go(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/catalog');
      case 2:
        context.go('/cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final wide = marketUseWideLayout(context);
    final extendedRail = marketUseExtendedRail(context);

    final destinations = <NavigationRailDestination>[
      NavigationRailDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home_rounded),
        label: Text(l10n.navHome),
        padding: const EdgeInsets.symmetric(vertical: 4),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.storefront_outlined),
        selectedIcon: const Icon(Icons.storefront_rounded),
        label: Text(l10n.navCatalog),
        padding: const EdgeInsets.symmetric(vertical: 4),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.shopping_cart_outlined),
        selectedIcon: const Icon(Icons.shopping_cart_rounded),
        label: Text(l10n.navCart),
        padding: const EdgeInsets.symmetric(vertical: 4),
      ),
    ];

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NavigationRail(
            extended: extendedRail,
            minExtendedWidth: 232,
            selectedIndex: _selectedIndex,
            groupAlignment: -0.85,
            onDestinationSelected: (i) => _go(context, i),
            leading: extendedRail
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
                    child: Row(
                      children: [
                        Icon(
                          Icons.keyboard_alt_rounded,
                          size: 28,
                          color: scheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.appTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.2,
                                ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 20),
                    child: Icon(
                      Icons.keyboard_alt_rounded,
                      size: 28,
                      color: scheme.primary,
                    ),
                  ),
            destinations: destinations,
            labelType: extendedRail
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.all,
          ),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: scheme.outlineVariant.withValues(alpha: 0.5),
          ),
          Expanded(child: child),
        ],
      );
    }

    return Column(
      children: [
        Expanded(child: child),
        SafeArea(
          top: false,
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) => _go(context, i),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_rounded),
                label: l10n.navHome,
                tooltip: l10n.navHomeTooltip,
              ),
              NavigationDestination(
                icon: const Icon(Icons.storefront_outlined),
                selectedIcon: const Icon(Icons.storefront_rounded),
                label: l10n.navCatalog,
                tooltip: l10n.navCatalogTooltip,
              ),
              NavigationDestination(
                icon: const Icon(Icons.shopping_cart_outlined),
                selectedIcon: const Icon(Icons.shopping_cart_rounded),
                label: l10n.navCart,
                tooltip: l10n.navCartTooltip,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
