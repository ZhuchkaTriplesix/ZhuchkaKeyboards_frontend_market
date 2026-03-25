import 'package:flutter/material.dart';

import '../auth/auth_session.dart';
import '../auth/session_store.dart';
import '../l10n/app_localizations.dart';
import '../widgets/auth_modal.dart';
import '../widgets/market_async_views.dart';

/// Home / storefront landing (session, login CTA).
class StorefrontHome extends StatefulWidget {
  const StorefrontHome({super.key});

  @override
  State<StorefrontHome> createState() => _StorefrontHomeState();
}

class _StorefrontHomeState extends State<StorefrontHome> {
  final _authSession = AuthSessionService();

  bool _ready = false;
  bool _loggedIn = false;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _reloadSession();
  }

  @override
  void dispose() {
    _authSession.dispose();
    super.dispose();
  }

  Future<void> _reloadSession() async {
    var still = await SessionStore.hasAccessToken();
    String? email;
    if (still) {
      final profile = await _authSession.loadProfile();
      email = profile?.email;
      still = await SessionStore.hasAccessToken();
    }
    if (!mounted) return;
    setState(() {
      _loggedIn = still;
      _ready = true;
      _userEmail = still ? email : null;
    });
  }

  Future<void> _openAuth() async {
    await showAuthModal(context);
    await _reloadSession();
  }

  Future<void> _logout() async {
    await SessionStore.clear();
    if (!mounted) return;
    setState(() {
      _loggedIn = false;
      _userEmail = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).snackSignedOut)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!_ready) {
      return Scaffold(
        body: MarketLoadingView(message: l10n.loadingSession),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          if (_loggedIn)
            TextButton(
              onPressed: _logout,
              child: Text(l10n.actionSignOut),
            )
          else
            TextButton(
              onPressed: _openAuth,
              child: Text(l10n.actionSignIn),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.storefrontHeadline,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                if (_loggedIn && (_userEmail != null && _userEmail!.isNotEmpty)) ...[
                  const SizedBox(height: 8),
                  Text(
                    _userEmail!,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  _loggedIn ? l10n.storefrontHintLoggedIn : l10n.storefrontHintGuest,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                if (!_loggedIn)
                  FilledButton.icon(
                    onPressed: _openAuth,
                    icon: const Icon(Icons.login),
                    label: Text(l10n.storefrontLoginCta),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
