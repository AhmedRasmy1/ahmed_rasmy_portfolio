import 'package:ahmed_rasmy_portfolio/core/constants/site_config.dart';

/// Site-wide constants used by SEO shell references and in-app meta updates.
abstract final class AppConstants {
  static const String siteName = 'Ahmed Hisham Rasmy';
  static const String siteTagline = 'Flutter developer — Design · Build · Ship';
  static const String siteDescription =
      'Flutter developer in Cairo building mobile, web, and desktop apps '
      'with Clean Architecture.';

  /// Prefer [SiteConfig.baseUrl]; kept for existing call sites.
  static const String canonicalOrigin = SiteConfig.baseUrl;

  static const List<String> supportedLanguageCodes = ['en', 'ar'];
}
