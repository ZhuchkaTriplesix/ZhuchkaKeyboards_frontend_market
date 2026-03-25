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
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    await SessionStore.saveOAuthTokens(tokens);
    if (!mounted) return;
    Navigator.of(context).pop(true);
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(l10n.snackSignedIn),
      ),
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

  Future<void> _openTelegram() async {
    final bot = AppConfig.telegramBotUsername.trim();
    if (bot.isEmpty) {
      setState(() => _error = AppLocalizations.of(context).authErrorTelegramBot);
      return;
    }
    final payload = await showTelegramLoginDialog(context, botUsername: bot);
    if (payload == null || !mounted) return;
    debugPrint('[AuthModal] Telegram payload received, sending to auth…');
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final tokens = await _api.loginWithTelegram(payload);
      if (!mounted) return;
      setState(() => _busy = false);
      await _finishWithTokens(tokens);
    } catch (e, st) {
      debugPrint('[AuthModal] loginWithTelegram error: $e\n$st');
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final narrow = MediaQuery.sizeOf(context).width < 600;
    final inset = narrow
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 24)
        : const EdgeInsets.symmetric(horizontal: 40, vertical: 48);

    final cs = theme.colorScheme;

    return Semantics(
      namesRoute: true,
      label: l10n.authTitle,
      child: Dialog(
        insetPadding: inset,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        clipBehavior: Clip.antiAlias,
        backgroundColor: cs.surfaceContainerHigh,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        cs.primaryContainer.withValues(alpha: 0.5),
                        cs.surfaceContainerHigh,
                      ],
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: cs.secondaryContainer,
                        child: Icon(Icons.lock_rounded, color: cs.onSecondaryContainer, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.authTitle,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.authSubtitle,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: cs.onSurfaceVariant,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_error != null) ...[
                        Semantics(
                          liveRegion: true,
                          container: true,
                          child: Material(
                            color: cs.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Text(
                                _error!,
                                style: TextStyle(
                                  color: cs.onErrorContainer,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      FilledButton.icon(
                        onPressed: _busy ? null : _onGoogle,
                        icon: const Icon(Icons.login_rounded, size: 22),
                        label: Text(l10n.authContinueGoogle),
                        style: FilledButton.styleFrom(
                          backgroundColor: cs.surface,
                          foregroundColor: cs.onSurface,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: cs.outlineVariant),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FilledButton.icon(
                        onPressed: _busy ? null : _openTelegram,
                        icon: const Icon(Icons.telegram, size: 22),
                        label: Text(l10n.authContinueTelegram),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF229ED9),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_busy)
                        Semantics(
                          label: l10n.authBusySemantics,
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: CircularProgressIndicator(),
                            ),
                          ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
