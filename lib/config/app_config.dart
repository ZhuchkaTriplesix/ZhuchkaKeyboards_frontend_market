/// Build-time configuration (--dart-define).
class AppConfig {
  AppConfig._();

  static const String authBaseUrl = String.fromEnvironment(
    'AUTH_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  static const String oauthPublicClientId = String.fromEnvironment(
    'OAUTH_CLIENT_ID',
    defaultValue: 'zhuchka-market-web',
  );

  /// Web client ID from Google Cloud Console (OAuth 2.0 Client IDs → Web).
  static const String googleClientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
    defaultValue: '',
  );

  /// @BotFather username without @ (for Telegram Login embed iframe).
  static const String telegramBotUsername = String.fromEnvironment(
    'TELEGRAM_BOT_USERNAME',
    defaultValue: '',
  );
}
