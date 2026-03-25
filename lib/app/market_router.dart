import 'package:go_router/go_router.dart';

import '../screens/cart_placeholder_screen.dart';
import '../screens/catalog_placeholder_screen.dart';
import '../screens/storefront_home_screen.dart';
import '../widgets/market_shell.dart';

/// Web routes: home, catalog/cart placeholders behind [MarketShell].
GoRouter createMarketRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MarketShell(
            location: state.uri.path,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const StorefrontHome(),
          ),
          GoRoute(
            path: '/catalog',
            builder: (context, state) => const CatalogPlaceholderScreen(),
          ),
          GoRoute(
            path: '/cart',
            builder: (context, state) => const CartPlaceholderScreen(),
          ),
        ],
      ),
    ],
  );
}
