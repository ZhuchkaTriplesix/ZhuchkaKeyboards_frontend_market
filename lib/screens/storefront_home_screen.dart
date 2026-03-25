import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_session.dart';
import '../auth/session_store.dart';
import '../l10n/app_localizations.dart';
import '../theme/market_breakpoints.dart';
import '../widgets/auth_modal.dart';
import '../widgets/market_async_views.dart';

/// Home / storefront landing (session, login CTA) — Material 3 layout: hero + feature cards,
/// responsive for wide browsers and narrow phones.
class StorefrontHome extends StatefulWidget {
  const StorefrontHome({super.key});

  @override
  State<StorefrontHome> createState() => _StorefrontHomeState();
}

class _StorefrontHomeState extends State<StorefrontHome> {
  final _authSession = AuthSessionService();

  bool _ready = false;
  bool _loggedIn = false;
  /// From userinfo / synthetic Telegram label; null if profile failed but token exists.
  String? _accountDisplay;

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
    String? accountLine;
    if (still) {
      final profile = await _authSession.loadProfile();
      accountLine = profile?.displayAccountLine;
      still = await SessionStore.hasAccessToken();
    }
    if (!mounted) return;
    setState(() {
      _loggedIn = still;
      _ready = true;
      _accountDisplay = still ? accountLine : null;
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
      _accountDisplay = null;
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

    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final wide = marketUseWideLayout(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          if (_loggedIn)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Chip(
                avatar: Icon(
                  Icons.verified_user_rounded,
                  size: 18,
                  color: scheme.tertiary,
                ),
                label: Text(l10n.storefrontSignedInChip),
                backgroundColor: scheme.surfaceContainerHighest,
                side: BorderSide(color: scheme.outlineVariant),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          if (_loggedIn)
            TextButton(
              onPressed: _logout,
              child: Text(l10n.actionSignOut),
            )
          else
            FilledButton.tonal(
              onPressed: _openAuth,
              child: Text(l10n.actionSignIn),
            ),
          SizedBox(width: wide ? 16 : 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxContent = 1120.0;
          final horizontal = wide ? 40.0 : 16.0;
          final heroPad = wide ? 40.0 : 22.0;
          final headlineStyle = wide ? tt.displaySmall : tt.headlineMedium;
          final taglineStyle = (wide ? tt.titleMedium : tt.bodyLarge)?.copyWith(
            color: scheme.onSurfaceVariant,
            height: 1.35,
          );

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContent),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(horizontal, wide ? 20 : 12, horizontal, 0),
                    sliver: SliverToBoxAdapter(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                scheme.primaryContainer.withValues(alpha: 0.45),
                                scheme.surfaceContainerHighest.withValues(alpha: 0.95),
                                scheme.surfaceContainerLow.withValues(alpha: 0.85),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(heroPad),
                            child: Column(
                              crossAxisAlignment:
                                  wide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.storefrontHeadline,
                                  style: headlineStyle?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: wide ? -0.5 : -0.25,
                                  ),
                                  textAlign: wide ? TextAlign.start : TextAlign.center,
                                ),
                                SizedBox(height: wide ? 12 : 10),
                                Text(
                                  l10n.storefrontTagline,
                                  style: taglineStyle,
                                  textAlign: wide ? TextAlign.start : TextAlign.center,
                                ),
                                if (_loggedIn) ...[
                                  SizedBox(height: wide ? 20 : 16),
                                  Material(
                                    color: scheme.tertiaryContainer.withValues(alpha: 0.65),
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: wide
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle_rounded,
                                            size: 22,
                                            color: scheme.onTertiaryContainer,
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                            child: Text(
                                              (_accountDisplay != null &&
                                                      _accountDisplay!.isNotEmpty)
                                                  ? _accountDisplay!
                                                  : l10n.storefrontSignedInFallback,
                                              style: tt.titleMedium?.copyWith(
                                                color: scheme.onTertiaryContainer,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: wide
                                                  ? TextAlign.start
                                                  : TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                SizedBox(height: wide ? 24 : 20),
                                Text(
                                  _loggedIn
                                      ? l10n.storefrontHintLoggedIn
                                      : l10n.storefrontHintGuest,
                                  style: tt.bodyLarge?.copyWith(
                                    color: scheme.onSurface.withValues(alpha: 0.9),
                                    height: 1.4,
                                  ),
                                  textAlign: wide ? TextAlign.start : TextAlign.center,
                                ),
                                if (!_loggedIn) ...[
                                  SizedBox(height: wide ? 28 : 20),
                                  Align(
                                    alignment:
                                        wide ? Alignment.centerLeft : Alignment.center,
                                    child: FilledButton.icon(
                                      onPressed: _openAuth,
                                      icon: const Icon(Icons.login_rounded),
                                      label: Text(l10n.storefrontLoginCta),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(horizontal, 28, horizontal, 32),
                    sliver: SliverToBoxAdapter(
                      child: wide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _StorefrontFeatureCard(
                                    icon: Icons.storefront_rounded,
                                    title: l10n.storefrontFeatureCatalogTitle,
                                    body: l10n.storefrontFeatureCatalogBody,
                                    onTap: () => context.go('/catalog'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _StorefrontFeatureCard(
                                    icon: Icons.shopping_cart_rounded,
                                    title: l10n.storefrontFeatureCartTitle,
                                    body: l10n.storefrontFeatureCartBody,
                                    onTap: () => context.go('/cart'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _StorefrontFeatureCard(
                                    icon: Icons.badge_rounded,
                                    title: l10n.storefrontFeatureAccountTitle,
                                    body: l10n.storefrontFeatureAccountBody,
                                    onTap: _openAuth,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _StorefrontFeatureCard(
                                  icon: Icons.storefront_rounded,
                                  title: l10n.storefrontFeatureCatalogTitle,
                                  body: l10n.storefrontFeatureCatalogBody,
                                  onTap: () => context.go('/catalog'),
                                ),
                                const SizedBox(height: 12),
                                _StorefrontFeatureCard(
                                  icon: Icons.shopping_cart_rounded,
                                  title: l10n.storefrontFeatureCartTitle,
                                  body: l10n.storefrontFeatureCartBody,
                                  onTap: () => context.go('/cart'),
                                ),
                                const SizedBox(height: 12),
                                _StorefrontFeatureCard(
                                  icon: Icons.badge_rounded,
                                  title: l10n.storefrontFeatureAccountTitle,
                                  body: l10n.storefrontFeatureAccountBody,
                                  onTap: _openAuth,
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StorefrontFeatureCard extends StatelessWidget {
  const _StorefrontFeatureCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: scheme.primary),
              const SizedBox(height: 14),
              Text(
                title,
                style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                body,
                style: tt.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    l10n.storefrontFeatureCta,
                    style: tt.labelLarge?.copyWith(color: scheme.primary),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 20, color: scheme.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
