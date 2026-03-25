import 'package:flutter/material.dart';

/// Placeholder until catalog API is wired (issue #7).
class CatalogPlaceholderScreen extends StatelessWidget {
  const CatalogPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Раздел каталога — заглушка до подключения backend.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
