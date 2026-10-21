import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/paper_card.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_layout.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/scroll_reveal.dart';

class CaseCodeSection extends StatefulWidget {
  const CaseCodeSection({
    super.key,
    required this.study,
    required this.scrollOffset,
    this.reduceMotion = false,
    this.customCursor = false,
  });

  final CaseStudy study;
  final ValueNotifier<double> scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  State<CaseCodeSection> createState() => _CaseCodeSectionState();
}

class _CaseCodeSectionState extends State<CaseCodeSection> {
  double _arrowProgress = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollOffset.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    widget.scrollOffset.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    if (widget.reduceMotion) {
      if (_arrowProgress != 1) setState(() => _arrowProgress = 1);
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final viewH = MediaQuery.sizeOf(context).height;
    final p = ((viewH * 0.85 - top) / (viewH * 0.5)).clamp(0.0, 1.0);
    if ((p - _arrowProgress).abs() > 0.02) {
      setState(() => _arrowProgress = p);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final headlineKey = widget.study.codeHeadlineKey;
    if (headlineKey == null) return const SizedBox.shrink();
    final headline = CaseStudyCopy.t(l10n, headlineKey);
    if (isTodo(headline)) return const SizedBox.shrink();

    final steps = widget.study.codeSteps.where((s) {
      final body = CaseStudyCopy.t(l10n, s.bodyKey);
      return !isTodo(body);
    }).toList();

    final closing = widget.study.codeClosingKey == null
        ? null
        : CaseStudyCopy.t(l10n, widget.study.codeClosingKey!);
    final showClosing = closing != null && !isTodo(closing);

    if (steps.isEmpty && !showClosing) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '07',
          eyebrow: l10n.caseSecCode,
          title: headline,
          intro: '',
          scrollOffset: widget.scrollOffset,
          reduceMotion: widget.reduceMotion,
        ),
        if (steps.isNotEmpty) ...[
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, c) {
              final narrow = c.maxWidth < CaseLayout.stackBreakpoint;
              if (narrow) {
                return Column(
                  children: [
                    for (var i = 0; i < steps.length; i++) ...[
                      if (i > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: CustomPaint(
                            size: const Size(24, 32),
                            painter: _DownArrowPainter(
                              progress: ((_arrowProgress - i * 0.2) / 0.3)
                                  .clamp(0.0, 1.0),
                            ),
                          ),
                        ),
                      ScrollReveal(
                        scrollOffset: widget.scrollOffset,
                        reduceMotion: widget.reduceMotion,
                        delayFraction: i * 0.1,
                        child: _StepCard(step: steps[i]),
                      ),
                    ],
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < steps.length; i++) ...[
                    if (i > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 48, left: 6, right: 6),
                        child: CustomPaint(
                          size: const Size(36, 16),
                          painter: _SideArrowPainter(
                            progress: ((_arrowProgress - i * 0.2) / 0.3)
                                .clamp(0.0, 1.0),
                          ),
                        ),
                      ),
                    Expanded(
                      child: ScrollReveal(
                        scrollOffset: widget.scrollOffset,
                        reduceMotion: widget.reduceMotion,
                        delayFraction: i * 0.1,
                        child: _StepCard(step: steps[i]),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
        if (showClosing) ...[
          const SizedBox(height: 24),
          Text(
            closing,
            softWrap: true,
            style: GoogleFonts.kalam(
              fontSize: 16,
              color: context.zine.inkMuted,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.step});

  final CaseStudyCodeStep step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final width = MediaQuery.sizeOf(context).width;

    return PaperCard(
      tilt: 0.01,
      maxTilt: CaseLayout.isNarrow(width) ? CaseLayout.narrowTilt : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CaseStudyCopy.t(l10n, step.titleKey),
            softWrap: true,
            style: GoogleFonts.bebasNeue(
              fontSize: 22,
              color: AppColors.navyInk,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            CaseStudyCopy.t(l10n, step.bodyKey),
            softWrap: true,
            style: GoogleFonts.kalam(
              fontSize: 14,
              height: 1.4,
              color: AppColors.navyInk.withValues(alpha: 0.85),
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}

class _SideArrowPainter extends CustomPainter {
  _SideArrowPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final paint = Paint()
      ..color = AppColors.flutterLightBlue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final x = size.width * progress;
    canvas.drawLine(Offset(0, size.height / 2), Offset(x, size.height / 2), paint);
    if (progress > 0.7) {
      final tip = Offset(size.width, size.height / 2);
      canvas.drawLine(tip, tip + const Offset(-8, -5), paint);
      canvas.drawLine(tip, tip + const Offset(-8, 5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SideArrowPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _DownArrowPainter extends CustomPainter {
  _DownArrowPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final paint = Paint()
      ..color = AppColors.flutterLightBlue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final y = size.height * progress;
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, y), paint);
    if (progress > 0.7) {
      final tip = Offset(size.width / 2, size.height);
      canvas.drawLine(tip, tip + const Offset(-5, -8), paint);
      canvas.drawLine(tip, tip + const Offset(5, -8), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DownArrowPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
