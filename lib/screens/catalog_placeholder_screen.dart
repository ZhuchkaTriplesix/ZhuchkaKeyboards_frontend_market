import 'package:flutter/material.dart';

import '../widgets/market_async_views.dart';

/// Placeholder until catalog API is wired (issue #7).
class CatalogPlaceholderScreen extends StatelessWidget {
  const CatalogPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог'),
      ),
      body: const MarketEmptyView(
        icon: Icons.storefront_outlined,
        title: 'Каталог скоро здесь',
        message:
            'Раздел каталога — заглушка до подключения backend API (см. issue #7).',
      ),
    );
  }
}
