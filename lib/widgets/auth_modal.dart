import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../auth/auth_api.dart';
import '../auth/session_store.dart';
import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import 'telegram_iframe_dialog.dart';

/// Centered modal dialog (not bottom sheet) for storefront login.
Future<void> showAuthModal(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: AppLocalizations.of(context).authBarrierDismiss,
    builder: (ctx) => const _AuthDialog(),
  );
}

class _AuthDialog extends StatefulWidget {
  const _AuthDialog();

  @override
  State<_AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<_AuthDialog> {
  bool _busy = false;
  String? _error;
  final _api = AuthApi();

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  Future<void> _finishWithTokens(Map<String, dynamic> tokens) async {
    await SessionStore.saveOAuthTokens(tokens);
    if (!mounted) return;
    Navigator.of(context).pop(true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).snackSignedIn)),
    );
  }

  Future<void> _onGoogle() async {
    final clientId = AppConfig.googleClientId.trim();
    if (clientId.isEmpty) {
      setState(() => _error = AppLocalizations.of(context).authErrorGoogleClientId);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final google = GoogleSignIn(
        clientId: kIsWeb ? clientId : null,
        scopes: ['email', 'openid', 'profile'],
      );
      final account = await google.signIn();
      if (account == null) {
        setState(() => _busy = false);
        return;
      }
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        setState(() {
          _busy = false;
          _error = AppLocalizations.of(context).authErrorNoIdToken;
        });
        return;
      }
      final tokens = await _api.loginWithGoogleIdToken(idToken);
      setState(() => _busy = false);
      await _finishWithTokens(tokens);
    } catch (e, st) {
      debugPrint('$e\n$st');
      setState(() {
        _busy = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _onTelegramPayload(Map<String, dynamic> payload) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final tokens = await _api.loginWithTelegram(payload);
      setState(() => _busy = false);
      await _finishWithTokens(tokens);
    } catch (e, st) {
      debugPrint('$e\n$st');
      setState(() {
        _busy = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _openTelegram() async {
    final bot = AppConfig.telegramBotUsername.trim();
    if (bot.isEmpty) {
      setState(() => _error = AppLocalizations.of(context).authErrorTelegramBot);
      return;
    }
    await showTelegramLoginDialog(
      context,
      botUsername: bot,
      onAuth: _onTelegramPayload,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Semantics(
      namesRoute: true,
      label: l10n.authTitle,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    header: true,
                    child: Text(l10n.authTitle, style: theme.textTheme.headlineSmall),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.authSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_error != null) ...[
                    Semantics(
                      liveRegion: true,
                      container: true,
                      child: Material(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            _error!,
                            style: TextStyle(color: theme.colorScheme.onErrorContainer),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                FilledButton.icon(
                  onPressed: _busy ? null : _onGoogle,
                  icon: const Icon(Icons.login, size: 22),
                  label: Text(l10n.authContinueGoogle),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1F1F1F),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFDADCE0)),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _busy ? null : _openTelegram,
                  icon: const Icon(Icons.send, size: 22),
                  label: Text(l10n.authContinueTelegram),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF229ED9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
                if (_busy)
                  Semantics(
                    label: l10n.authBusySemantics,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _busy ? null : () => Navigator.of(context).pop(),
                    child: Text(l10n.authClose),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
