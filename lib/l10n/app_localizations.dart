import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Zhuchka Market'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get navCatalog;

  /// No description provided for @navCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navCart;

  /// No description provided for @navHomeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Storefront home'**
  String get navHomeTooltip;

  /// No description provided for @navCatalogTooltip.
  ///
  /// In en, this message translates to:
  /// **'Product catalog'**
  String get navCatalogTooltip;

  /// No description provided for @navCartTooltip.
  ///
  /// In en, this message translates to:
  /// **'Shopping cart'**
  String get navCartTooltip;

  /// No description provided for @loadingSession.
  ///
  /// In en, this message translates to:
  /// **'Loading session…'**
  String get loadingSession;

  /// No description provided for @loadingDefaultSemantics.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loadingDefaultSemantics;

  /// No description provided for @storefrontHeadline.
  ///
  /// In en, this message translates to:
  /// **'Storefront for shoppers'**
  String get storefrontHeadline;

  /// No description provided for @storefrontHintLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Session: tokens in local storage; profile from auth (userinfo).'**
  String get storefrontHintLoggedIn;

  /// No description provided for @storefrontHintGuest.
  ///
  /// In en, this message translates to:
  /// **'Tap Sign in — modal dialog. Google and Telegram when auth is configured.'**
  String get storefrontHintGuest;

  /// No description provided for @storefrontLoginCta.
  ///
  /// In en, this message translates to:
  /// **'Sign in or register'**
  String get storefrontLoginCta;

  /// No description provided for @actionSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get actionSignIn;

  /// No description provided for @actionSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get actionSignOut;

  /// No description provided for @snackSignedOut.
  ///
  /// In en, this message translates to:
  /// **'You have signed out'**
  String get snackSignedOut;

  /// No description provided for @snackSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get snackSignedIn;

  /// No description provided for @catalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get catalogTitle;

  /// No description provided for @catalogEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Catalog coming soon'**
  String get catalogEmptyTitle;

  /// No description provided for @catalogEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'This section is a placeholder until the catalog API is connected (see issue #7).'**
  String get catalogEmptyBody;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartTitle;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your items will appear after commerce backend integration (issue #7).'**
  String get cartEmptyBody;

  /// No description provided for @catalogAwaitingApiTitle.
  ///
  /// In en, this message translates to:
  /// **'Catalog service is up'**
  String get catalogAwaitingApiTitle;

  /// No description provided for @catalogAwaitingApiBody.
  ///
  /// In en, this message translates to:
  /// **'Storefront product list is not wired yet. Products will appear here when GET /api/v1/products exists on the catalog service.'**
  String get catalogAwaitingApiBody;

  /// No description provided for @cartAwaitingApiTitle.
  ///
  /// In en, this message translates to:
  /// **'Commerce service is up'**
  String get cartAwaitingApiTitle;

  /// No description provided for @cartAwaitingApiBody.
  ///
  /// In en, this message translates to:
  /// **'Storefront cart API is not wired yet. Your cart will appear when the commerce service exposes cart endpoints.'**
  String get cartAwaitingApiBody;

  /// No description provided for @authTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authTitle;

  /// No description provided for @authSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google or Telegram. Server: Zhuchka Auth (federated).'**
  String get authSubtitle;

  /// No description provided for @authContinueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueGoogle;

  /// No description provided for @authContinueTelegram.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Telegram'**
  String get authContinueTelegram;

  /// No description provided for @authClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get authClose;

  /// No description provided for @authBusySemantics.
  ///
  /// In en, this message translates to:
  /// **'Signing in'**
  String get authBusySemantics;

  /// No description provided for @authErrorGoogleClientId.
  ///
  /// In en, this message translates to:
  /// **'Set GOOGLE_CLIENT_ID for the build (--dart-define).'**
  String get authErrorGoogleClientId;

  /// No description provided for @authErrorTelegramBot.
  ///
  /// In en, this message translates to:
  /// **'Set TELEGRAM_BOT_USERNAME (--dart-define).'**
  String get authErrorTelegramBot;

  /// No description provided for @authErrorNoIdToken.
  ///
  /// In en, this message translates to:
  /// **'Google did not return id_token (check Web meta / client ID).'**
  String get authErrorNoIdToken;

  /// No description provided for @authBarrierDismiss.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get authBarrierDismiss;

  /// No description provided for @errorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGenericTitle;

  /// No description provided for @errorSemanticsLabel.
  ///
  /// In en, this message translates to:
  /// **'Error. {message}'**
  String errorSemanticsLabel(String message);

  /// No description provided for @errorRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get errorRetry;

  /// No description provided for @errorTestNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network unavailable'**
  String get errorTestNetwork;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
