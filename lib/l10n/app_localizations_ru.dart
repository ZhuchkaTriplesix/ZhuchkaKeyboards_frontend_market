// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Zhuchka Market';

  @override
  String get navHome => 'Главная';

  @override
  String get navCatalog => 'Каталог';

  @override
  String get navCart => 'Корзина';

  @override
  String get navHomeTooltip => 'Витрина — главная страница';

  @override
  String get navCatalogTooltip => 'Каталог товаров';

  @override
  String get navCartTooltip => 'Корзина покупок';

  @override
  String get loadingSession => 'Загрузка сессии…';

  @override
  String get loadingDefaultSemantics => 'Загрузка';

  @override
  String get storefrontHeadline => 'Zhuchka Keyboards';

  @override
  String get storefrontTagline =>
      'Клавиатуры, корпуса и комплектующие. Витрина для браузера и телефона.';

  @override
  String get storefrontHintLoggedIn =>
      'Сессия сохранена. Профиль подтягивается с сервера авторизации.';

  @override
  String get storefrontHintGuest =>
      'Войдите через Google или Telegram — так удобнее с корзиной и заказами.';

  @override
  String get storefrontFeatureCatalogTitle => 'Каталог';

  @override
  String get storefrontFeatureCatalogBody =>
      'Товары и конфигурации появятся здесь после подключения catalog API.';

  @override
  String get storefrontFeatureCartTitle => 'Корзина';

  @override
  String get storefrontFeatureCartBody =>
      'Список позиций и оформление — через commerce-сервис.';

  @override
  String get storefrontFeatureAccountTitle => 'Аккаунт';

  @override
  String get storefrontFeatureAccountBody =>
      'Единый вход: Google или Telegram, бэкенд Zhuchka Auth.';

  @override
  String get storefrontFeatureCta => 'Открыть';

  @override
  String get storefrontLoginCta => 'Войти или зарегистрироваться';

  @override
  String get storefrontSignedInChip => 'Вошли';

  @override
  String get storefrontSignedInFallback => 'Вы вошли в аккаунт';

  @override
  String get actionSignIn => 'Войти';

  @override
  String get actionSignOut => 'Выйти';

  @override
  String get snackSignedOut => 'Вы вышли из аккаунта';

  @override
  String get snackSignedIn => 'Вы вошли в аккаунт';

  @override
  String get catalogTitle => 'Каталог';

  @override
  String get catalogEmptyTitle => 'Каталог скоро здесь';

  @override
  String get catalogEmptyBody =>
      'Раздел каталога — заглушка до подключения backend API (см. issue #7).';

  @override
  String get cartTitle => 'Корзина';

  @override
  String get cartEmptyTitle => 'Корзина пуста';

  @override
  String get cartEmptyBody =>
      'Список позиций появится после интеграции commerce backend (issue #7).';

  @override
  String get catalogAwaitingApiTitle => 'Сервис каталога доступен';

  @override
  String get catalogAwaitingApiBody =>
      'Список товаров для витрины ещё не подключён. Продукты появятся здесь, когда в catalog-service будет GET /api/v1/products.';

  @override
  String get cartAwaitingApiTitle => 'Сервис commerce доступен';

  @override
  String get cartAwaitingApiBody =>
      'API корзины для витрины ещё не подключён. Корзина появится, когда commerce-service отдаст нужные эндпоинты.';

  @override
  String get authTitle => 'Вход';

  @override
  String get authSubtitle =>
      'Войдите через Google или Telegram. Сервер: Zhuchka Auth (federated).';

  @override
  String get authContinueGoogle => 'Продолжить с Google';

  @override
  String get authContinueTelegram => 'Войти через Telegram';

  @override
  String get authClose => 'Закрыть';

  @override
  String get authBusySemantics => 'Выполняется вход';

  @override
  String get authErrorGoogleClientId =>
      'Задайте GOOGLE_CLIENT_ID при сборке (--dart-define).';

  @override
  String get authErrorTelegramBot =>
      'Задайте TELEGRAM_BOT_USERNAME (--dart-define).';

  @override
  String get authTelegramWidgetHint =>
      'Если кнопка не появляется, проверьте домен в @BotFather (/setdomain) и TELEGRAM_BOT_TOKEN на сервере auth.';

  @override
  String get authErrorNoIdToken =>
      'Google не вернул id_token (проверьте meta / client ID для Web).';

  @override
  String get authBarrierDismiss => 'Закрыть';

  @override
  String get errorGenericTitle => 'Что-то пошло не так';

  @override
  String errorSemanticsLabel(String message) {
    return 'Ошибка. $message';
  }

  @override
  String get errorRetry => 'Повторить';

  @override
  String get errorTestNetwork => 'Сеть недоступна';
}
