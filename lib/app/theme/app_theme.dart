import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';

abstract final class AppTheme {
  /// Touch font families so [GoogleFonts.pendingFonts] can resolve them.
  static Future<void> preloadFonts() async {
    GoogleFonts.bebasNeue();
    GoogleFonts.permanentMarker();
    GoogleFonts.spaceMono();
    GoogleFonts.kalam();
    GoogleFonts.cairo();
    GoogleFonts.reemKufi();
    await GoogleFonts.pendingFonts();
  }

  static TextTheme _textTheme(Brightness brightness, {required bool forArabic}) {
    final ink = brightness == Brightness.dark
        ? AppColors.offWhite
        : AppColors.navyInk;

    final display = forArabic ? GoogleFonts.reemKufi : GoogleFonts.bebasNeue;
    final script =
        forArabic ? GoogleFonts.reemKufi : GoogleFonts.permanentMarker;
    final body = forArabic ? GoogleFonts.cairo : GoogleFonts.kalam;
    final mono = GoogleFonts.spaceMono;

    return TextTheme(
      displayLarge: display(
        fontSize: 96,
        height: 0.9,
        letterSpacing: forArabic ? 0 : 2,
        color: ink,
        fontWeight: FontWeight.w700,
        decoration: TextDecoration.none,
      ),
      displayMedium: display(
        fontSize: 56,
        height: 0.95,
        color: ink,
        fontWeight: FontWeight.w700,
        decoration: TextDecoration.none,
      ),
      headlineLarge: script(
        fontSize: 48,
        color: AppColors.flutterLightBlue,
        fontWeight: FontWeight.w700,
        decoration: TextDecoration.none,
      ),
      headlineMedium: script(
        fontSize: 32,
        color: AppColors.flutterLightBlue,
        fontWeight: FontWeight.w700,
        decoration: TextDecoration.none,
      ),
      titleMedium: body(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: ink,
        decoration: TextDecoration.none,
      ),
      bodyLarge: body(
        fontSize: 16,
        height: 1.35,
        color: ink,
        decoration: TextDecoration.none,
      ),
      bodyMedium: mono(
        fontSize: 12,
        letterSpacing: 1.4,
        color: ink,
        decoration: TextDecoration.none,
      ),
      labelSmall: mono(
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
