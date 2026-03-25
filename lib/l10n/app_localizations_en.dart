// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Zhuchka Market';

  @override
  String get navHome => 'Home';

  @override
  String get navCatalog => 'Catalog';

  @override
  String get navCart => 'Cart';

  @override
  String get navHomeTooltip => 'Storefront home';

  @override
  String get navCatalogTooltip => 'Product catalog';

  @override
  String get navCartTooltip => 'Shopping cart';

  @override
  String get loadingSession => 'Loading session…';

  @override
  String get loadingDefaultSemantics => 'Loading';

  @override
  String get storefrontHeadline => 'Storefront for shoppers';

  @override
  String get storefrontHintLoggedIn =>
      'Session: tokens in local storage; profile from auth (userinfo).';

  @override
  String get storefrontHintGuest =>
      'Tap Sign in — modal dialog. Google and Telegram when auth is configured.';

  @override
  String get storefrontLoginCta => 'Sign in or register';

  @override
  String get actionSignIn => 'Sign in';

  @override
  String get actionSignOut => 'Sign out';

  @override
  String get snackSignedOut => 'You have signed out';

  @override
  String get snackSignedIn => 'Signed in';

  @override
  String get catalogTitle => 'Catalog';

  @override
  String get catalogEmptyTitle => 'Catalog coming soon';

  @override
  String get catalogEmptyBody =>
      'This section is a placeholder until the catalog API is connected (see issue #7).';

  @override
  String get cartTitle => 'Cart';

  @override
  String get cartEmptyTitle => 'Cart is empty';

  @override
  String get cartEmptyBody =>
      'Your items will appear after commerce backend integration (issue #7).';

  @override
  String get catalogAwaitingApiTitle => 'Catalog service is up';

  @override
  String get catalogAwaitingApiBody =>
      'Storefront product list is not wired yet. Products will appear here when GET /api/v1/products exists on the catalog service.';

  @override
  String get cartAwaitingApiTitle => 'Commerce service is up';

  @override
  String get cartAwaitingApiBody =>
      'Storefront cart API is not wired yet. Your cart will appear when the commerce service exposes cart endpoints.';

  @override
  String get authTitle => 'Sign in';

  @override
  String get authSubtitle =>
      'Sign in with Google or Telegram. Server: Zhuchka Auth (federated).';

  @override
  String get authContinueGoogle => 'Continue with Google';

  @override
  String get authContinueTelegram => 'Sign in with Telegram';

  @override
  String get authClose => 'Close';

  @override
  String get authBusySemantics => 'Signing in';

  @override
  String get authErrorGoogleClientId =>
      'Set GOOGLE_CLIENT_ID for the build (--dart-define).';

  @override
  String get authErrorTelegramBot =>
      'Set TELEGRAM_BOT_USERNAME (--dart-define).';

  @override
  String get authErrorNoIdToken =>
      'Google did not return id_token (check Web meta / client ID).';

  @override
  String get authBarrierDismiss => 'Close';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String errorSemanticsLabel(String message) {
    return 'Error. $message';
  }

  @override
  String get errorRetry => 'Retry';

  @override
  String get errorTestNetwork => 'Network unavailable';
}
