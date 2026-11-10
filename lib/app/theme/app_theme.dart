import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_typography.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/portfolio_fonts.dart';

abstract final class AppTheme {
  /// Loads bundled fonts for [locale] (Latin if null / non-ar).
  static Future<void> preloadFonts([Locale? locale]) {
    return PortfolioFonts.loadForLocale(
      arabic: AppTypography.isArabicLocale(locale),
    );
  }

  static TextTheme _textTheme(Brightness brightness, {required bool forArabic}) {
    final ink = brightness == Brightness.dark
        ? AppColors.offWhite
        : AppColors.navyInk;

    return TextTheme(
      displayLarge: AppTypography.headlineFor(
        arabic: forArabic,
        fontSize: 96,
        color: ink,
        height: forArabic ? 1.2 : 0.9,
        letterSpacing: forArabic ? 0 : 2,
      ),
      displayMedium: AppTypography.headlineFor(
        arabic: forArabic,
        fontSize: 56,
        color: ink,
        height: forArabic ? 1.25 : 0.95,
      ),
      headlineLarge: AppTypography.brushFor(
        arabic: forArabic,
        fontSize: 48,
        color: AppColors.flutterLightBlue,
      ),
      headlineMedium: AppTypography.brushFor(
        arabic: forArabic,
        fontSize: 32,
        color: AppColors.flutterLightBlue,
      ),
      titleMedium: forArabic
          ? AppTypography.bodyFor(
              arabic: true,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ink,
              height: 1.5,
            )
          : AppTypography.noteFor(
              arabic: false,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ink,
            ),
      bodyLarge: forArabic
          ? AppTypography.bodyFor(
              arabic: true,
              fontSize: 16,
              color: ink,
              height: 1.6,
            )
          : AppTypography.noteFor(
              arabic: false,
              fontSize: 16,
              color: ink,
              height: 1.35,
            ),
      bodyMedium: AppTypography.labelFor(
        arabic: forArabic,
        fontSize: 12,
        color: ink,
        fontWeight: FontWeight.w400,
        letterSpacing: forArabic ? 0 : 1.4,
      ),
      labelSmall: AppTypography.labelFor(
        arabic: forArabic,
        fontSize: 10,
        color: ink,
        fontWeight: FontWeight.w700,
        letterSpacing: forArabic ? 0 : 2.2,
      ),
    );
  }

  static ThemeData _base(ZineColors zine, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.flutterBlue,
      onPrimary: AppColors.offWhite,
      secondary: AppColors.flutterLightBlue,
      onSecondary: AppColors.navyInk,
      error: AppColors.flutterBlue,
      onError: AppColors.offWhite,
      surface: zine.canvas,
      onSurface: zine.ink,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: zine.canvas,
      textTheme: _textTheme(brightness, forArabic: false),
      extensions: [zine],
      splashFactory: NoSplash.splashFactory,
    );
  }

  static ThemeData get light => _base(ZineColors.light, Brightness.light);
  static ThemeData get dark => _base(ZineColors.dark, Brightness.dark);

  static ThemeData withLocale(ThemeData base, Locale? locale) {
    final ar = locale?.languageCode == 'ar';
    if (!ar) return base;
    return base.copyWith(
      textTheme: _textTheme(base.brightness, forArabic: true),
    );
  }
}
