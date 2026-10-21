import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';

/// Locale-aware text styles. Widgets should prefer this over raw GoogleFonts.
abstract final class AppTypography {
  static bool isArabic(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar';

  static Future<void> preload() async {
    GoogleFonts.bebasNeue();
    GoogleFonts.permanentMarker();
    GoogleFonts.spaceMono();
    GoogleFonts.kalam();
    GoogleFonts.lalezar();
    GoogleFonts.reemKufi();
    GoogleFonts.marhey();
    GoogleFonts.rakkas();
    GoogleFonts.playpenSans();
    GoogleFonts.tajawal();
    GoogleFonts.ibmPlexSansArabic();
    GoogleFonts.cairo();
    await GoogleFonts.pendingFonts();
  }

  static TextStyle headline(
    BuildContext context, {
    double fontSize = 36,
    Color? color,
    FontWeight? fontWeight,
  }) {
    final ink = color ?? context.zine.ink;
    if (isArabic(context)) {
      try {
        return GoogleFonts.lalezar(
          fontSize: fontSize,
          height: 1.2,
          letterSpacing: 0,
          fontWeight: fontWeight ?? FontWeight.w700,
          color: ink,
          decoration: TextDecoration.none,
        );
      } catch (_) {
        return GoogleFonts.reemKufi(
          fontSize: fontSize,
          height: 1.2,
          letterSpacing: 0,
          fontWeight: fontWeight ?? FontWeight.w700,
          color: ink,
          decoration: TextDecoration.none,
        );
      }
    }
    return GoogleFonts.bebasNeue(
      fontSize: fontSize,
      height: 0.95,
      letterSpacing: 1.2,
      color: ink,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle brush(
    BuildContext context, {
    double fontSize = 32,
    Color? color,
  }) {
    final c = color ?? AppColors.flutterLightBlue;
    if (isArabic(context)) {
      try {
        return GoogleFonts.marhey(
          fontSize: fontSize,
          height: 1.2,
          letterSpacing: 0,
          fontWeight: FontWeight.w700,
          color: c,
          decoration: TextDecoration.none,
        );
      } catch (_) {
        return GoogleFonts.rakkas(
          fontSize: fontSize,
          height: 1.2,
          letterSpacing: 0,
          fontWeight: FontWeight.w700,
          color: c,
          decoration: TextDecoration.none,
        );
      }
    }
    return GoogleFonts.permanentMarker(
      fontSize: fontSize,
      color: c,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle note(
    BuildContext context, {
    double fontSize = 16,
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) {
    final ink = color ?? context.zine.ink;
    if (isArabic(context)) {
      try {
        return GoogleFonts.playpenSans(
          fontSize: fontSize,
          height: height ?? 1.55,
          letterSpacing: 0,
          fontWeight: fontWeight,
          color: ink,
          decoration: TextDecoration.none,
        );
      } catch (_) {
        return GoogleFonts.tajawal(
          fontSize: fontSize,
          height: height ?? 1.55,
          letterSpacing: 0,
          fontWeight: fontWeight,
          color: ink,
          decoration: TextDecoration.none,
        );
      }
    }
    return GoogleFonts.kalam(
      fontSize: fontSize,
      height: height ?? 1.5,
      fontWeight: fontWeight,
      color: ink,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle body(
    BuildContext context, {
    double fontSize = 15,
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) {
    final ink = color ?? context.zine.inkMuted;
    if (isArabic(context)) {
      try {
        return GoogleFonts.ibmPlexSansArabic(
          fontSize: fontSize,
          height: height ?? 1.6,
          letterSpacing: 0,
          fontWeight: fontWeight,
          color: ink,
          decoration: TextDecoration.none,
        );
      } catch (_) {
        return GoogleFonts.cairo(
          fontSize: fontSize,
          height: height ?? 1.6,
          letterSpacing: 0,
          fontWeight: fontWeight,
          color: ink,
          decoration: TextDecoration.none,
        );
      }
    }
    return GoogleFonts.kalam(
      fontSize: fontSize,
      height: height ?? 1.5,
      fontWeight: fontWeight,
      color: ink,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle label(
    BuildContext context, {
    double fontSize = 11,
    Color? color,
    FontWeight fontWeight = FontWeight.w700,
    double? letterSpacing,
  }) {
    final ink = color ?? context.zine.ink;
    if (isArabic(context)) {
      try {
        return GoogleFonts.ibmPlexSansArabic(
          fontSize: fontSize,
          height: 1.35,
          letterSpacing: 0,
          fontWeight: fontWeight,
          color: ink,
          decoration: TextDecoration.none,
        );
      } catch (_) {
        return GoogleFonts.cairo(
          fontSize: fontSize,
          height: 1.35,
          letterSpacing: 0,
          fontWeight: fontWeight,
          color: ink,
          decoration: TextDecoration.none,
        );
      }
    }
    return GoogleFonts.spaceMono(
      fontSize: fontSize,
      letterSpacing: letterSpacing ?? 1.4,
      fontWeight: fontWeight,
      color: ink,
      decoration: TextDecoration.none,
    );
  }

  /// Uppercase for Latin only — never uppercase Arabic.
  static String displayCase(BuildContext context, String text) {
    if (isArabic(context)) return text;
    return text.toUpperCase();
  }
}
