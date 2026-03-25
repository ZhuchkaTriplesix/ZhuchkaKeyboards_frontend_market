import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../http/dio_user_message.dart';
import '../http/service_dio.dart';
import '../l10n/app_localizations.dart';
import 'market_async_views.dart';

enum _Phase { offline, loading, error, backendLive }

/// Empty placeholder when [baseUrl] is empty; otherwise probes [healthPath] and
/// shows loading, retryable error, or an "API not wired yet" empty state.
class BackendReadinessBody extends StatefulWidget {
  const BackendReadinessBody({
    super.key,
    required this.baseUrl,
    this.debugDio,
    this.healthPath = '/health/live',
    required this.offlineIcon,
    required this.offlineTitle,
    required this.offlineMessage,
    required this.awaitingIcon,
    required this.awaitingTitle,
    required this.awaitingMessage,
  });

  final String baseUrl;
  final Dio? debugDio;
  final String healthPath;
  final IconData offlineIcon;
  final String offlineTitle;
  final String offlineMessage;
  final IconData awaitingIcon;
  final String awaitingTitle;
  final String awaitingMessage;

  @override
  State<BackendReadinessBody> createState() => _BackendReadinessBodyState();
}

class _BackendReadinessBodyState extends State<BackendReadinessBody> {
  _Phase _phase =
      _Phase.offline; // set to loading in initState when baseUrl non-empty
  String? _errorDetail;

  @override
  void initState() {
    super.initState();
    if (widget.baseUrl.trim().isNotEmpty) {
      _phase = _Phase.loading;
      _probe();
    }
  }

  Future<void> _probe() async {
    if (widget.baseUrl.trim().isEmpty) {
      return;
    }
    setState(() {
      _phase = _Phase.loading;
      _errorDetail = null;
    });
    try {
      final dio = widget.debugDio ?? createServiceDio(widget.baseUrl.trim());
      await dio.get<Object>(widget.healthPath);
      if (!mounted) {
        return;
      }
      setState(() => _phase = _Phase.backendLive);
    } on DioException catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _phase = _Phase.error;
        _errorDetail = userMessageFromDio(e);
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _phase = _Phase.error;
        _errorDetail = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (_phase) {
      case _Phase.offline:
        return MarketEmptyView(
          icon: widget.offlineIcon,
          title: widget.offlineTitle,
          message: widget.offlineMessage,
        );
      case _Phase.loading:
        return const MarketLoadingView();
      case _Phase.error:
        final msg = _errorDetail ?? l10n.errorGenericTitle;
        return MarketErrorView(
          message: msg,
          onRetry: _probe,
        );
      case _Phase.backendLive:
        return MarketEmptyView(
          icon: widget.awaitingIcon,
          title: widget.awaitingTitle,
          message: widget.awaitingMessage,
        );
    }
  }
}
