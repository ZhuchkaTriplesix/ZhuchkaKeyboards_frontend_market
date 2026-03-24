import 'package:flutter/material.dart';

import 'auth/session_store.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D2640)),
        useMaterial3: true,
      ),
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
  bool _ready = false;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _reloadSession();
  }

  Future<void> _reloadSession() async {
    final ok = await SessionStore.hasAccessToken();
    if (!mounted) return;
    setState(() {
      _loggedIn = ok;
      _ready = true;
    });
  }

  Future<void> _openAuth() async {
    await showAuthModal(context);
    await _reloadSession();
  }

  Future<void> _logout() async {
    await SessionStore.clear();
    if (!mounted) return;
    setState(() => _loggedIn = false);
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
                const SizedBox(height: 12),
                Text(
                  _loggedIn
                      ? 'Сессия сохранена локально (access / refresh token). Дальше — каталог и корзина.'
                      : 'Нажмите «Войти» — модальное окно (не шторка). Google и Telegram при настройке auth.',
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
