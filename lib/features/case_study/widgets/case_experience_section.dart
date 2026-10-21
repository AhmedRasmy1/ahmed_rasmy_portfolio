import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';
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

    final mobile = MediaQuery.sizeOf(context).width < 700;

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
        if (mobile)
          SizedBox(
            height: 360,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: study.experienceCards.length,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (_, i) => SizedBox(
                width: 160,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < study.experienceCards.length; i++) ...[
                if (i > 0) const SizedBox(width: 16),
                Expanded(
                  child: LazyHoverVideo(
                    card: study.experienceCards[i],
                    scrollOffset: scrollOffset,
                    phoneFrame: true,
                    customCursor: customCursor,
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }
}
