import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';

class ProjectChips extends StatelessWidget {
  const ProjectChips({
    super.key,
    this.reduceMotion = false,
    this.customCursor = false,
  });

  final bool reduceMotion;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chips = [l10n.chip1, l10n.chip2, l10n.chip3, l10n.chip4, l10n.chip5];
    final angles = [0.03, -0.04, 0.05, -0.02, 0.035];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        for (var i = 0; i < chips.length; i++)
          _Chip(
            label: chips[i],
            angle: reduceMotion ? 0 : angles[i],
            reduceMotion: reduceMotion,
            delayMs: 900 + i * 70,
            customCursor: customCursor,
          ),
      ],
    );
  }
}

class _Chip extends StatefulWidget {
  const _Chip({
    required this.label,
    required this.angle,
    required this.reduceMotion,
    required this.delayMs,
    required this.customCursor,
  });

  final String label;
  final double angle;
  final bool reduceMotion;
  final int delayMs;
  final bool customCursor;

  @override
  State<_Chip> createState() => _ChipState();
}

class _ChipState extends State<_Chip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final zine = context.zine;
    final bg = _hover ? AppColors.flutterBlue : zine.chip;
    final fg = _hover ? AppColors.offWhite : AppColors.navyInk;

    Widget chip = MouseRegion(
      cursor: widget.customCursor
          ? SystemMouseCursors.none
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transformAlignment: Alignment.center,
        transform: Matrix4.rotationZ(_hover ? -0.02 : widget.angle)
          ..setTranslationRaw(0, _hover ? -6.0 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: AppColors.navyInk.withValues(alpha: _hover ? 0.25 : 0.12),
              blurRadius: _hover ? 10 : 5,
              offset: Offset(0, _hover ? 7 : 3),
            ),
          ],
        ),
        child: Text(
          widget.label,
          style: GoogleFonts.spaceMono(
            fontSize: 10,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
            color: fg,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );

    if (!widget.reduceMotion) {
      chip = chip
          .animate(delay: widget.delayMs.ms)
          .fadeIn()
          .slideY(begin: 0.25, end: 0, curve: Curves.easeOutCubic);
    }

    return RepaintBoundary(
      child: CursorTarget(enabled: widget.customCursor, child: chip),
    );
  }
}
