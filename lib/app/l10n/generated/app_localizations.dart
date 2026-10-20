import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Rasmy'**
  String get appTitle;

  /// No description provided for @issueNo.
  ///
  /// In en, this message translates to:
  /// **'ISSUE NO. 01'**
  String get issueNo;

  /// No description provided for @personalEdition.
  ///
  /// In en, this message translates to:
  /// **'PERSONAL EDITION'**
  String get personalEdition;

  /// No description provided for @locationMeta.
  ///
  /// In en, this message translates to:
  /// **'CAIRO · REMOTE'**
  String get locationMeta;

  /// No description provided for @estYear.
  ///
  /// In en, this message translates to:
  /// **'EST. 2026'**
  String get estYear;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'DARK'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'LIGHT'**
  String get themeLight;

  /// No description provided for @langEn.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get langEn;

  /// No description provided for @langAr.
  ///
  /// In en, this message translates to:
  /// **'ع'**
  String get langAr;

  /// No description provided for @headlinePrimary.
  ///
  /// In en, this message translates to:
  /// **'FLUTTER'**
  String get headlinePrimary;

  /// No description provided for @headlineScript.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get headlineScript;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'AHMED'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'RASMY'**
  String get lastName;

  /// No description provided for @metaTagline.
  ///
  /// In en, this message translates to:
  /// **'FLUTTER DEV · MOBILE & WEB · 5 YRS SHIPPING APPS'**
  String get metaTagline;

  /// No description provided for @redTagline.
  ///
  /// In en, this message translates to:
  /// **'Design · Build · Ship'**
  String get redTagline;

  /// No description provided for @whoIAmTitle.
  ///
  /// In en, this message translates to:
  /// **'WHO I AM'**
  String get whoIAmTitle;

  /// No description provided for @whoItem1.
  ///
  /// In en, this message translates to:
  /// **'Flutter Developer · Mobile & Web'**
  String get whoItem1;

  /// No description provided for @whoItem2.
  ///
  /// In en, this message translates to:
  /// **'Clean Architecture · Bloc / Riverpod'**
  String get whoItem2;

  /// No description provided for @whoItem3.
  ///
  /// In en, this message translates to:
  /// **'5 yrs building iOS / Android / Web apps'**
  String get whoItem3;

  /// No description provided for @whoItem4.
  ///
  /// In en, this message translates to:
  /// **'Cairo, Egypt · Remote'**
  String get whoItem4;

  /// No description provided for @whoItem5.
  ///
  /// In en, this message translates to:
  /// **'Bilingual EN / AR'**
  String get whoItem5;

  /// No description provided for @estBadge.
  ///
  /// In en, this message translates to:
  /// **'EST. 2021 · FLUTTER'**
  String get estBadge;

  /// No description provided for @statCardLabel.
  ///
  /// In en, this message translates to:
  /// **'SHIPPED APPS'**
  String get statCardLabel;

  /// No description provided for @statCardValue.
  ///
  /// In en, this message translates to:
  /// **'100K+'**
  String get statCardValue;

  /// No description provided for @statCardSub.
  ///
  /// In en, this message translates to:
  /// **'DOWNLOADS ↑'**
  String get statCardSub;

  /// No description provided for @flagshipLabel.
  ///
  /// In en, this message translates to:
  /// **'FLAGSHIP APP'**
  String get flagshipLabel;

  /// No description provided for @flagshipValue.
  ///
  /// In en, this message translates to:
  /// **'MULTI-PLATFORM'**
  String get flagshipValue;

  /// No description provided for @teachNote.
  ///
  /// In en, this message translates to:
  /// **'I ALSO TEACH + CREATE'**
  String get teachNote;

  /// No description provided for @chip1.
  ///
  /// In en, this message translates to:
  /// **'PORTFOLIO WEB'**
  String get chip1;

  /// No description provided for @chip2.
  ///
  /// In en, this message translates to:
  /// **'E-COMMERCE APP'**
  String get chip2;

  /// No description provided for @chip3.
  ///
  /// In en, this message translates to:
  /// **'FINTECH WALLET'**
  String get chip3;

  /// No description provided for @chip4.
  ///
  /// In en, this message translates to:
  /// **'HEALTH TRACKER'**
  String get chip4;

  /// No description provided for @chip5.
  ///
  /// In en, this message translates to:
  /// **'REALTIME CHAT'**
  String get chip5;

  /// No description provided for @footerMarquee.
  ///
  /// In en, this message translates to:
  /// **'TURNING IDEAS INTO APPS · PIXELS INTO EXPERIENCES · CODE INTO PRODUCTS'**
  String get footerMarquee;

  /// No description provided for @scrollHint.
  ///
  /// In en, this message translates to:
  /// **'SCROLL TO VIEW'**
  String get scrollHint;

  /// No description provided for @scrollHintMobile.
  ///
  /// In en, this message translates to:
  /// **'SWIPE UP'**
  String get scrollHintMobile;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
