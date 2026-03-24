import 'package:flutter/material.dart';

/// Non-web: Telegram Login widget is not available.
Future<void> showTelegramLoginDialog(
  BuildContext context, {
  required String botUsername,
  required Future<void> Function(Map<String, dynamic> payload) onAuth,
}) async {
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Telegram'),
      content: const Text(
        'Вход через Telegram доступен в веб-сборке (Flutter Web).',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
      ],
    ),
  );
}
