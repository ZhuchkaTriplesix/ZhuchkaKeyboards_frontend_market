import 'package:flutter/material.dart';

import '../widgets/market_async_views.dart';

/// Placeholder until cart flow exists (issue #7).
class CartPlaceholderScreen extends StatelessWidget {
  const CartPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: const MarketEmptyView(
        icon: Icons.shopping_cart_outlined,
        title: 'Корзина пуста',
        message:
            'Список позиций появится после интеграции commerce backend (issue #7).',
      ),
    );
  }
}
