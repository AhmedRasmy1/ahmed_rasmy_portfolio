import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/portfolio_fonts.dart';

/// Locale-aware text styles — **only** entry point for font families.
abstract final class AppTypography {
  static bool isArabic(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar';

  static bool isArabicLocale(Locale? locale) => locale?.languageCode == 'ar';

  /// Uppercase for Latin scripts only — never mutate Arabic.
  static String displayCase(BuildContext context, String text) {
    if (isArabic(context)) return text;
    return text.toUpperCase();
  }

  static String displayCaseForLocale(Locale? locale, String text) {
    if (isArabicLocale(locale)) return text;
    return text.toUpperCase();
  }

  // ---------------------------------------------------------------------------
  // Roles
  // ---------------------------------------------------------------------------

  /// Large display / section headlines.
  static TextStyle headline(
    BuildContext context, {
    double fontSize = 36,
    Color? color,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
  }) =>
      headlineFor(
        arabic: isArabic(context),
        fontSize: fontSize,
        color: color ?? context.zine.ink,
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
      );

  static TextStyle headlineFor({
    required bool arabic,
    double fontSize = 36,
    Color? color,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
  }) {
    if (arabic) {
      // Lalezar ships a single real weight (~400) — never faux-bold.
      return _ar(
        family: PortfolioFonts.lalezar,
        fallback: const [
          PortfolioFonts.bebasNeue,
          PortfolioFonts.ibmPlexSansArabic,
        ],
        fontSize: fontSize,
        height: height ?? 1.25,
        fontWeight: FontWeight.w400,
        color: color,
        variations: null,
      );
    }
    return _en(
      family: PortfolioFonts.bebasNeue,
      fontSize: fontSize,
      height: height ?? 0.95,
      letterSpacing: letterSpacing ?? 1.2,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  /// Brush / accent word (Permanent Marker ↔ Marhey).
  static TextStyle brush(
    BuildContext context, {
    double fontSize = 32,
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) =>
      brushFor(
        arabic: isArabic(context),
        fontSize: fontSize,
        color: color ?? AppColors.flutterLightBlue,
        fontWeight: fontWeight,
        height: height,
      );

  static TextStyle brushFor({
    required bool arabic,
    double fontSize = 32,
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) {
    if (arabic) {
      final w = _clampWeight(fontWeight ?? FontWeight.w700, min: 300, max: 700);
      return _ar(
        family: PortfolioFonts.marhey,
        fallback: const [
          PortfolioFonts.permanentMarker,
          PortfolioFonts.ibmPlexSansArabic,
        ],
        fontSize: fontSize,
        height: height ?? 1.25,
        fontWeight: w,
        color: color,
        variations: [FontVariation('wght', w.value.toDouble())],
      );
    }
    return _en(
      family: PortfolioFonts.permanentMarker,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  /// Handwritten / sticky-note body (Kalam ↔ Playpen Sans Arabic).
  static TextStyle note(
    BuildContext context, {
    double fontSize = 16,
    Color? color,
    FontWeight? fontWeight,
    double? height,
    FontStyle? fontStyle,
  }) =>
      noteFor(
        arabic: isArabic(context),
        fontSize: fontSize,
        color: color ?? context.zine.ink,
        fontWeight: fontWeight,
        height: height,
        fontStyle: fontStyle,
      );

  static TextStyle noteFor({
    required bool arabic,
    double fontSize = 16,
    Color? color,
    FontWeight? fontWeight,
    double? height,
    FontStyle? fontStyle,
  }) {
    if (arabic) {
      final w = _clampWeight(fontWeight ?? FontWeight.w400, min: 100, max: 800);
      return _ar(
        family: PortfolioFonts.playpenSansArabic,
        fallback: const [
          PortfolioFonts.kalam,
          PortfolioFonts.ibmPlexSansArabic,
        ],
        fontSize: fontSize,
        height: height ?? 1.55,
        fontWeight: w,
        color: color,
        // No italic for Arabic (avoids faux oblique).
        fontStyle: FontStyle.normal,
        variations: [FontVariation('wght', w.value.toDouble())],
      );
    }
    return _en(
      family: PortfolioFonts.kalam,
      fontSize: fontSize,
      height: height ?? 1.5,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
    );
  }

  /// Reading body copy.
  static TextStyle body(
    BuildContext context, {
    double fontSize = 15,
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) =>
      bodyFor(
        arabic: isArabic(context),
        fontSize: fontSize,
        color: color ?? context.zine.inkMuted,
        fontWeight: fontWeight,
        height: height,
      );

  static TextStyle bodyFor({
    required bool arabic,
    double fontSize = 15,
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) {
    if (arabic) {
      return _ar(
        family: PortfolioFonts.ibmPlexSansArabic,
        fallback: const [PortfolioFonts.kalam, PortfolioFonts.spaceMono],
        fontSize: fontSize,
        height: height ?? 1.6,
        fontWeight: _ibmWeight(fontWeight),
        color: color,
        variations: null,
      );
    }
    return _en(
      family: PortfolioFonts.kalam,
      fontSize: fontSize,
      height: height ?? 1.5,
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// Mono-style labels / chips / captions (Space Mono ↔ IBM Plex Sans Arabic).
  static TextStyle label(
    BuildContext context, {
    double fontSize = 11,
    Color? color,
    FontWeight fontWeight = FontWeight.w700,
    double? letterSpacing,
    double? height,
  }) =>
      labelFor(
        arabic: isArabic(context),
        fontSize: fontSize,
        color: color ?? context.zine.ink,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle labelFor({
    required bool arabic,
    double fontSize = 11,
    Color? color,
    FontWeight fontWeight = FontWeight.w700,
    double? letterSpacing,
    double? height,
  }) {
    if (arabic) {
      return _ar(
        family: PortfolioFonts.ibmPlexSansArabic,
        fallback: const [PortfolioFonts.spaceMono],
        fontSize: fontSize,
        height: height ?? 1.35,
        fontWeight: _ibmWeight(fontWeight),
        color: color,
        variations: null,
      );
    }
    return _en(
      family: PortfolioFonts.spaceMono,
      fontSize: fontSize,
      height: height,
      letterSpacing: letterSpacing ?? 1.4,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  static TextStyle _en({
    required String family,
    required double fontSize,
    Color? color,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontFamily: family,
      fontSize: fontSize,
      height: height,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle _ar({
    required String family,
    required List<String> fallback,
    required double fontSize,
    required double height,
    required FontWeight fontWeight,
    Color? color,
    FontStyle fontStyle = FontStyle.normal,
    List<FontVariation>? variations,
  }) {
    return TextStyle(
      fontFamily: family,
      fontFamilyFallback: fallback,
      fontSize: fontSize,
      height: height,
      letterSpacing: 0,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontVariations: variations,
      color: color,
      decoration: TextDecoration.none,
    );
  }

  static FontWeight _ibmWeight(FontWeight? requested) {
    final v = requested?.value ?? 400;
    if (v >= 675) return FontWeight.w700;
    if (v >= 550) return FontWeight.w600;
    return FontWeight.w400;
  }

  static FontWeight _clampWeight(
    FontWeight weight, {
    required int min,
    required int max,
  }) {
    final v = weight.value.clamp(min, max);
    return FontWeight.values.firstWhere(
      (w) => w.value == v,
      orElse: () => FontWeight.w400,
    );
  }
}

/// Locale-aware uppercase helper: `context.caps(text)`.
extension TypographyCaps on BuildContext {
  String caps(String text) => AppTypography.displayCase(this, text);
}
