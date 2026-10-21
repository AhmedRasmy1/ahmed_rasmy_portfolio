import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/paper_card.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_layout.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_story_strip.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/scroll_reveal.dart';

class CaseProblemSection extends StatelessWidget {
  const CaseProblemSection({
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final headlineKey = study.problemHeadlineKey;
    if (headlineKey == null) return const SizedBox.shrink();
    final headline = CaseStudyCopy.t(l10n, headlineKey);
    if (isTodo(headline)) return const SizedBox.shrink();

    final typical = study.compareTypical;
    final gather = study.compareGatherUp;
    final width = MediaQuery.sizeOf(context).width;
    final stack = width < CaseLayout.stackBreakpoint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '01',
          eyebrow: l10n.caseSecProblem,
          title: headline,
          intro: '',
          scrollOffset: scrollOffset,
          reduceMotion: reduceMotion,
        ),
        if (typical != null && gather != null) ...[
          const SizedBox(height: 28),
          if (stack)
            Column(
              children: [
                _CompareCard(
                  side: typical,
                  scrollOffset: scrollOffset,
                  reduceMotion: reduceMotion,
                  customCursor: customCursor,
                  maxTilt: CaseLayout.narrowTilt,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: _VsSticker(label: l10n.caseGatherUpVs),
                ),
                _CompareCard(
                  side: gather,
                  scrollOffset: scrollOffset,
                  reduceMotion: reduceMotion,
                  customCursor: customCursor,
                  maxTilt: CaseLayout.narrowTilt,
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _CompareCard(
                    side: typical,
                    scrollOffset: scrollOffset,
                    reduceMotion: reduceMotion,
                    customCursor: customCursor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 48,
                  ),
                  child: _VsSticker(label: l10n.caseGatherUpVs),
                ),
                Expanded(
                  child: _CompareCard(
                    side: gather,
                    scrollOffset: scrollOffset,
                    reduceMotion: reduceMotion,
                    customCursor: customCursor,
                  ),
                ),
              ],
            ),
        ],
        if (study.storyPanels.isNotEmpty) ...[
          const SizedBox(height: 40),
          CaseStoryStrip(
            study: study,
            customCursor: customCursor,
            reduceMotion: reduceMotion,
          ),
        ],
      ],
    );
  }
}

class _VsSticker extends StatelessWidget {
  const _VsSticker({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.12,
      child: Container(
        width: 56,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.flutterLightBlue.withValues(alpha: 0.15),
          border: Border.all(color: AppColors.flutterBlue, width: 2),
        ),
        child: Text(
          label,
          style: GoogleFonts.permanentMarker(
            fontSize: 18,
            color: AppColors.flutterBlue,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

class _CompareCard extends StatelessWidget {
  const _CompareCard({
    required this.side,
    this.scrollOffset,
    this.reduceMotion = false,
    this.customCursor = false,
    this.maxTilt,
  });

  final CaseStudyCompareSide side;
  final ValueNotifier<double>? scrollOffset;
  final bool reduceMotion;
  final bool customCursor;
  final double? maxTilt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = CaseStudyCopy.t(l10n, side.titleKey);
    final caption = CaseStudyCopy.t(l10n, side.captionKey);
    final narrow = CaseLayout.isNarrow(MediaQuery.sizeOf(context).width);

    return CursorTarget(
      enabled: customCursor,
      child: PaperCard(
        tilt: side.accentTape ? 0.015 : -0.015,
        maxTilt: maxTilt,
        padding: EdgeInsets.fromLTRB(
          narrow ? 12 : 16,
          narrow ? 22 : 28,
          narrow ? 12 : 16,
          narrow ? 14 : 18,
        ),
        tapeColor: side.accentTape
            ? AppColors.flutterLightBlue.withValues(alpha: 0.85)
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              softWrap: true,
              style: GoogleFonts.bebasNeue(
                fontSize: 24,
                color: AppColors.navyInk,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 14),
            for (var i = 0; i < side.stepKeys.length; i++)
              ScrollReveal(
                scrollOffset: scrollOffset,
                reduceMotion: reduceMotion,
                delayFraction: i * 0.15,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: side.accentTape
                                ? AppColors.flutterLightBlue
                                : AppColors.flutterBlue
                                    .withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          CaseStudyCopy.t(l10n, side.stepKeys[i]),
                          softWrap: true,
                          style: GoogleFonts.spaceMono(
                            fontSize: 13,
                            letterSpacing: 0.6,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navyInk,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              caption,
              softWrap: true,
              style: GoogleFonts.kalam(
                fontSize: 14,
                color: AppColors.navyInk.withValues(alpha: 0.7),
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
