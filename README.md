# Zhuchka Market (Flutter web)

Storefront UI. This repo targets **web only** (no mobile/desktop platforms in the tree).

**UI spec:** [`docs/frontend-requirements.md`](https://github.com/ZhuchkaTriplesix/ZhuchkaKeyboards/blob/dev/docs/frontend-requirements.md) in the monorepo — Material 3, OLED scaffold `#000000`, shared tokens in `lib/theme/market_theme.dart` (`buildZhuchkaMarketTheme()`).

**Routing:** [`go_router`](https://pub.dev/packages/go_router) + shell (`lib/widgets/market_shell.dart`). Paths: `/` (витрина), `/catalog` и `/cart` — заглушки до backend (см. issue #7).

## Configuration (build-time)

Переменные задаются через `--dart-define` (и при `flutter build web`):

| Переменная | Назначение | Значение по умолчанию |
|------------|------------|------------------------|
| `AUTH_BASE_URL` | Базовый URL auth-сервиса (OAuth, userinfo, refresh) | `http://127.0.0.1:8000` |
| `OAUTH_CLIENT_ID` | Публичный client_id для refresh_token и federated login | `zhuchka-market-web` |
| `GOOGLE_CLIENT_ID` | Web client ID из Google Cloud (OAuth 2.0 → Web) | пусто |
| `TELEGRAM_BOT_USERNAME` | Имя бота без `@` для Telegram Login (iframe) | пусто |

Пример:

```bash
flutter run -d chrome --dart-define=AUTH_BASE_URL=https://auth.example.com --dart-define=GOOGLE_CLIENT_ID=xxx.apps.googleusercontent.com --dart-define=TELEGRAM_BOT_USERNAME=my_bot
```

Для Google Sign-In в `web/index.html` в мета-теге `google-signin-client_id` должен быть тот же Web client ID.

## Run (Chrome)

```bash
flutter run -d chrome
```

## Build static site

```bash
flutter build web
```

Output: `build/web/`.

## Tests

```bash
flutter test
```

## CI (GitHub Actions)

On push/PR to `dev`, `main`, or `master`, `.github/workflows/flutter_ci.yml` runs `flutter analyze`, `flutter test`, and `flutter build web --release` on Ubuntu with the stable SDK.
