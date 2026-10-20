import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/animation/idle_ticker.dart';
import 'package:ahmed_rasmy_portfolio/core/painters/hand_drawn_painter.dart';
import 'package:ahmed_rasmy_portfolio/core/painters/tape_painter.dart';
import 'package:ahmed_rasmy_portfolio/core/painters/torn_paper.dart';

class WhoIAmNote extends StatefulWidget {
  const WhoIAmNote({
    super.key,
    this.compact = false,
    this.expand = false,
    this.reduceMotion = false,
    this.idle,
  });

  final bool compact;
  final bool expand;
  final bool reduceMotion;
  final IdleTicker? idle;

  @override
  State<WhoIAmNote> createState() => _WhoIAmNoteState();
}

class _WhoIAmNoteState extends State<WhoIAmNote> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final items = [
      l10n.whoItem1,
      l10n.whoItem2,
      l10n.whoItem3,
      l10n.whoItem4,
      l10n.whoItem5,
    ];
    final baseAngle = widget.compact ? -0.02 : -0.05;
    final angle = _hover || widget.reduceMotion ? 0.0 : baseAngle;

    Widget note = MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        transformAlignment: Alignment.center,
        transform: Matrix4.rotationZ(angle)
          ..setTranslationRaw(0, _hover ? -8.0 : 0, 0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: widget.expand
                  ? double.infinity
                  : (widget.compact ? 240.0 : 280.0),
              padding: const EdgeInsets.fromLTRB(20, 28, 18, 56),
              decoration: BoxDecoration(
                color: zine.paper,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.navyInk.withValues(alpha: _hover ? 0.28 : 0.18),
                    blurRadius: _hover ? 18 : 12,
                    offset: Offset(0, _hover ? 12 : 7),
                  ),
                ],
              ),
              child: ClipPath(
                clipper: TornPaperClipper(seed: 11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.whoIAmTitle,
                      style: (isAr
                              ? GoogleFonts.reemKufi(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.flutterLightBlue,
                                )
                              : GoogleFonts.permanentMarker(
                                  fontSize: 26,
                                  color: AppColors.flutterLightBlue,
                                ))
                          .copyWith(decoration: TextDecoration.none),
                    ),
                    SizedBox(
                      width: 110,
                      height: 12,
                      child: CustomPaint(
                        painter: HandDrawnUnderlinePainter(
                          color: AppColors.flutterLightBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...items.asMap().entries.map((e) {
                      Widget check = Text(
                        '✓ ',
                        style: GoogleFonts.permanentMarker(
                          color: AppColors.flutterLightBlue,
                          fontSize: 16,
                          decoration: TextDecoration.none,
                        ),
                      );
                      if (!widget.reduceMotion) {
                        check = check
                            .animate(delay: (700 + e.key * 100).ms)
                            .fadeIn()
                            .scale(
                              begin: const Offset(0.2, 0.2),
                              curve: Curves.easeOutBack,
                            );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            check,
                            Expanded(
                              child: Text(
                                e.value,
                                style: (isAr
                                        ? GoogleFonts.cairo(
                                            fontSize: 14,
                                            height: 1.3,
                                            color: AppColors.navyInk,
                                          )
                                        : GoogleFonts.kalam(
                                            fontSize: 14,
                                            height: 1.25,
                                            color: AppColors.navyInk,
                                          ))
                                    .copyWith(decoration: TextDecoration.none),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -10,
              left: 0,
              right: 0,
              child: Center(
                child: TapeStrip(color: zine.tape, width: 96, height: 24),
              ),
            ),
            Positioned(
              left: -18,
              bottom: -26,
              child: Transform.rotate(
                angle: -0.2,
                child: SizedBox(
                  width: widget.expand ? 64 : 78,
                  height: widget.expand ? 64 : 78,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: Size(
                          widget.expand ? 64 : 78,
                          widget.expand ? 64 : 78,
                        ),
                        painter: StarburstBadgePainter(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          l10n.estBadge,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.spaceMono(
                            fontSize: widget.expand ? 7 : 8,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                            color: AppColors.offWhite,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (!widget.reduceMotion) {
      note = note
          .animate(delay: 550.ms)
          .fadeIn()
          .slideY(begin: -0.2, end: 0, curve: Curves.easeOutCubic)
          .rotate(begin: -0.06, end: 0);
    }

    note = RepaintBoundary(child: note);

    if (widget.idle != null && !widget.reduceMotion) {
      note = IdleFloat(
        ticker: widget.idle!,
        amplitude: 2.5,
        rotationAmp: 0.01,
        period: const Duration(milliseconds: 3400),
        child: note,
      );
    }

    return note;
  }
}
