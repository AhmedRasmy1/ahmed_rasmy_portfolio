import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/animation/idle_ticker.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/painters/hand_drawn_painter.dart';
import 'package:ahmed_rasmy_portfolio/core/painters/tape_painter.dart';

class StickyNotesStack extends StatelessWidget {
  const StickyNotesStack({
    super.key,
    this.compact = false,
    this.reduceMotion = false,
    this.idle,
  });

  final bool compact;
  final bool reduceMotion;
  final IdleTicker? idle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final awwaab = PortfolioData.projectBySlug('awwaab');
    final playUrl = awwaab?.playStoreUrl;
    final canOpenPlay = !isTodo(playUrl);

    return Column(
      children: [
        _HoverCard(
          angle: 0.06,
          delayMs: 600,
          reduceMotion: reduceMotion,
          idle: idle,
          phase: 0.1,
          child: _PaperCard(
            color: zine.paper,
            tapeColor: zine.tape,
            child: Column(
              children: [
                const Icon(
                  Icons.flutter_dash,
                  color: AppColors.flutterBlue,
                  size: 22,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.statCardLabel,
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navyInk,
                    decoration: TextDecoration.none,
                  ),
                ),
                _CountUpStat(end: PortfolioData.shippedAppsCount),
                Text(
                  l10n.statCardSub,
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.flutterLightBlue,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: compact ? 12 : 16),
        _HoverCard(
          angle: -0.05,
          delayMs: 720,
          reduceMotion: reduceMotion,
          idle: idle,
          phase: 0.4,
          child: _PaperCard(
            color: zine.stickyAlt,
            tapeColor: zine.tapeAlt,
            onTap: canOpenPlay
                ? () => launchUrl(
                      Uri.parse(playUrl!),
                      mode: LaunchMode.externalApplication,
                    )
                : null,
            child: Column(
              children: [
                const Icon(
                  Icons.flutter_dash,
                  color: AppColors.flutterBlue,
                  size: 22,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.flagshipLabel,
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navyInk,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.flagshipValue,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bebasNeue(
                    fontSize: 26,
                    color: AppColors.flutterBlue,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: compact ? 12 : 18),
        _OpenToWorkSticky(
          compact: compact,
          reduceMotion: reduceMotion,
          idle: idle,
        ),
      ],
    );
  }
}

class _OpenToWorkSticky extends StatefulWidget {
  const _OpenToWorkSticky({
    required this.compact,
    required this.reduceMotion,
    this.idle,
  });

  final bool compact;
  final bool reduceMotion;
  final IdleTicker? idle;

  @override
  State<_OpenToWorkSticky> createState() => _OpenToWorkStickyState();
}

class _OpenToWorkStickyState extends State<_OpenToWorkSticky> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;

    Widget sticky = MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.compact)
            SizedBox(
              width: 54,
              height: 40,
              child: CustomPaint(painter: CurvedArrowPainter()),
            ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            transformAlignment: Alignment.center,
            transform: Matrix4.rotationZ(
              _hover || widget.reduceMotion ? 0 : 0.08,
            )..setTranslationRaw(0, _hover ? -6.0 : 0, 0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 150,
                  padding: const EdgeInsets.fromLTRB(14, 22, 14, 16),
                  decoration: BoxDecoration(
                    color: zine.sticky,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.navyInk.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(2, 7),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        l10n.teachNote,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.kalam(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          color: AppColors.navyInk,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Icon(
                        Icons.work_outline,
                        color: AppColors.flutterBlue,
                        size: 22,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -8,
                  left: 28,
                  child: TapeStrip(color: zine.tapeAlt, width: 70, height: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!widget.reduceMotion) {
      sticky = sticky
          .animate(delay: 850.ms)
          .fadeIn()
          .slideY(begin: -0.25, end: 0, curve: Curves.easeOutCubic);
    }

    sticky = RepaintBoundary(child: sticky);

    if (widget.idle != null && !widget.reduceMotion) {
      sticky = ListenableBuilder(
        listenable: widget.idle!,
        child: sticky,
        builder: (context, child) {
          final c = widget.idle!.cycle(const Duration(seconds: 4));
          final wiggle = c > 0.85
              ? (c - 0.85) /
                  0.15 *
                  0.06 *
                  ((c * 40).remainder(2) > 1 ? 1 : -1)
              : 0.0;
          return Transform.rotate(angle: wiggle, child: child);
        },
      );
    }

    return sticky;
  }
}

class _HoverCard extends StatefulWidget {
  const _HoverCard({
    required this.child,
    required this.angle,
    required this.delayMs,
    required this.reduceMotion,
    this.idle,
    this.phase = 0,
  });

  final Widget child;
  final double angle;
  final int delayMs;
  final bool reduceMotion;
  final IdleTicker? idle;
  final double phase;

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    Widget card = MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transformAlignment: Alignment.center,
        transform: Matrix4.rotationZ(
          _hover || widget.reduceMotion ? 0 : widget.angle,
        )..setTranslationRaw(0, _hover ? -8.0 : 0, 0),
        child: widget.child,
      ),
    );

    if (!widget.reduceMotion) {
      card = card
          .animate(delay: widget.delayMs.ms)
          .fadeIn()
          .slideY(begin: -0.3, end: 0, curve: Curves.easeOutCubic);
    }

    card = RepaintBoundary(child: card);

    if (widget.idle != null && !widget.reduceMotion) {
      card = IdleFloat(
        ticker: widget.idle!,
        amplitude: 2.2,
        rotationAmp: 0.008,
        period: const Duration(milliseconds: 3000),
        phase: widget.phase,
        child: card,
      );
    }

    return card;
  }
}

class _PaperCard extends StatelessWidget {
  const _PaperCard({
    required this.color,
    required this.tapeColor,
    required this.child,
    this.onTap,
  });

  final Color color;
  final Color tapeColor;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 168,
          padding: const EdgeInsets.fromLTRB(14, 22, 14, 16),
          decoration: BoxDecoration(
            color: color,
            boxShadow: [
              BoxShadow(
                color: AppColors.navyInk.withValues(alpha: 0.18),
                blurRadius: 10,
                offset: const Offset(2, 7),
              ),
            ],
          ),
          child: child,
        ),
        Positioned(
          top: -8,
          left: 36,
          child: TapeStrip(color: tapeColor, width: 72, height: 18),
        ),
      ],
    );

    if (onTap == null) return card;
    return GestureDetector(onTap: onTap, child: card);
  }
}

class _CountUpStat extends StatelessWidget {
  const _CountUpStat({required this.end});

  final int end;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: end.toDouble()),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Text(
          '${value.round()}',
          style: GoogleFonts.bebasNeue(
            fontSize: 42,
            color: AppColors.flutterLightBlue,
            decoration: TextDecoration.none,
          ),
        );
      },
    );
  }
}
