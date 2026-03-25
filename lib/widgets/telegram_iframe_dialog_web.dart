import 'dart:async' show StreamSubscription;
import 'dart:convert';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

const _callbackScriptId = 'zhuchka-tg-callback';

/// Inject global JS callback once per page load.
/// When Telegram widget calls `_zhuchkaTgAuth(user)`, it serialises the user
/// object to JSON and posts it to self via `postMessage` so Dart can pick it up.
void _ensureTelegramCallback() {
  if (html.document.getElementById(_callbackScriptId) != null) return;
  final script = html.ScriptElement()
    ..id = _callbackScriptId
    ..text = r'''
function _zhuchkaTgAuth(user) {
  window.postMessage(JSON.stringify(Object.assign({_tg:1},user)), '*');
}
''';
  html.document.head?.append(script);
}

/// Shows Telegram Login Widget (official `telegram-widget.js` with JS
/// callback) inside a Material 3 dialog. Returns auth payload or `null`.
Future<Map<String, dynamic>?> showTelegramLoginDialog(
  BuildContext context, {
  required String botUsername,
}) async {
  _ensureTelegramCallback();
  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => _TelegramDialog(botUsername: botUsername),
  );
}

class _TelegramDialog extends StatefulWidget {
  const _TelegramDialog({required this.botUsername});
  final String botUsername;

  @override
  State<_TelegramDialog> createState() => _TelegramDialogState();
}

class _TelegramDialogState extends State<_TelegramDialog> {
  static int _seq = 0;
  late final String _viewType = 'tg-widget-${_seq++}';
  StreamSubscription<html.MessageEvent>? _sub;

  @override
  void initState() {
    super.initState();

    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final container = html.DivElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.display = 'flex'
        ..style.justifyContent = 'center'
        ..style.alignItems = 'center';

      final script = html.ScriptElement()
        ..async = true
        ..src = 'https://telegram.org/js/telegram-widget.js?22';
      script.setAttribute('data-telegram-login', widget.botUsername);
      script.setAttribute('data-size', 'large');
      script.setAttribute('data-onauth', '_zhuchkaTgAuth(user)');
      script.setAttribute('data-request-access', 'write');
      container.append(script);

      return container;
    });

    _sub = html.window.onMessage.listen(_onMessage);
  }

  void _onMessage(html.MessageEvent event) {
    final data = event.data;
    Map<String, dynamic>? map;
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) {
          map = decoded;
        } else if (decoded is Map) {
          map = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
        return;
      }
    } else if (data is Map) {
      map = Map<String, dynamic>.from(data);
    }
    if (map == null || map['_tg'] != 1) return;
    map.remove('_tg');
    if (!map.containsKey('hash') || !map.containsKey('id')) return;
    debugPrint('[TelegramLogin] auth payload received, id=${map['id']}');
    if (mounted) Navigator.of(context).pop(map);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final narrow = MediaQuery.sizeOf(context).width < 600;
    final inset = narrow
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
        : const EdgeInsets.symmetric(horizontal: 40, vertical: 48);
    const telegramBlue = Color(0xFF229ED9);

    return Dialog(
      insetPadding: inset,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      clipBehavior: Clip.antiAlias,
      backgroundColor: cs.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 8, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    telegramBlue.withValues(alpha: 0.12),
                    cs.surface,
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: telegramBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.telegram, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Telegram',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  ),
                ],
              ),
            ),

            // Widget area
            SizedBox(
              height: 80,
              child: HtmlElementView(viewType: _viewType),
            ),

            // Hint
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Text(
                l10n.authTelegramWidgetHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
