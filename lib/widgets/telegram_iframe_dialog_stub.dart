import 'package:flutter/material.dart';

/// Non-web: Telegram Login widget is not available. Returns null.
Future<Map<String, dynamic>?> showTelegramLoginDialog(
  BuildContext context, {
  required String botUsername,
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
  return null;
}
