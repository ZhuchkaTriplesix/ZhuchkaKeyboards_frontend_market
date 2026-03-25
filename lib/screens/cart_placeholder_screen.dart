import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../widgets/backend_readiness_body.dart';

/// Placeholder until storefront cart API exists (issue #7).
///
/// With `COMMERCE_BASE_URL` set, probes `GET /health/live` on the commerce service.
class CartPlaceholderScreen extends StatelessWidget {
  const CartPlaceholderScreen({
    super.key,
    this.debugCommerceBaseUrl,
    this.debugDio,
  });

  /// Test-only override for service base URL.
  final String? debugCommerceBaseUrl;

  /// Test-only [Dio] with a mock HTTP adapter (no real TCP).
  final Dio? debugDio;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final base = (debugCommerceBaseUrl ?? AppConfig.commerceBaseUrl).trim();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cartTitle),
      ),
      body: BackendReadinessBody(
        baseUrl: base,
        debugDio: debugDio,
        offlineIcon: Icons.shopping_cart_outlined,
        offlineTitle: l10n.cartEmptyTitle,
        offlineMessage: l10n.cartEmptyBody,
        awaitingIcon: Icons.shopping_cart_outlined,
        awaitingTitle: l10n.cartAwaitingApiTitle,
        awaitingMessage: l10n.cartAwaitingApiBody,
      ),
    );
  }
}
