import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/lazy_hover_video.dart';

class CaseMotionSection extends StatefulWidget {
  const CaseMotionSection({
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
  State<CaseMotionSection> createState() => _CaseMotionSectionState();
}

class _CaseMotionSectionState extends State<CaseMotionSection>
    with SingleTickerProviderStateMixin {
  Ticker? _ticker;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (!widget.reduceMotion) {
      _ticker = createTicker((d) {
        setState(() => _elapsed = d);
      })..start();
    }
  }

  @override
  void didUpdateWidget(covariant CaseMotionSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reduceMotion && _ticker != null) {
      _ticker!.stop();
      _ticker!.dispose();
      _ticker = null;
    } else if (!widget.reduceMotion && _ticker == null) {
      _ticker = createTicker((d) {
        setState(() => _elapsed = d);
      })..start();
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final headlineKey = widget.study.motionHeadlineKey;
    if (headlineKey == null) return const SizedBox.shrink();
    final headline = CaseStudyCopy.t(l10n, headlineKey);
    if (isTodo(headline)) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '06',
          eyebrow: l10n.caseSecMotion,
          title: headline,
          intro: '',
          scrollOffset: widget.scrollOffset,
          reduceMotion: widget.reduceMotion,
        ),
        if (widget.study.motionTimings.isNotEmpty) ...[
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final t in widget.study.motionTimings)
                _TimingTicket(
                  timing: t,
                  elapsed: _elapsed,
                  reduceMotion: widget.reduceMotion,
                ),
            ],
          ),
        ],
        if (widget.study.motionVideos.isNotEmpty) ...[
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, c) {
              final narrow = c.maxWidth < 700;
              if (narrow) {
                return Column(
                  children: [
                    for (final card in widget.study.motionVideos) ...[
                      LazyHoverVideo(
                        card: card,
                        scrollOffset: widget.scrollOffset,
                        customCursor: widget.customCursor,
                        aspectRatio: 16 / 10,
                      ),
                      const SizedBox(height: 14),
                    ],
                  ],
                );
              }
              return Row(
                children: [
                  for (var i = 0; i < widget.study.motionVideos.length; i++) ...[
                    if (i > 0) const SizedBox(width: 12),
                    Expanded(
                      child: LazyHoverVideo(
                        card: widget.study.motionVideos[i],
                        scrollOffset: widget.scrollOffset,
                        customCursor: widget.customCursor,
                        aspectRatio: 16 / 10,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
        if (widget.study.respectsReduceMotion) ...[
          const SizedBox(height: 16),
          Text(
            l10n.caseGatherUpReduceMotion,
            style: GoogleFonts.spaceMono(
              fontSize: 11,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w700,
              color: AppColors.flutterLightBlue,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ],
    );
  }
}

class _TimingTicket extends StatelessWidget {
  const _TimingTicket({
    required this.timing,
    required this.elapsed,
    required this.reduceMotion,
  });

  final CaseStudyMotionTiming timing;
  final Duration elapsed;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final period = math.max(timing.durationMs, 1);
    final t = reduceMotion
        ? 0.0
        : (elapsed.inMilliseconds % (period * 4)) / (period * 4);
    final bounce = math.sin(t * math.pi * 2);

    return Container(
      width: 150,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(
          color: AppColors.flutterBlue.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.navyInk.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(1, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CaseStudyCopy.t(l10n, timing.titleKey).toUpperCase(),
            style: GoogleFonts.spaceMono(
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
              color: AppColors.flutterBlue,
              decoration: TextDecoration.none,
            ),
          ),
          Text(
            timing.durationLabel,
            style: GoogleFonts.bebasNeue(
              fontSize: 22,
              color: AppColors.navyInk,
              decoration: TextDecoration.none,
            ),
          ),
          Text(
            CaseStudyCopy.t(l10n, timing.useKey),
            style: GoogleFonts.kalam(
              fontSize: 13,
              color: AppColors.navyInk.withValues(alpha: 0.75),
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 20,
            child: Align(
              alignment: Alignment(bounce, 0),
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.flutterLightBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
