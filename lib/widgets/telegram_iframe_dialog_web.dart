import 'dart:async' show StreamSubscription, unawaited;
import 'dart:convert';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

/// Web: Telegram Login embed (iframe) + [window.onMessage] for auth payload.
Future<void> showTelegramLoginDialog(
  BuildContext context, {
  required String botUsername,
  required Future<void> Function(Map<String, dynamic> payload) onAuth,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return _TelegramDialog(
        botUsername: botUsername,
        onAuth: onAuth,
      );
    },
  );
}

class _TelegramDialog extends StatefulWidget {
  const _TelegramDialog({
    required this.botUsername,
    required this.onAuth,
  });

  final String botUsername;
  final Future<void> Function(Map<String, dynamic> payload) onAuth;

  @override
  State<_TelegramDialog> createState() => _TelegramDialogState();
}

class _TelegramDialogState extends State<_TelegramDialog> {
  static int _seq = 0;
  late final String _viewType = 'telegram-login-${_seq++}';
  StreamSubscription<html.MessageEvent>? _sub;

  @override
  void initState() {
    super.initState();
    final origin = html.window.location.origin;
    final src =
        'https://oauth.telegram.org/embed/${widget.botUsername}?origin=${Uri.encodeComponent(origin)}&size=large&request_access=write';
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = html.IFrameElement()
        ..src = src
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%';
      return iframe;
    });

    _sub = html.window.onMessage.listen((event) {
      final data = event.data;
      Map<String, dynamic>? map;
      if (data is String) {
        try {
          final decoded = jsonDecode(data);
          if (decoded is Map<String, dynamic>) map = decoded;
        } catch (_) {
          return;
        }
      } else if (data is Map) {
        map = Map<String, dynamic>.from(data);
      }
      if (map == null) return;
      if (!map.containsKey('hash') || !map.containsKey('id')) return;
      if (mounted) Navigator.of(context).pop();
      unawaited(widget.onAuth(map));
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Telegram',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            SizedBox(
              height: 360,
              child: HtmlElementView(viewType: _viewType),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Если окно пустое, проверьте домен в @BotFather (/setdomain) и TELEGRAM_BOT_TOKEN на сервере auth.',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
