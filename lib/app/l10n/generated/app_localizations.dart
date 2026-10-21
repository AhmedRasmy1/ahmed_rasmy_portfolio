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
  /// **'Case studies & apps'**
  String get secWorkTitle;

  /// No description provided for @secWorkIntro.
  ///
  /// In en, this message translates to:
  /// **'Apps I built and shipped, with Clean Architecture under the hood.'**
  String get secWorkIntro;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get filterMobile;

  /// No description provided for @filterWeb.
  ///
  /// In en, this message translates to:
  /// **'Web'**
  String get filterWeb;

  /// No description provided for @filterDesktop.
  ///
  /// In en, this message translates to:
  /// **'Desktop'**
  String get filterDesktop;

  /// No description provided for @readCaseStudy.
  ///
  /// In en, this message translates to:
  /// **'READ CASE STUDY →'**
  String get readCaseStudy;

  /// No description provided for @linkPlayStore.
  ///
  /// In en, this message translates to:
  /// **'Play Store'**
  String get linkPlayStore;

  /// No description provided for @linkWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get linkWebsite;

  /// No description provided for @platformAndroid.
  ///
  /// In en, this message translates to:
  /// **'Android'**
  String get platformAndroid;

  /// No description provided for @platformIos.
  ///
  /// In en, this message translates to:
  /// **'iOS'**
  String get platformIos;

  /// No description provided for @platformDesktop.
  ///
  /// In en, this message translates to:
  /// **'Desktop'**
  String get platformDesktop;

  /// No description provided for @platformWeb.
  ///
  /// In en, this message translates to:
  /// **'Web'**
  String get platformWeb;

  /// No description provided for @platformMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get platformMobile;

  /// No description provided for @secAboutEyebrow.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get secAboutEyebrow;

  /// No description provided for @secAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'Building apps that feel fast and look right.'**
  String get secAboutTitle;

  /// No description provided for @secAboutIntro.
  ///
  /// In en, this message translates to:
  /// **'Flutter developer in Cairo — Clean Architecture, real products, careful craft.'**
  String get secAboutIntro;

  /// No description provided for @aboutP1.
  ///
  /// In en, this message translates to:
  /// **'I’m a Flutter developer who ships mobile, web, and desktop apps with Clean Architecture, BLoC, REST APIs, Firebase, Google Maps, and real-time chat — work that feels fast and looks right.'**
  String get aboutP1;

  /// No description provided for @aboutP2.
  ///
  /// In en, this message translates to:
  /// **'I started with internships at Elevate and Centerly, and I’m now building at GatherUp. I studied Information Technology at Minya University (Very Good with Honors). I use AI tools like Cursor and Claude to move faster — and I review everything myself.'**
  String get aboutP2;

  /// No description provided for @aboutCaptionWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get aboutCaptionWorkspace;

  /// No description provided for @aboutCaptionAction.
  ///
  /// In en, this message translates to:
  /// **'In action'**
  String get aboutCaptionAction;

  /// No description provided for @aboutCaptionCraft.
  ///
  /// In en, this message translates to:
  /// **'Craft'**
  String get aboutCaptionCraft;

  /// No description provided for @aboutCaptionStudio.
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get aboutCaptionStudio;

  /// No description provided for @aboutFactCairo.
  ///
  /// In en, this message translates to:
  /// **'CAIRO, EGYPT'**
  String get aboutFactCairo;

  /// No description provided for @aboutFactLang.
  ///
  /// In en, this message translates to:
  /// **'AR / EN'**
  String get aboutFactLang;

  /// No description provided for @aboutFactOpen.
  ///
  /// In en, this message translates to:
  /// **'OPEN TO WORK'**
  String get aboutFactOpen;

  /// No description provided for @secExperienceEyebrow.
  ///
  /// In en, this message translates to:
  /// **'EXPERIENCE'**
  String get secExperienceEyebrow;

  /// No description provided for @secExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'Where I’ve been'**
  String get secExperienceTitle;

  /// No description provided for @secExperienceIntro.
  ///
  /// In en, this message translates to:
  /// **'From internships to junior roles — Agile teams, Clean Architecture, and real products.'**
  String get secExperienceIntro;

  /// No description provided for @expNow.
  ///
  /// In en, this message translates to:
  /// **'NOW'**
  String get expNow;

  /// No description provided for @expPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get expPresent;

  /// No description provided for @secSkillsEyebrow.
  ///
  /// In en, this message translates to:
  /// **'SKILLS'**
  String get secSkillsEyebrow;

  /// No description provided for @secSkillsTitle.
  ///
  /// In en, this message translates to:
  /// **'The toolbox.'**
  String get secSkillsTitle;

  /// No description provided for @secSkillsIntro.
  ///
  /// In en, this message translates to:
  /// **'Flutter core, APIs, storage, UI craft, testing, and AI-assisted workflows.'**
  String get secSkillsIntro;

  /// No description provided for @secEducationEyebrow.
  ///
  /// In en, this message translates to:
  /// **'EDUCATION'**
  String get secEducationEyebrow;

  /// No description provided for @secEducationTitle.
  ///
  /// In en, this message translates to:
  /// **'Degree & certificates.'**
  String get secEducationTitle;

  /// No description provided for @secEducationIntro.
  ///
  /// In en, this message translates to:
  /// **'University diploma and focused Flutter tracks.'**
  String get secEducationIntro;

  /// No description provided for @eduYearsLabel.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get eduYearsLabel;

  /// No description provided for @eduGradeLabel.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get eduGradeLabel;

  /// No description provided for @eduProjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Graduation project'**
  String get eduProjectLabel;

  /// No description provided for @eduCertificateStamp.
  ///
  /// In en, this message translates to:
  /// **'CERTIFICATE'**
  String get eduCertificateStamp;

  /// No description provided for @eduViewCert.
  ///
  /// In en, this message translates to:
  /// **'View certificate →'**
  String get eduViewCert;

  /// No description provided for @secContactEyebrow.
  ///
  /// In en, this message translates to:
  /// **'CONTACT'**
  String get secContactEyebrow;

  /// No description provided for @secContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Let’s build something together.'**
  String get secContactTitle;

  /// No description provided for @secContactIntro.
  ///
  /// In en, this message translates to:
  /// **'Open to Flutter roles, remote or in Cairo, and freelance projects.'**
  String get secContactIntro;

  /// No description provided for @contactSayHi.
  ///
  /// In en, this message translates to:
  /// **'SAY HI 👋'**
  String get contactSayHi;

  /// No description provided for @contactEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactEmail;

  /// No description provided for @contactPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get contactPhone;

  /// No description provided for @contactCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get contactCopied;

  /// No description provided for @contactPostcardTo.
  ///
  /// In en, this message translates to:
  /// **'TO'**
  String get contactPostcardTo;

  /// No description provided for @contactPostcardFrom.
  ///
  /// In en, this message translates to:
  /// **'FROM THE DESK OF'**
  String get contactPostcardFrom;

  /// No description provided for @footerCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Ahmed Hisham Rasmy'**
  String get footerCopyright;

  /// No description provided for @footerBackToTop.
  ///
  /// In en, this message translates to:
  /// **'BACK TO TOP'**
  String get footerBackToTop;

  /// No description provided for @resumeDownload.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get resumeDownload;

  /// No description provided for @resumeSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'CV summary'**
  String get resumeSummaryTitle;

  /// No description provided for @resumeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Flutter Developer'**
  String get resumeHeadline;

  /// No description provided for @resumeIntro.
  ///
  /// In en, this message translates to:
  /// **'Clean Architecture, BLoC, REST, Firebase — shipping mobile, web, and desktop from Cairo.'**
  String get resumeIntro;

  /// No description provided for @resumeExperienceHeading.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get resumeExperienceHeading;

  /// No description provided for @resumeEducationHeading.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get resumeEducationHeading;

  /// No description provided for @resumeSkillsHeading.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get resumeSkillsHeading;

  /// No description provided for @resumeProjectsHeading.
  ///
  /// In en, this message translates to:
  /// **'Selected work'**
  String get resumeProjectsHeading;

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

  /// No description provided for @caseBackToPortfolio.
  ///
  /// In en, this message translates to:
  /// **'← Back to Portfolio'**
  String get caseBackToPortfolio;

  /// No description provided for @caseStudyLabel.
  ///
  /// In en, this message translates to:
  /// **'CASE STUDY'**
  String get caseStudyLabel;

  /// No description provided for @caseMetaMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get caseMetaMarket;

  /// No description provided for @caseMetaPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get caseMetaPlatform;

  /// No description provided for @caseMetaLocale.
  ///
  /// In en, this message translates to:
  /// **'Locale'**
  String get caseMetaLocale;

  /// No description provided for @caseMetaStack.
  ///
  /// In en, this message translates to:
  /// **'Stack'**
  String get caseMetaStack;

  /// No description provided for @caseNavProblem.
  ///
  /// In en, this message translates to:
  /// **'Problem'**
  String get caseNavProblem;

  /// No description provided for @caseNavProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get caseNavProduct;

  /// No description provided for @caseNavThinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking'**
  String get caseNavThinking;

  /// No description provided for @caseNavExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get caseNavExperience;

  /// No description provided for @caseNavSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get caseNavSystem;

  /// No description provided for @caseNavMotion.
  ///
  /// In en, this message translates to:
  /// **'Motion'**
  String get caseNavMotion;

  /// No description provided for @caseNavCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get caseNavCode;

  /// No description provided for @caseNavIteration.
  ///
  /// In en, this message translates to:
  /// **'Iteration'**
  String get caseNavIteration;

  /// No description provided for @caseNavComingNext.
  ///
  /// In en, this message translates to:
  /// **'Coming Next'**
  String get caseNavComingNext;

  /// No description provided for @caseNavResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get caseNavResults;

  /// No description provided for @caseSecProduct.
  ///
  /// In en, this message translates to:
  /// **'PRODUCT'**
  String get caseSecProduct;

  /// No description provided for @caseSecProductTitle.
  ///
  /// In en, this message translates to:
  /// **'What GatherUp is'**
  String get caseSecProductTitle;

  /// No description provided for @caseSecProductIntro.
  ///
  /// In en, this message translates to:
  /// **'A social loop built around shared interests and local events.'**
  String get caseSecProductIntro;

  /// No description provided for @caseSecRole.
  ///
  /// In en, this message translates to:
  /// **'MY ROLE'**
  String get caseSecRole;

  /// No description provided for @caseSecRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'What I built'**
  String get caseSecRoleTitle;

  /// No description provided for @caseSecRoleIntro.
  ///
  /// In en, this message translates to:
  /// **'Flutter features shipped on the GatherUp mobile app.'**
  String get caseSecRoleIntro;

  /// No description provided for @caseSecArch.
  ///
  /// In en, this message translates to:
  /// **'ARCHITECTURE'**
  String get caseSecArch;

  /// No description provided for @caseSecArchTitle.
  ///
  /// In en, this message translates to:
  /// **'Clean Architecture under the hood'**
  String get caseSecArchTitle;

  /// No description provided for @caseSecArchIntro.
  ///
  /// In en, this message translates to:
  /// **'Presentation, Domain, and Data — held together with Provider and repositories.'**
  String get caseSecArchIntro;

  /// No description provided for @caseSecScreens.
  ///
  /// In en, this message translates to:
  /// **'EXPERIENCE'**
  String get caseSecScreens;

  /// No description provided for @caseSecScreensTitle.
  ///
  /// In en, this message translates to:
  /// **'Screens'**
  String get caseSecScreensTitle;

  /// No description provided for @caseSecScreensIntro.
  ///
  /// In en, this message translates to:
  /// **'Drag through the phone frames — placeholders until shots land.'**
  String get caseSecScreensIntro;

  /// No description provided for @caseSecChallenges.
  ///
  /// In en, this message translates to:
  /// **'CHALLENGES'**
  String get caseSecChallenges;

  /// No description provided for @caseSecChallengesTitle.
  ///
  /// In en, this message translates to:
  /// **'Problem → Solution → Learned'**
  String get caseSecChallengesTitle;

  /// No description provided for @caseSecChallengesIntro.
  ///
  /// In en, this message translates to:
  /// **'Real engineering friction from the GatherUp build.'**
  String get caseSecChallengesIntro;

  /// No description provided for @caseSecResults.
  ///
  /// In en, this message translates to:
  /// **'RESULTS'**
  String get caseSecResults;

  /// No description provided for @caseSecResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Impact'**
  String get caseSecResultsTitle;

  /// No description provided for @caseSecResultsIntro.
  ///
  /// In en, this message translates to:
  /// **'Numbers go here when they’re real.'**
  String get caseSecResultsIntro;

  /// No description provided for @caseSecLearn.
  ///
  /// In en, this message translates to:
  /// **'WHAT I LEARNED'**
  String get caseSecLearn;

  /// No description provided for @caseSecLearnTitle.
  ///
  /// In en, this message translates to:
  /// **'Takeaways'**
  String get caseSecLearnTitle;

  /// No description provided for @caseSecLearnIntro.
  ///
  /// In en, this message translates to:
  /// **'Short notes from shipping GatherUp.'**
  String get caseSecLearnIntro;

  /// No description provided for @caseChallengeProblem.
  ///
  /// In en, this message translates to:
  /// **'Problem'**
  String get caseChallengeProblem;

  /// No description provided for @caseChallengeSolution.
  ///
  /// In en, this message translates to:
  /// **'Solution'**
  String get caseChallengeSolution;

  /// No description provided for @caseChallengeLearned.
  ///
  /// In en, this message translates to:
  /// **'Learned'**
  String get caseChallengeLearned;

  /// No description provided for @caseNextLabel.
  ///
  /// In en, this message translates to:
  /// **'Next case study'**
  String get caseNextLabel;

  /// No description provided for @caseAllStudies.
  ///
  /// In en, this message translates to:
  /// **'← All case studies'**
  String get caseAllStudies;

  /// No description provided for @caseComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Case study coming soon.'**
  String get caseComingSoon;

  /// No description provided for @caseArchPresentation.
  ///
  /// In en, this message translates to:
  /// **'Presentation'**
  String get caseArchPresentation;

  /// No description provided for @caseArchDomain.
  ///
  /// In en, this message translates to:
  /// **'Domain'**
  String get caseArchDomain;

  /// No description provided for @caseArchData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get caseArchData;

  /// No description provided for @caseArchProvider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get caseArchProvider;

  /// No description provided for @caseArchRepo.
  ///
  /// In en, this message translates to:
  /// **'Repository'**
  String get caseArchRepo;

  /// No description provided for @caseArchRemote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get caseArchRemote;

  /// No description provided for @caseArchLocal.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get caseArchLocal;

  /// No description provided for @caseGatherUpHeroTagline.
  ///
  /// In en, this message translates to:
  /// **'Meet through shared interests, not profiles.'**
  String get caseGatherUpHeroTagline;

  /// No description provided for @caseGatherUpBrush.
  ///
  /// In en, this message translates to:
  /// **'social'**
  String get caseGatherUpBrush;

  /// No description provided for @caseGatherUpCredit.
  ///
  /// In en, this message translates to:
  /// **'Product & design: TODO_NAMES. I built Flutter features for the mobile app.'**
  String get caseGatherUpCredit;

  /// No description provided for @caseGatherUpMarketMeta.
  ///
  /// In en, this message translates to:
  /// **'Social events · Local discovery'**
  String get caseGatherUpMarketMeta;

  /// No description provided for @caseGatherUpPlatformMeta.
  ///
  /// In en, this message translates to:
  /// **'iOS · Android · Web'**
  String get caseGatherUpPlatformMeta;

  /// No description provided for @caseGatherUpLocaleMeta.
  ///
  /// In en, this message translates to:
  /// **'EN + AR · RTL'**
  String get caseGatherUpLocaleMeta;

  /// No description provided for @caseGatherUpStackMeta.
  ///
  /// In en, this message translates to:
  /// **'Flutter · REST · Firebase · Google Maps'**
  String get caseGatherUpStackMeta;

  /// No description provided for @caseGatherUpProblemHeadline.
  ///
  /// In en, this message translates to:
  /// **'Meeting people shouldn\'t start with a profile.'**
  String get caseGatherUpProblemHeadline;

  /// No description provided for @caseGatherUpCompareTypicalTitle.
  ///
  /// In en, this message translates to:
  /// **'Typical social apps'**
  String get caseGatherUpCompareTypicalTitle;

  /// No description provided for @caseGatherUpCompareTypicalCaption.
  ///
  /// In en, this message translates to:
  /// **'Faces first. Plans optional.'**
  String get caseGatherUpCompareTypicalCaption;

  /// No description provided for @caseGatherUpCompareTypicalS1.
  ///
  /// In en, this message translates to:
  /// **'01 Profile'**
  String get caseGatherUpCompareTypicalS1;

  /// No description provided for @caseGatherUpCompareTypicalS2.
  ///
  /// In en, this message translates to:
  /// **'02 Swipe'**
  String get caseGatherUpCompareTypicalS2;

  /// No description provided for @caseGatherUpCompareTypicalS3.
  ///
  /// In en, this message translates to:
  /// **'03 Maybe meet'**
  String get caseGatherUpCompareTypicalS3;

  /// No description provided for @caseGatherUpCompareGuTitle.
  ///
  /// In en, this message translates to:
  /// **'GatherUp'**
  String get caseGatherUpCompareGuTitle;

  /// No description provided for @caseGatherUpCompareGuCaption.
  ///
  /// In en, this message translates to:
  /// **'Guest list private until after.'**
  String get caseGatherUpCompareGuCaption;

  /// No description provided for @caseGatherUpCompareGuS1.
  ///
  /// In en, this message translates to:
  /// **'01 Interest'**
  String get caseGatherUpCompareGuS1;

  /// No description provided for @caseGatherUpCompareGuS2.
  ///
  /// In en, this message translates to:
  /// **'02 Book'**
  String get caseGatherUpCompareGuS2;

  /// No description provided for @caseGatherUpCompareGuS3.
  ///
  /// In en, this message translates to:
  /// **'03 Meet'**
  String get caseGatherUpCompareGuS3;

  /// No description provided for @caseGatherUpCompareGuS4.
  ///
  /// In en, this message translates to:
  /// **'04 Faces unlock'**
  String get caseGatherUpCompareGuS4;

  /// No description provided for @caseGatherUpVs.
  ///
  /// In en, this message translates to:
  /// **'VS'**
  String get caseGatherUpVs;

  /// No description provided for @caseGatherUpStory1.
  ///
  /// In en, this message translates to:
  /// **'The Problem'**
  String get caseGatherUpStory1;

  /// No description provided for @caseGatherUpStory2.
  ///
  /// In en, this message translates to:
  /// **'The Struggle'**
  String get caseGatherUpStory2;

  /// No description provided for @caseGatherUpStory3.
  ///
  /// In en, this message translates to:
  /// **'The Turning Point'**
  String get caseGatherUpStory3;

  /// No description provided for @caseGatherUpStory4.
  ///
  /// In en, this message translates to:
  /// **'A Better Reality'**
  String get caseGatherUpStory4;

  /// No description provided for @caseGatherUpProductHeadline.
  ///
  /// In en, this message translates to:
  /// **'The loop.'**
  String get caseGatherUpProductHeadline;

  /// No description provided for @caseGatherUpLoopDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get caseGatherUpLoopDiscover;

  /// No description provided for @caseGatherUpLoopDiscoverD.
  ///
  /// In en, this message translates to:
  /// **'Activities near you this week.'**
  String get caseGatherUpLoopDiscoverD;

  /// No description provided for @caseGatherUpLoopJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get caseGatherUpLoopJoin;

  /// No description provided for @caseGatherUpLoopJoinD.
  ///
  /// In en, this message translates to:
  /// **'Book free or pay.'**
  String get caseGatherUpLoopJoinD;

  /// No description provided for @caseGatherUpLoopMeet.
  ///
  /// In en, this message translates to:
  /// **'Meet'**
  String get caseGatherUpLoopMeet;

  /// No description provided for @caseGatherUpLoopMeetD.
  ///
  /// In en, this message translates to:
  /// **'Small groups by default.'**
  String get caseGatherUpLoopMeetD;

  /// No description provided for @caseGatherUpLoopConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get caseGatherUpLoopConnect;

  /// No description provided for @caseGatherUpLoopConnectD.
  ///
  /// In en, this message translates to:
  /// **'Chat unlocks, faces after.'**
  String get caseGatherUpLoopConnectD;

  /// No description provided for @caseGatherUpThinkingHeadline.
  ///
  /// In en, this message translates to:
  /// **'Product questions came first.'**
  String get caseGatherUpThinkingHeadline;

  /// No description provided for @caseGatherUpQ1.
  ///
  /// In en, this message translates to:
  /// **'Who is this for?'**
  String get caseGatherUpQ1;

  /// No description provided for @caseGatherUpA1.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpA1;

  /// No description provided for @caseGatherUpQ2.
  ///
  /// In en, this message translates to:
  /// **'Why join?'**
  String get caseGatherUpQ2;

  /// No description provided for @caseGatherUpA2.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpA2;

  /// No description provided for @caseGatherUpQ3.
  ///
  /// In en, this message translates to:
  /// **'What lowers anxiety?'**
  String get caseGatherUpQ3;

  /// No description provided for @caseGatherUpA3.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpA3;

  /// No description provided for @caseGatherUpQ4.
  ///
  /// In en, this message translates to:
  /// **'What does a host need?'**
  String get caseGatherUpQ4;

  /// No description provided for @caseGatherUpA4.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpA4;

  /// No description provided for @caseGatherUpQ5.
  ///
  /// In en, this message translates to:
  /// **'What brings people back?'**
  String get caseGatherUpQ5;

  /// No description provided for @caseGatherUpA5.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpA5;

  /// No description provided for @caseGatherUpQ6.
  ///
  /// In en, this message translates to:
  /// **'How do they pay?'**
  String get caseGatherUpQ6;

  /// No description provided for @caseGatherUpA6.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpA6;

  /// No description provided for @caseSecProblem.
  ///
  /// In en, this message translates to:
  /// **'PROBLEM'**
  String get caseSecProblem;

  /// No description provided for @caseSecProductEyebrow.
  ///
  /// In en, this message translates to:
  /// **'PRODUCT'**
  String get caseSecProductEyebrow;

  /// No description provided for @caseSecThinking.
  ///
  /// In en, this message translates to:
  /// **'THINKING'**
  String get caseSecThinking;

  /// No description provided for @caseSecExperience.
  ///
  /// In en, this message translates to:
  /// **'EXPERIENCE'**
  String get caseSecExperience;

  /// No description provided for @caseSecSystem.
  ///
  /// In en, this message translates to:
  /// **'DESIGN SYSTEM'**
  String get caseSecSystem;

  /// No description provided for @caseSecMotion.
  ///
  /// In en, this message translates to:
  /// **'MOTION'**
  String get caseSecMotion;

  /// No description provided for @caseSecCode.
  ///
  /// In en, this message translates to:
  /// **'DESIGN + CODE'**
  String get caseSecCode;

  /// No description provided for @caseHoverToPlay.
  ///
  /// In en, this message translates to:
  /// **'HOVER TO PLAY'**
  String get caseHoverToPlay;

  /// No description provided for @caseTapToPlay.
  ///
  /// In en, this message translates to:
  /// **'TAP TO PLAY'**
  String get caseTapToPlay;

  /// No description provided for @caseGatherUpExpHeadline.
  ///
  /// In en, this message translates to:
  /// **'Making meeting strangers feel easy.'**
  String get caseGatherUpExpHeadline;

  /// No description provided for @caseGatherUpExpDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get caseGatherUpExpDiscover;

  /// No description provided for @caseGatherUpExpContext.
  ///
  /// In en, this message translates to:
  /// **'Context'**
  String get caseGatherUpExpContext;

  /// No description provided for @caseGatherUpExpBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get caseGatherUpExpBook;

  /// No description provided for @caseGatherUpExpConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get caseGatherUpExpConnect;

  /// No description provided for @caseGatherUpSysHeadline.
  ///
  /// In en, this message translates to:
  /// **'One system. Multiple surfaces.'**
  String get caseGatherUpSysHeadline;

  /// No description provided for @caseGatherUpSysCredit.
  ///
  /// In en, this message translates to:
  /// **'Design by TODO_NAMES · Implemented in Flutter by me'**
  String get caseGatherUpSysCredit;

  /// No description provided for @caseGatherUpTierPrimitives.
  ///
  /// In en, this message translates to:
  /// **'Primitives'**
  String get caseGatherUpTierPrimitives;

  /// No description provided for @caseGatherUpTierFoundations.
  ///
  /// In en, this message translates to:
  /// **'Foundations'**
  String get caseGatherUpTierFoundations;

  /// No description provided for @caseGatherUpTierCore.
  ///
  /// In en, this message translates to:
  /// **'Core components'**
  String get caseGatherUpTierCore;

  /// No description provided for @caseGatherUpTierSurfaces.
  ///
  /// In en, this message translates to:
  /// **'Surfaces'**
  String get caseGatherUpTierSurfaces;

  /// No description provided for @caseGatherUpTierPatterns.
  ///
  /// In en, this message translates to:
  /// **'Patterns'**
  String get caseGatherUpTierPatterns;

  /// No description provided for @caseGatherUpChipColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get caseGatherUpChipColor;

  /// No description provided for @caseGatherUpChipSpace.
  ///
  /// In en, this message translates to:
  /// **'Space'**
  String get caseGatherUpChipSpace;

  /// No description provided for @caseGatherUpChipRadius.
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get caseGatherUpChipRadius;

  /// No description provided for @caseGatherUpChipType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get caseGatherUpChipType;

  /// No description provided for @caseGatherUpChipIcon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get caseGatherUpChipIcon;

  /// No description provided for @caseGatherUpChipElevation.
  ///
  /// In en, this message translates to:
  /// **'Elevation'**
  String get caseGatherUpChipElevation;

  /// No description provided for @caseGatherUpChipButton.
  ///
  /// In en, this message translates to:
  /// **'Button'**
  String get caseGatherUpChipButton;

  /// No description provided for @caseGatherUpChipInput.
  ///
  /// In en, this message translates to:
  /// **'Input'**
  String get caseGatherUpChipInput;

  /// No description provided for @caseGatherUpChipChip.
  ///
  /// In en, this message translates to:
  /// **'Chip'**
  String get caseGatherUpChipChip;

  /// No description provided for @caseGatherUpChipCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get caseGatherUpChipCard;

  /// No description provided for @caseGatherUpChipSheet.
  ///
  /// In en, this message translates to:
  /// **'Sheet'**
  String get caseGatherUpChipSheet;

  /// No description provided for @caseGatherUpChipNav.
  ///
  /// In en, this message translates to:
  /// **'Nav'**
  String get caseGatherUpChipNav;

  /// No description provided for @caseGatherUpChipBooking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get caseGatherUpChipBooking;

  /// No description provided for @caseGatherUpChipChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get caseGatherUpChipChat;

  /// No description provided for @caseGatherUpChipMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get caseGatherUpChipMap;

  /// No description provided for @caseGatherUpColorGold.
  ///
  /// In en, this message translates to:
  /// **'Brand gold'**
  String get caseGatherUpColorGold;

  /// No description provided for @caseGatherUpColorNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get caseGatherUpColorNight;

  /// No description provided for @caseGatherUpColorChalk.
  ///
  /// In en, this message translates to:
  /// **'Chalk'**
  String get caseGatherUpColorChalk;

  /// No description provided for @caseGatherUpThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get caseGatherUpThemeLight;

  /// No description provided for @caseGatherUpThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get caseGatherUpThemeDark;

  /// No description provided for @caseGatherUpThemeEn.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get caseGatherUpThemeEn;

  /// No description provided for @caseGatherUpThemeAr.
  ///
  /// In en, this message translates to:
  /// **'AR'**
  String get caseGatherUpThemeAr;

  /// No description provided for @caseGatherUpTypeEnLabel.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get caseGatherUpTypeEnLabel;

  /// No description provided for @caseGatherUpTypeEnSample.
  ///
  /// In en, this message translates to:
  /// **'Meet through shared interests, not profiles.'**
  String get caseGatherUpTypeEnSample;

  /// No description provided for @caseGatherUpTypeArLabel.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get caseGatherUpTypeArLabel;

  /// No description provided for @caseGatherUpTypeArSample.
  ///
  /// In en, this message translates to:
  /// **'التعارف عبر الاهتمامات المشتركة، لا الملفات الشخصية.'**
  String get caseGatherUpTypeArSample;

  /// No description provided for @caseGatherUpCompButtons.
  ///
  /// In en, this message translates to:
  /// **'Buttons — press states that feel native'**
  String get caseGatherUpCompButtons;

  /// No description provided for @caseGatherUpCompChips.
  ///
  /// In en, this message translates to:
  /// **'Chips — filters you can scan at a glance'**
  String get caseGatherUpCompChips;

  /// No description provided for @caseGatherUpCompSheets.
  ///
  /// In en, this message translates to:
  /// **'Sheets — context without losing place'**
  String get caseGatherUpCompSheets;

  /// No description provided for @caseGatherUpMotionHeadline.
  ///
  /// In en, this message translates to:
  /// **'Shared motion language.'**
  String get caseGatherUpMotionHeadline;

  /// No description provided for @caseGatherUpMotionMicro.
  ///
  /// In en, this message translates to:
  /// **'Micro'**
  String get caseGatherUpMotionMicro;

  /// No description provided for @caseGatherUpMotionMicroUse.
  ///
  /// In en, this message translates to:
  /// **'Press'**
  String get caseGatherUpMotionMicroUse;

  /// No description provided for @caseGatherUpMotionQuick.
  ///
  /// In en, this message translates to:
  /// **'Quick'**
  String get caseGatherUpMotionQuick;

  /// No description provided for @caseGatherUpMotionQuickUse.
  ///
  /// In en, this message translates to:
  /// **'Tab, chip'**
  String get caseGatherUpMotionQuickUse;

  /// No description provided for @caseGatherUpMotionStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get caseGatherUpMotionStandard;

  /// No description provided for @caseGatherUpMotionStandardUse.
  ///
  /// In en, this message translates to:
  /// **'Sheet'**
  String get caseGatherUpMotionStandardUse;

  /// No description provided for @caseGatherUpMotionScreen.
  ///
  /// In en, this message translates to:
  /// **'Screen'**
  String get caseGatherUpMotionScreen;

  /// No description provided for @caseGatherUpMotionScreenUse.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get caseGatherUpMotionScreenUse;

  /// No description provided for @caseGatherUpMotionTab.
  ///
  /// In en, this message translates to:
  /// **'Tab'**
  String get caseGatherUpMotionTab;

  /// No description provided for @caseGatherUpMotionPush.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get caseGatherUpMotionPush;

  /// No description provided for @caseGatherUpMotionSheet.
  ///
  /// In en, this message translates to:
  /// **'Sheet'**
  String get caseGatherUpMotionSheet;

  /// No description provided for @caseGatherUpMotionPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get caseGatherUpMotionPrivacy;

  /// No description provided for @caseGatherUpReduceMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduce Motion respected'**
  String get caseGatherUpReduceMotion;

  /// No description provided for @caseGatherUpCodeHeadline.
  ///
  /// In en, this message translates to:
  /// **'From design to shipped Flutter code.'**
  String get caseGatherUpCodeHeadline;

  /// No description provided for @caseGatherUpCodeDesign.
  ///
  /// In en, this message translates to:
  /// **'01 Design'**
  String get caseGatherUpCodeDesign;

  /// No description provided for @caseGatherUpCodeDesignBody.
  ///
  /// In en, this message translates to:
  /// **'Tokens and surfaces from the product system — wired into Flutter themes and constants.'**
  String get caseGatherUpCodeDesignBody;

  /// No description provided for @caseGatherUpCodeCode.
  ///
  /// In en, this message translates to:
  /// **'02 Code'**
  String get caseGatherUpCodeCode;

  /// No description provided for @caseGatherUpCodeCodeBody.
  ///
  /// In en, this message translates to:
  /// **'Reusable widgets for booking, chat, maps, and auth — Clean Architecture with Provider.'**
  String get caseGatherUpCodeCodeBody;

  /// No description provided for @caseGatherUpCodeShip.
  ///
  /// In en, this message translates to:
  /// **'03 Ship'**
  String get caseGatherUpCodeShip;

  /// No description provided for @caseGatherUpCodeShipBody.
  ///
  /// In en, this message translates to:
  /// **'Shipped mobile features on iOS, Android, and web with responsive layouts.'**
  String get caseGatherUpCodeShipBody;

  /// No description provided for @caseGatherUpCodeClosing.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpCodeClosing;

  /// No description provided for @caseGatherUpRoleBooking.
  ///
  /// In en, this message translates to:
  /// **'Event booking flow'**
  String get caseGatherUpRoleBooking;

  /// No description provided for @caseGatherUpRoleBookingD.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpRoleBookingD;

  /// No description provided for @caseGatherUpRoleAuth.
  ///
  /// In en, this message translates to:
  /// **'Authentication & JWT authorization'**
  String get caseGatherUpRoleAuth;

  /// No description provided for @caseGatherUpRoleAuthD.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpRoleAuthD;

  /// No description provided for @caseGatherUpRoleRest.
  ///
  /// In en, this message translates to:
  /// **'REST API integration'**
  String get caseGatherUpRoleRest;

  /// No description provided for @caseGatherUpRoleRestD.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpRoleRestD;

  /// No description provided for @caseGatherUpRoleCache.
  ///
  /// In en, this message translates to:
  /// **'Local caching'**
  String get caseGatherUpRoleCache;

  /// No description provided for @caseGatherUpRoleCacheD.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpRoleCacheD;

  /// No description provided for @caseGatherUpRoleMaps.
  ///
  /// In en, this message translates to:
  /// **'Google Maps integration'**
  String get caseGatherUpRoleMaps;

  /// No description provided for @caseGatherUpRoleMapsD.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpRoleMapsD;

  /// No description provided for @caseGatherUpRoleFcm.
  ///
  /// In en, this message translates to:
  /// **'Push notifications (FCM)'**
  String get caseGatherUpRoleFcm;

  /// No description provided for @caseGatherUpRoleFcmD.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpRoleFcmD;

  /// No description provided for @caseGatherUpRoleChat.
  ///
  /// In en, this message translates to:
  /// **'Real-time chat'**
  String get caseGatherUpRoleChat;

  /// No description provided for @caseGatherUpRoleChatD.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpRoleChatD;

  /// No description provided for @caseGatherUpRoleUi.
  ///
  /// In en, this message translates to:
  /// **'Responsive cross-platform UI'**
  String get caseGatherUpRoleUi;

  /// No description provided for @caseGatherUpRoleUiD.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpRoleUiD;

  /// No description provided for @caseGatherUpArchWhy.
  ///
  /// In en, this message translates to:
  /// **'Clean Architecture keeps UI, business rules, and data sources separate — so booking, auth, maps, and chat can grow without tangling. Provider owns state at the presentation edge; repositories talk to remote APIs and local caches behind a stable domain layer.'**
  String get caseGatherUpArchWhy;

  /// No description provided for @caseGatherUpScrDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get caseGatherUpScrDiscover;

  /// No description provided for @caseGatherUpScrDetails.
  ///
  /// In en, this message translates to:
  /// **'Event details'**
  String get caseGatherUpScrDetails;

  /// No description provided for @caseGatherUpScrBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get caseGatherUpScrBook;

  /// No description provided for @caseGatherUpScrChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get caseGatherUpScrChat;

  /// No description provided for @caseGatherUpScrMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get caseGatherUpScrMap;

  /// No description provided for @caseGatherUpScrNotif.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get caseGatherUpScrNotif;

  /// No description provided for @caseGatherUpCh1Problem.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpCh1Problem;

  /// No description provided for @caseGatherUpCh1Solution.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpCh1Solution;

  /// No description provided for @caseGatherUpCh1Learned.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpCh1Learned;

  /// No description provided for @caseGatherUpCh2Problem.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpCh2Problem;

  /// No description provided for @caseGatherUpCh2Solution.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpCh2Solution;

  /// No description provided for @caseGatherUpCh2Learned.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpCh2Learned;

  /// No description provided for @caseGatherUpCh3Problem.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpCh3Problem;

  /// No description provided for @caseGatherUpCh3Solution.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpCh3Solution;

  /// No description provided for @caseGatherUpCh3Learned.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpCh3Learned;

  /// No description provided for @caseGatherUpStatUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get caseGatherUpStatUsers;

  /// No description provided for @caseGatherUpStatBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get caseGatherUpStatBookings;

  /// No description provided for @caseGatherUpStatRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get caseGatherUpStatRating;

  /// No description provided for @caseGatherUpLearn1.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpLearn1;

  /// No description provided for @caseGatherUpLearn2.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpLearn2;

  /// No description provided for @caseGatherUpLearn3.
  ///
  /// In en, this message translates to:
  /// **'TODO_REPLACE'**
  String get caseGatherUpLearn3;

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
