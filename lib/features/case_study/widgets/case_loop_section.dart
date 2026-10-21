import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/paper_card.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';

class CaseLoopSection extends StatefulWidget {
  const CaseLoopSection({
    super.key,
    required this.study,
    this.scrollOffset,
    this.reduceMotion = false,
    this.customCursor = false,
  });

  final CaseStudy study;
  final ValueNotifier<double>? scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  State<CaseLoopSection> createState() => _CaseLoopSectionState();
}

class _CaseLoopSectionState extends State<CaseLoopSection> {
  int _selected = 0;
  double _pathProgress = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollOffset?.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    widget.scrollOffset?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    if (widget.reduceMotion) {
      if (_pathProgress != 1) setState(() => _pathProgress = 1);
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final viewH = MediaQuery.sizeOf(context).height;
    final p = ((viewH * 0.85 - top) / (viewH * 0.55)).clamp(0.0, 1.0);
    if ((p - _pathProgress).abs() > 0.02) {
      setState(() => _pathProgress = p);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final headlineKey = widget.study.productHeadlineKey;
    if (headlineKey == null || widget.study.loopSteps.isEmpty) {
      return const SizedBox.shrink();
    }
    final headline = CaseStudyCopy.t(l10n, headlineKey);
    if (isTodo(headline)) return const SizedBox.shrink();

    final steps = widget.study.loopSteps;
    final selected = steps[_selected.clamp(0, steps.length - 1)];
    final detail = CaseStudyCopy.t(l10n, selected.detailKey);
    final showDetail = !isTodo(detail);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '02',
          eyebrow: l10n.caseSecProductEyebrow,
          title: headline,
          intro: '',
          scrollOffset: widget.scrollOffset,
          reduceMotion: widget.reduceMotion,
        ),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, c) {
            final mobile = c.maxWidth < 640;
            final h = mobile ? 280.0 : 200.0;
            return SizedBox(
              height: h,
              width: double.infinity,
              child: CustomPaint(
                painter: _LoopPathPainter(
                  progress: _pathProgress,
                  count: steps.length,
                  mobile: mobile,
                ),
                child: mobile
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (var i = 0; i < steps.length; i++)
                            _LoopNode(
                              index: i,
                              title: CaseStudyCopy.t(l10n, steps[i].titleKey),
                              selected: _selected == i,
                              customCursor: widget.customCursor,
                              onTap: () => setState(() => _selected = i),
                            ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (var i = 0; i < steps.length; i++)
                            _LoopNode(
                              index: i,
                              title: CaseStudyCopy.t(l10n, steps[i].titleKey),
                              selected: _selected == i,
                              customCursor: widget.customCursor,
                              onTap: () => setState(() => _selected = i),
                            ),
                        ],
                      ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: showDetail
              ? PaperCard(
                  key: ValueKey(_selected),
                  tilt: 0.01,
                  tapeColor:
                      AppColors.flutterLightBlue.withValues(alpha: 0.8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        CaseStudyCopy.t(l10n, selected.titleKey).toUpperCase(),
                        style: GoogleFonts.spaceMono(
                          fontSize: 11,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w700,
                          color: AppColors.flutterBlue,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        detail,
                        style: GoogleFonts.kalam(
                          fontSize: 16,
                          color: AppColors.navyInk,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ],
    );
  }
}

class _LoopNode extends StatelessWidget {
  const _LoopNode({
    required this.index,
    required this.title,
    required this.selected,
    required this.onTap,
    required this.customCursor,
  });

  final int index;
  final String title;
  final bool selected;
  final VoidCallback onTap;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    return CursorTarget(
      enabled: customCursor,
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          onEnter: (_) => onTap(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: selected ? 88 : 76,
            height: selected ? 88 : 76,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected
                  ? AppColors.flutterBlue
                  : AppColors.paper.withValues(alpha: 0.95),
              border: Border.all(
                color: AppColors.flutterLightBlue
                    .withValues(alpha: selected ? 0.9 : 0.45),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.navyInk
                      .withValues(alpha: selected ? 0.25 : 0.12),
                  blurRadius: selected ? 14 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${index + 1}'.padLeft(2, '0'),
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? AppColors.offWhite.withValues(alpha: 0.7)
                        : AppColors.flutterBlue,
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bebasNeue(
                    fontSize: 16,
                    color: selected ? AppColors.offWhite : AppColors.navyInk,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoopPathPainter extends CustomPainter {
  _LoopPathPainter({
    required this.progress,
    required this.count,
    required this.mobile,
  });

  final double progress;
  final int count;
  final bool mobile;

  @override
  void paint(Canvas canvas, Size size) {
    if (count < 2) return;
    final paint = Paint()
      ..color = AppColors.flutterLightBlue.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (mobile) {
      final cx = size.width / 2;
      for (var i = 0; i < count; i++) {
        final y = size.height * ((i + 0.5) / count);
        if (i == 0) {
          path.moveTo(cx, y);
        } else {
          final prevY = size.height * ((i - 0.5) / count);
          path.quadraticBezierTo(
            cx + (i.isEven ? 40 : -40),
            (prevY + y) / 2,
            cx,
            y,
          );
        }
      }
    } else {
      final cy = size.height / 2;
      for (var i = 0; i < count; i++) {
        final x = size.width * ((i + 0.5) / count);
        if (i == 0) {
          path.moveTo(x, cy);
        } else {
          final prevX = size.width * ((i - 0.5) / count);
          path.quadraticBezierTo(
            (prevX + x) / 2,
            cy + math.sin(i.toDouble()) * 28,
            x,
            cy,
          );
        }
      }
    }

    for (final metric in path.computeMetrics()) {
      final extract = metric.extractPath(0, metric.length * progress);
      _drawDashed(canvas, extract, paint);
    }
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dash = 8.0;
      const gap = 6.0;
      while (distance < metric.length) {
        final next = math.min(distance + dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LoopPathPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.count != count ||
      oldDelegate.mobile != mobile;
}
