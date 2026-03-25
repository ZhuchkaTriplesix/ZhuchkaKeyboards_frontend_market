import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../widgets/backend_readiness_body.dart';

/// Placeholder until catalog storefront API is wired (issue #7).
///
/// With `CATALOG_BASE_URL` set, probes `GET /health/live` on the catalog service.
class CatalogPlaceholderScreen extends StatelessWidget {
  const CatalogPlaceholderScreen({
    super.key,
    this.debugCatalogBaseUrl,
    this.debugDio,
  });

  /// Test-only override for service base URL.
  final String? debugCatalogBaseUrl;

  /// Test-only [Dio] with a mock HTTP adapter (no real TCP).
  final Dio? debugDio;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final base = (debugCatalogBaseUrl ?? AppConfig.catalogBaseUrl).trim();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.catalogTitle),
      ),
      body: BackendReadinessBody(
        baseUrl: base,
        debugDio: debugDio,
        offlineIcon: Icons.storefront_outlined,
        offlineTitle: l10n.catalogEmptyTitle,
        offlineMessage: l10n.catalogEmptyBody,
        awaitingIcon: Icons.cloud_done_outlined,
        awaitingTitle: l10n.catalogAwaitingApiTitle,
        awaitingMessage: l10n.catalogAwaitingApiBody,
      ),
    );
  }
}
