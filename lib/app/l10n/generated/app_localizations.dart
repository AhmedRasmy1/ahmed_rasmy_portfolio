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
  /// **'Ahmed Hisham Rasmy'**
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
  /// **'FLUTTER DEV · MOBILE & WEB · 2+ YRS SHIPPING APPS'**
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
  /// **'Flutter Developer · GatherUp'**
  String get whoItem1;

  /// No description provided for @whoItem2.
  ///
  /// In en, this message translates to:
  /// **'Clean Architecture · BLoC / Provider'**
  String get whoItem2;

  /// No description provided for @whoItem3.
  ///
  /// In en, this message translates to:
  /// **'Mobile · Web · Desktop'**
  String get whoItem3;

  /// No description provided for @whoItem4.
  ///
  /// In en, this message translates to:
  /// **'Cairo, Egypt · Open to remote'**
  String get whoItem4;

  /// No description provided for @whoItem5.
  ///
  /// In en, this message translates to:
  /// **'Arabic / English'**
  String get whoItem5;

  /// No description provided for @estBadge.
  ///
  /// In en, this message translates to:
  /// **'EST. 2024 · FLUTTER'**
  String get estBadge;

  /// No description provided for @statCardLabel.
  ///
  /// In en, this message translates to:
  /// **'APPS SHIPPED'**
  String get statCardLabel;

  /// No description provided for @statCardSub.
  ///
  /// In en, this message translates to:
  /// **'+ SERVICEX'**
  String get statCardSub;

  /// No description provided for @flagshipLabel.
  ///
  /// In en, this message translates to:
  /// **'LIVE ON'**
  String get flagshipLabel;

  /// No description provided for @flagshipValue.
  ///
  /// In en, this message translates to:
  /// **'GOOGLE PLAY'**
  String get flagshipValue;

  /// No description provided for @teachNote.
  ///
  /// In en, this message translates to:
  /// **'OPEN TO WORK'**
  String get teachNote;

  /// No description provided for @chipGatherUp.
  ///
  /// In en, this message translates to:
  /// **'GATHERUP'**
  String get chipGatherUp;

  /// No description provided for @chipAwwaab.
  ///
  /// In en, this message translates to:
  /// **'AWWAAB'**
  String get chipAwwaab;

  /// No description provided for @chipElmohandes.
  ///
  /// In en, this message translates to:
  /// **'ELMOHANDES'**
  String get chipElmohandes;

  /// No description provided for @chipFlowery.
  ///
  /// In en, this message translates to:
  /// **'FLOWERY'**
  String get chipFlowery;

  /// No description provided for @chipServiceX.
  ///
  /// In en, this message translates to:
  /// **'SERVICEX'**
  String get chipServiceX;

  /// No description provided for @footerMarquee.
  ///
  /// In en, this message translates to:
  /// **'CLEAN ARCHITECTURE · BLOC · FIREBASE · REST APIS · PIXEL-PERFECT UI'**
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

  /// No description provided for @navWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get navWork;

  /// No description provided for @navAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// No description provided for @navExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get navExperience;

  /// No description provided for @navSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get navSkills;

  /// No description provided for @navResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get navResume;

  /// No description provided for @navContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get navContact;

  /// No description provided for @secWorkEyebrow.
  ///
  /// In en, this message translates to:
  /// **'SELECTED WORK'**
  String get secWorkEyebrow;

  /// No description provided for @secWorkTitle.
  ///
  /// In en, this message translates to:
  /// **'Projects that shipped'**
  String get secWorkTitle;

  /// No description provided for @secWorkIntro.
  ///
  /// In en, this message translates to:
  /// **'Product work across events, faith, commerce, and services — Clean Architecture first.'**
  String get secWorkIntro;

  /// No description provided for @secAboutEyebrow.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get secAboutEyebrow;

  /// No description provided for @secAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'A bit about me'**
  String get secAboutTitle;

  /// No description provided for @secAboutIntro.
  ///
  /// In en, this message translates to:
  /// **'Flutter developer in Cairo — building mobile, web, and desktop with care.'**
  String get secAboutIntro;

  /// No description provided for @secExperienceEyebrow.
  ///
  /// In en, this message translates to:
  /// **'EXPERIENCE'**
  String get secExperienceEyebrow;

  /// No description provided for @secExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'Where I’ve shipped'**
  String get secExperienceTitle;

  /// No description provided for @secExperienceIntro.
  ///
  /// In en, this message translates to:
  /// **'From internships to junior roles — Agile teams, Clean Architecture, and real products.'**
  String get secExperienceIntro;

  /// No description provided for @secSkillsEyebrow.
  ///
  /// In en, this message translates to:
  /// **'SKILLS'**
  String get secSkillsEyebrow;

  /// No description provided for @secSkillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Toolkit'**
  String get secSkillsTitle;

  /// No description provided for @secSkillsIntro.
  ///
  /// In en, this message translates to:
  /// **'Flutter core, APIs, storage, UI craft, testing, and AI-assisted workflows.'**
  String get secSkillsIntro;

  /// No description provided for @secEducationEyebrow.
  ///
  /// In en, this message translates to:
  /// **'EDUCATION & COURSES'**
  String get secEducationEyebrow;

  /// No description provided for @secEducationTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning path'**
  String get secEducationTitle;

  /// No description provided for @secEducationIntro.
  ///
  /// In en, this message translates to:
  /// **'Degree, internships, and focused Flutter tracks.'**
  String get secEducationIntro;

  /// No description provided for @secContactEyebrow.
  ///
  /// In en, this message translates to:
  /// **'CONTACT'**
  String get secContactEyebrow;

  /// No description provided for @secContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Let’s talk'**
  String get secContactTitle;

  /// No description provided for @secContactIntro.
  ///
  /// In en, this message translates to:
  /// **'Open to roles and collaborations — reach out anytime.'**
  String get secContactIntro;

  /// No description provided for @sectionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Content landing in the next step.'**
  String get sectionPlaceholder;

  /// No description provided for @linkLinkedIn.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get linkLinkedIn;

  /// No description provided for @linkGitHub.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get linkGitHub;

  /// No description provided for @eduDegree.
  ///
  /// In en, this message translates to:
  /// **'Bachelor of Information Technology'**
  String get eduDegree;

  /// No description provided for @eduSchool.
  ///
  /// In en, this message translates to:
  /// **'Minya University'**
  String get eduSchool;

  /// No description provided for @eduGrade.
  ///
  /// In en, this message translates to:
  /// **'Very Good with Honors'**
  String get eduGrade;

  /// No description provided for @eduProject.
  ///
  /// In en, this message translates to:
  /// **'ServiceX — Home Repair Services Platform (2025)'**
  String get eduProject;

  /// No description provided for @expGatherUpRole.
  ///
  /// In en, this message translates to:
  /// **'Junior Flutter Developer'**
  String get expGatherUpRole;

  /// No description provided for @expGatherUpCompany.
  ///
  /// In en, this message translates to:
  /// **'GatherUp'**
  String get expGatherUpCompany;

  /// No description provided for @expGatherUpB1.
  ///
  /// In en, this message translates to:
  /// **'Event booking, authentication, and JWT authorization'**
  String get expGatherUpB1;

  /// No description provided for @expGatherUpB2.
  ///
  /// In en, this message translates to:
  /// **'REST API integration, local caching, Clean Architecture'**
  String get expGatherUpB2;

  /// No description provided for @expGatherUpB3.
  ///
  /// In en, this message translates to:
  /// **'Google Maps integration and Firebase push notifications (FCM)'**
  String get expGatherUpB3;

  /// No description provided for @expGatherUpB4.
  ///
  /// In en, this message translates to:
  /// **'Real-time chat and responsive cross-platform UI'**
  String get expGatherUpB4;

  /// No description provided for @expCenterlyRole.
  ///
  /// In en, this message translates to:
  /// **'Intern Flutter Developer'**
  String get expCenterlyRole;

  /// No description provided for @expCenterlyCompany.
  ///
  /// In en, this message translates to:
  /// **'Centerly'**
  String get expCenterlyCompany;

  /// No description provided for @expCenterlyB1.
  ///
  /// In en, this message translates to:
  /// **'Worked in a cross-functional Agile team'**
  String get expCenterlyB1;

  /// No description provided for @expCenterlyB2.
  ///
  /// In en, this message translates to:
  /// **'Applied Clean Architecture with BLoC/Cubit and MVVM'**
  String get expCenterlyB2;

  /// No description provided for @expCenterlyB3.
  ///
  /// In en, this message translates to:
  /// **'Delivered scalable, maintainable, responsive mobile features'**
  String get expCenterlyB3;

  /// No description provided for @expElevateRole.
  ///
  /// In en, this message translates to:
  /// **'Intern Flutter Developer'**
  String get expElevateRole;

  /// No description provided for @expElevateCompany.
  ///
  /// In en, this message translates to:
  /// **'Elevate'**
  String get expElevateCompany;

  /// No description provided for @expElevateB1.
  ///
  /// In en, this message translates to:
  /// **'Built Flutter features with Clean Architecture, BLoC/Cubit, MVVM in an Agile environment'**
  String get expElevateB1;

  /// No description provided for @expElevateB2.
  ///
  /// In en, this message translates to:
  /// **'Integrated REST APIs with Dio and Retrofit; Firebase Auth, Firestore, FCM'**
  String get expElevateB2;

  /// No description provided for @expElevateB3.
  ///
  /// In en, this message translates to:
  /// **'Used Git/GitHub and Jira, took part in code reviews, improved code quality and architecture'**
  String get expElevateB3;

  /// No description provided for @projGatherUpTitle.
  ///
  /// In en, this message translates to:
  /// **'GatherUp'**
  String get projGatherUpTitle;

  /// No description provided for @projGatherUpTagline.
  ///
  /// In en, this message translates to:
  /// **'Social Events & Booking Platform'**
  String get projGatherUpTagline;

  /// No description provided for @projGatherUpSummary.
  ///
  /// In en, this message translates to:
  /// **'Discover, join, and manage local events with booking, maps, real-time chat, FCM, REST APIs, JWT auth, local caching, and Clean Architecture with Provider.'**
  String get projGatherUpSummary;

  /// No description provided for @projAwwaabTitle.
  ///
  /// In en, this message translates to:
  /// **'Awwaab'**
  String get projAwwaabTitle;

  /// No description provided for @projAwwaabTagline.
  ///
  /// In en, this message translates to:
  /// **'Islamic Lifestyle & Quran App'**
  String get projAwwaabTagline;

  /// No description provided for @projAwwaabSummary.
  ///
  /// In en, this message translates to:
  /// **'Prayer times, Quran, and lifestyle services with geolocation, WorkManager, and local notifications. Clean Architecture with BLoC. Live on Google Play.'**
  String get projAwwaabSummary;

  /// No description provided for @projElmohandesTitle.
  ///
  /// In en, this message translates to:
  /// **'Elmohandes'**
  String get projElmohandesTitle;

  /// No description provided for @projElmohandesTagline.
  ///
  /// In en, this message translates to:
  /// **'Invoice & Sales Management'**
  String get projElmohandesTagline;

  /// No description provided for @projElmohandesSummary.
  ///
  /// In en, this message translates to:
  /// **'Freelance invoicing app for Android and Desktop — products, PDF generation, sales analytics, secure auth, and responsive UI. Clean Architecture, BLoC, Dio/Retrofit.'**
  String get projElmohandesSummary;

  /// No description provided for @projFloweryTitle.
  ///
  /// In en, this message translates to:
  /// **'Flowery'**
  String get projFloweryTitle;

  /// No description provided for @projFloweryTagline.
  ///
  /// In en, this message translates to:
  /// **'E-Commerce Flower App'**
  String get projFloweryTagline;

  /// No description provided for @projFlowerySummary.
  ///
  /// In en, this message translates to:
  /// **'Browse, order, and track flower purchases with auth, cart, order management, and REST APIs. Clean Architecture, BLoC, Dio.'**
  String get projFlowerySummary;

  /// No description provided for @projServiceXTitle.
  ///
  /// In en, this message translates to:
  /// **'ServiceX'**
  String get projServiceXTitle;

  /// No description provided for @projServiceXTagline.
  ///
  /// In en, this message translates to:
  /// **'Home Repair Services Platform'**
  String get projServiceXTagline;

  /// No description provided for @projServiceXSummary.
  ///
  /// In en, this message translates to:
  /// **'Graduation project (2025) — mobile home-repair services platform.'**
  String get projServiceXSummary;

  /// No description provided for @skillCoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Core Flutter'**
  String get skillCoreTitle;

  /// No description provided for @skillApiTitle.
  ///
  /// In en, this message translates to:
  /// **'APIs & Backend'**
  String get skillApiTitle;

  /// No description provided for @skillStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Storage & Data'**
  String get skillStorageTitle;

  /// No description provided for @skillUiTitle.
  ///
  /// In en, this message translates to:
  /// **'UI / UX'**
  String get skillUiTitle;

  /// No description provided for @skillQaTitle.
  ///
  /// In en, this message translates to:
  /// **'Testing & DevOps'**
  String get skillQaTitle;

  /// No description provided for @skillAiTitle.
  ///
  /// In en, this message translates to:
  /// **'AI & Tooling'**
  String get skillAiTitle;

  /// No description provided for @courseIti.
  ///
  /// In en, this message translates to:
  /// **'UI/UX (Front-end) Developer Track'**
  String get courseIti;

  /// No description provided for @courseItiOrg.
  ///
  /// In en, this message translates to:
  /// **'ITI Tech-Leaps'**
  String get courseItiOrg;

  /// No description provided for @courseElevate.
  ///
  /// In en, this message translates to:
  /// **'Flutter Developer Internship'**
  String get courseElevate;

  /// No description provided for @courseElevateOrg.
  ///
  /// In en, this message translates to:
  /// **'ELEVATE'**
  String get courseElevateOrg;

  /// No description provided for @courseUdemy.
  ///
  /// In en, this message translates to:
  /// **'Professional Flutter Development (7 courses: MVVM, BLoC, Clean Architecture, responsive design, full-stack Dart)'**
  String get courseUdemy;

  /// No description provided for @courseUdemyOrg.
  ///
  /// In en, this message translates to:
  /// **'Udemy'**
  String get courseUdemyOrg;

  /// No description provided for @coursePayments.
  ///
  /// In en, this message translates to:
  /// **'Advanced feature integration (Google Maps, Stripe, PayPal)'**
  String get coursePayments;

  /// No description provided for @courseCenterly.
  ///
  /// In en, this message translates to:
  /// **'Flutter Developer Internship'**
  String get courseCenterly;

  /// No description provided for @courseCenterlyOrg.
  ///
  /// In en, this message translates to:
  /// **'CENTERLY'**
  String get courseCenterlyOrg;

  /// No description provided for @caseGatherUpOverview.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpOverview;

  /// No description provided for @caseGatherUpProblem.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpProblem;

  /// No description provided for @caseGatherUpSolution.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpSolution;

  /// No description provided for @caseGatherUpO1.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpO1;

  /// No description provided for @caseGatherUpO2.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpO2;

  /// No description provided for @langArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic (Native)'**
  String get langArabic;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English (Professional)'**
  String get langEnglish;
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
