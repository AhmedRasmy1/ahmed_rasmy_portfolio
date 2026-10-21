import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_typography.dart';

abstract final class AppTheme {
  /// Touch font families so [GoogleFonts.pendingFonts] can resolve them.
  static Future<void> preloadFonts() => AppTypography.preload();

  static TextTheme _textTheme(Brightness brightness, {required bool forArabic}) {
    final ink = brightness == Brightness.dark
        ? AppColors.offWhite
        : AppColors.navyInk;

    if (forArabic) {
      return TextTheme(
        displayLarge: GoogleFonts.lalezar(
          fontSize: 96,
          height: 1.15,
          letterSpacing: 0,
          color: ink,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.none,
        ),
        displayMedium: GoogleFonts.lalezar(
          fontSize: 56,
          height: 1.2,
          letterSpacing: 0,
          color: ink,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.none,
        ),
        headlineLarge: GoogleFonts.marhey(
          fontSize: 48,
          height: 1.2,
          letterSpacing: 0,
          color: AppColors.flutterLightBlue,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.none,
        ),
        headlineMedium: GoogleFonts.marhey(
          fontSize: 32,
          height: 1.2,
          letterSpacing: 0,
          color: AppColors.flutterLightBlue,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.none,
        ),
        titleMedium: GoogleFonts.ibmPlexSansArabic(
          fontSize: 18,
          height: 1.5,
          letterSpacing: 0,
          fontWeight: FontWeight.w700,
          color: ink,
          decoration: TextDecoration.none,
        ),
        bodyLarge: GoogleFonts.ibmPlexSansArabic(
          fontSize: 16,
          height: 1.6,
          letterSpacing: 0,
          color: ink,
          decoration: TextDecoration.none,
        ),
        bodyMedium: GoogleFonts.ibmPlexSansArabic(
          fontSize: 12,
          height: 1.4,
          letterSpacing: 0,
          color: ink,
          decoration: TextDecoration.none,
        ),
        labelSmall: GoogleFonts.ibmPlexSansArabic(
          fontSize: 10,
          height: 1.35,
          letterSpacing: 0,
          fontWeight: FontWeight.w700,
          color: ink,
          decoration: TextDecoration.none,
        ),
      );
    }

    return TextTheme(
      displayLarge: GoogleFonts.bebasNeue(
        fontSize: 96,
        height: 0.9,
        letterSpacing: 2,
        color: ink,
        fontWeight: FontWeight.w700,
        decoration: TextDecoration.none,
      ),
      displayMedium: GoogleFonts.bebasNeue(
        fontSize: 56,
        height: 0.95,
        color: ink,
        fontWeight: FontWeight.w700,
        decoration: TextDecoration.none,
      ),
      headlineLarge: GoogleFonts.permanentMarker(
        fontSize: 48,
        color: AppColors.flutterLightBlue,
        fontWeight: FontWeight.w700,
        decoration: TextDecoration.none,
      ),
      headlineMedium: GoogleFonts.permanentMarker(
        fontSize: 32,
        color: AppColors.flutterLightBlue,
        fontWeight: FontWeight.w700,
        decoration: TextDecoration.none,
      ),
      titleMedium: GoogleFonts.kalam(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: ink,
        decoration: TextDecoration.none,
      ),
      bodyLarge: GoogleFonts.kalam(
        fontSize: 16,
        height: 1.35,
        color: ink,
        decoration: TextDecoration.none,
      ),
      bodyMedium: GoogleFonts.spaceMono(
        fontSize: 12,
        letterSpacing: 1.4,
        color: ink,
        decoration: TextDecoration.none,
      ),
      labelSmall: GoogleFonts.spaceMono(
        fontSize: 10,
        letterSpacing: 2.2,
        fontWeight: FontWeight.w700,
        color: ink,
        decoration: TextDecoration.none,
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
