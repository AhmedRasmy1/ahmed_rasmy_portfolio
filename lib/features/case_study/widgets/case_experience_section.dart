import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_layout.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/lazy_hover_video.dart';

class CaseExperienceSection extends StatelessWidget {
  const CaseExperienceSection({
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final headlineKey = study.experienceHeadlineKey;
    if (headlineKey == null || study.experienceCards.isEmpty) {
      return const SizedBox.shrink();
    }
    final headline = CaseStudyCopy.t(l10n, headlineKey);
    if (isTodo(headline)) return const SizedBox.shrink();

    final width = MediaQuery.sizeOf(context).width;
    final useSnap = width < CaseLayout.mobileBreakpoint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '04',
          eyebrow: l10n.caseSecExperience,
          title: headline,
          intro: '',
          scrollOffset: scrollOffset,
          reduceMotion: reduceMotion,
        ),
        const SizedBox(height: 28),
        if (useSnap)
          CaseSnapGallery(
            height: width < CaseLayout.stackBreakpoint ? 380 : 400,
            viewportFraction:
                width < CaseLayout.stackBreakpoint ? 0.58 : 0.38,
            itemCount: study.experienceCards.length,
            itemBuilder: (_, i) => Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: LazyHoverVideo(
                  card: study.experienceCards[i],
                  scrollOffset: scrollOffset,
                  phoneFrame: true,
                  customCursor: customCursor,
                ),
              ),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, c) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < study.experienceCards.length; i++) ...[
                    if (i > 0) const SizedBox(width: 16),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: c.maxWidth / study.experienceCards.length,
                        ),
                        child: LazyHoverVideo(
                          card: study.experienceCards[i],
                          scrollOffset: scrollOffset,
                          phoneFrame: true,
                          customCursor: customCursor,
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
      ],
    );
  }
}
