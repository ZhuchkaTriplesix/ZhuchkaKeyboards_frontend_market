import 'package:flutter/material.dart';

import 'auth/auth_session.dart';
import 'auth/session_store.dart';
import 'theme/market_theme.dart';
import 'widgets/auth_modal.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zhuchka Market',
      themeMode: ThemeMode.dark,
      theme: buildZhuchkaMarketTheme(),
      home: const StorefrontHome(),
    );
  }
}

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
      const SnackBar(content: Text('Вы вышли из аккаунта')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zhuchka Market'),
        actions: [
          if (_loggedIn)
            TextButton(
              onPressed: _logout,
              child: const Text('Выйти'),
            )
          else
            TextButton(
              onPressed: _openAuth,
              child: const Text('Войти'),
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
                  'Витрина для покупателей',
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
                  _loggedIn
                      ? 'Сессия: токены в локальном хранилище; профиль с auth-сервера (userinfo).'
                      : 'Нажмите «Войти» — модальное окно. Google и Telegram при настройке auth.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                if (!_loggedIn)
                  FilledButton.icon(
                    onPressed: _openAuth,
                    icon: const Icon(Icons.login),
                    label: const Text('Войти или зарегистрироваться'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
