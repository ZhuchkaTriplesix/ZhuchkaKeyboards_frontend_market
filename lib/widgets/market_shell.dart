import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Главная',
            ),
            NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              selectedIcon: Icon(Icons.storefront),
              label: 'Каталог',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart_outlined),
              selectedIcon: Icon(Icons.shopping_cart),
              label: 'Корзина',
            ),
          ],
        ),
      ],
    );
  }
}
