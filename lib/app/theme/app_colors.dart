import 'package:flutter/material.dart';

/// Flutter brand palette — single source of truth. No red accents.
abstract final class AppColors {
  static const deepNavy = Color(0xFF050B18);
  static const navy = Color(0xFF0A1628);
  static const navyInk = Color(0xFF042B59);
  static const flutterBlue = Color(0xFF02569B);
  static const flutterLightBlue = Color(0xFF13B9FD);
  static const offWhite = Color(0xFFF4F8FC);
  static const paper = Color(0xFFEAF3FB);
  static const paperEdge = Color(0xFFC5D6E8);
  static const stickyYellow = Color(0xFFFFD54F);
  static const glowBlue = Color(0x1F13B9FD); // ~12% opacity
}

@immutable
class ZineColors extends ThemeExtension<ZineColors> {
  const ZineColors({
    required this.canvas,
    required this.canvasDeep,
    required this.ink,
    required this.inkMuted,
    required this.paper,
    required this.paperEdge,
    required this.sticky,
    required this.stickyAlt,
    required this.tape,
    required this.tapeAlt,
    required this.glow,
    required this.chip,
    required this.chipHover,
    required this.divider,
    required this.accent,
    required this.accentDeep,
  });

  final Color canvas;
  final Color canvasDeep;
  final Color ink;
  final Color inkMuted;
  final Color paper;
  final Color paperEdge;
  final Color sticky;
  final Color stickyAlt;
  final Color tape;
  final Color tapeAlt;
  final Color glow;
  final Color chip;
  final Color chipHover;
  final Color divider;
  final Color accent;
  final Color accentDeep;

  static const dark = ZineColors(
    canvas: AppColors.deepNavy,
    canvasDeep: AppColors.navy,
    ink: AppColors.offWhite,
    inkMuted: Color(0xFF9BB0C7),
    paper: AppColors.paper,
    paperEdge: AppColors.paperEdge,
    sticky: AppColors.stickyYellow,
    stickyAlt: Color(0xFFD6EAF8),
    tape: Color(0xE6A8C8E0),
    tapeAlt: Color(0xE613B9FD),
    glow: AppColors.glowBlue,
    chip: AppColors.paper,
    chipHover: AppColors.flutterLightBlue,
    divider: Color(0x66F4F8FC),
    accent: AppColors.flutterLightBlue,
    accentDeep: AppColors.flutterBlue,
  );

  static const light = ZineColors(
    canvas: AppColors.offWhite,
    canvasDeep: Color(0xFFE8F1FA),
    ink: AppColors.navyInk,
    inkMuted: Color(0xFF5A7190),
    paper: Color(0xFFFFFFFF),
    paperEdge: AppColors.paperEdge,
    sticky: AppColors.stickyYellow,
    stickyAlt: Color(0xFFD6EAF8),
    tape: Color(0xE6A8C8E0),
    tapeAlt: Color(0xE602569B),
    glow: Color(0x3313B9FD),
    chip: Color(0xFFFFFFFF),
    chipHover: AppColors.flutterBlue,
    divider: Color(0x33042B59),
    accent: AppColors.flutterLightBlue,
    accentDeep: AppColors.flutterBlue,
  );

  @override
  ZineColors copyWith({
    Color? canvas,
    Color? canvasDeep,
    Color? ink,
    Color? inkMuted,
    Color? paper,
    Color? paperEdge,
    Color? sticky,
    Color? stickyAlt,
    Color? tape,
    Color? tapeAlt,
    Color? glow,
    Color? chip,
    Color? chipHover,
    Color? divider,
    Color? accent,
    Color? accentDeep,
  }) {
    return ZineColors(
      canvas: canvas ?? this.canvas,
      canvasDeep: canvasDeep ?? this.canvasDeep,
      ink: ink ?? this.ink,
      inkMuted: inkMuted ?? this.inkMuted,
      paper: paper ?? this.paper,
      paperEdge: paperEdge ?? this.paperEdge,
      sticky: sticky ?? this.sticky,
      stickyAlt: stickyAlt ?? this.stickyAlt,
      tape: tape ?? this.tape,
      tapeAlt: tapeAlt ?? this.tapeAlt,
      glow: glow ?? this.glow,
      chip: chip ?? this.chip,
      chipHover: chipHover ?? this.chipHover,
      divider: divider ?? this.divider,
      accent: accent ?? this.accent,
      accentDeep: accentDeep ?? this.accentDeep,
    );
  }

  @override
  ZineColors lerp(ThemeExtension<ZineColors>? other, double t) {
    if (other is! ZineColors) return this;
    return ZineColors(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      canvasDeep: Color.lerp(canvasDeep, other.canvasDeep, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkMuted: Color.lerp(inkMuted, other.inkMuted, t)!,
      paper: Color.lerp(paper, other.paper, t)!,
      paperEdge: Color.lerp(paperEdge, other.paperEdge, t)!,
      sticky: Color.lerp(sticky, other.sticky, t)!,
      stickyAlt: Color.lerp(stickyAlt, other.stickyAlt, t)!,
      tape: Color.lerp(tape, other.tape, t)!,
      tapeAlt: Color.lerp(tapeAlt, other.tapeAlt, t)!,
      glow: Color.lerp(glow, other.glow, t)!,
      chip: Color.lerp(chip, other.chip, t)!,
      chipHover: Color.lerp(chipHover, other.chipHover, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentDeep: Color.lerp(accentDeep, other.accentDeep, t)!,
    );
  }
}

extension ZineColorsX on BuildContext {
  ZineColors get zine => Theme.of(this).extension<ZineColors>()!;
}
