import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/paper_card.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_layout.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/lazy_hover_video.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/scroll_reveal.dart';

class CaseSystemSection extends StatelessWidget {
  const CaseSystemSection({
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

  Color? _parseHex(String hex) {
    var h = hex.replaceAll('#', '');
    if (h.length == 6) h = 'FF$h';
    final v = int.tryParse(h, radix: 16);
    return v == null ? null : Color(v);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final headlineKey = study.systemHeadlineKey;
    if (headlineKey == null) return const SizedBox.shrink();
    final headline = CaseStudyCopy.t(l10n, headlineKey);
    if (isTodo(headline)) return const SizedBox.shrink();

    final credit = study.systemCreditKey == null
        ? null
        : CaseStudyCopy.t(l10n, study.systemCreditKey!);
    final zine = context.zine;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '05',
          eyebrow: l10n.caseSecSystem,
          title: headline,
          intro: '',
          scrollOffset: scrollOffset,
          reduceMotion: reduceMotion,
        ),
        if (credit != null && !isTodo(credit)) ...[
          const SizedBox(height: 8),
          Text(
            credit,
            style: GoogleFonts.spaceMono(
              fontSize: 11,
              letterSpacing: 0.8,
              color: zine.inkMuted,
              decoration: TextDecoration.none,
            ),
          ),
        ],
        if (study.designTiers.isNotEmpty) ...[
          const SizedBox(height: 24),
          for (var i = 0; i < study.designTiers.length; i++)
            ScrollReveal(
              scrollOffset: scrollOffset,
              reduceMotion: reduceMotion,
              delayFraction: i * 0.12,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PaperCard(
                  tilt: ((i % 2 == 0) ? -1 : 1) * 0.01,
                  maxTilt: CaseLayout.isNarrow(
                          MediaQuery.sizeOf(context).width)
                      ? CaseLayout.narrowTilt
                      : null,
                  padding: const EdgeInsets.fromLTRB(14, 22, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        CaseStudyCopy.t(l10n, study.designTiers[i].titleKey),
                        softWrap: true,
                        style: GoogleFonts.bebasNeue(
                          fontSize: 20,
                          color: AppColors.navyInk,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final chip in study.designTiers[i].chipKeys)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.flutterBlue
                                      .withValues(alpha: 0.35),
                                ),
                              ),
                              child: Text(
                                CaseStudyCopy.t(l10n, chip),
                                softWrap: true,
                                style: GoogleFonts.spaceMono(
                                  fontSize: 9,
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navyInk,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
        if (study.colorSwatches.isNotEmpty) ...[
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, c) {
              final w = MediaQuery.sizeOf(context).width;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (var i = 0; i < study.colorSwatches.length; i++)
                    Transform.rotate(
                      angle: CaseLayout.tilt(
                        ((i % 2 == 0) ? -1 : 1) * 0.04,
                        width: w,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: c.maxWidth < CaseLayout.stackBreakpoint
                              ? (c.maxWidth - 12) / 2
                              : 120,
                          minWidth: 96,
                        ),
                        child: Container(
                          width: 120,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.paper,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.navyInk
                                    .withValues(alpha: 0.16),
                                blurRadius: 8,
                                offset: const Offset(1, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 48,
                                width: double.infinity,
                                color: _parseHex(
                                        study.colorSwatches[i].hex) ??
                                    AppColors.flutterBlue,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                CaseStudyCopy.t(
                                  l10n,
                                  study.colorSwatches[i].labelKey,
                                ),
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.kalam(
                                  fontSize: 13,
                                  color: AppColors.navyInk,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Text(
                                study.colorSwatches[i].hex,
                                softWrap: true,
                                style: GoogleFonts.spaceMono(
                                  fontSize: 10,
                                  color: AppColors.flutterBlue,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
        if (study.themeMedia.isNotEmpty) ...[
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, c) {
              final stack = c.maxWidth < CaseLayout.stackBreakpoint;
              final cards = study.themeMedia;
              if (stack) {
                return CaseSnapGallery(
                  height: 220,
                  viewportFraction: 0.88,
                  itemCount: cards.length,
                  itemBuilder: (_, i) => LazyHoverVideo(
                    card: cards[i],
                    scrollOffset: scrollOffset,
                    customCursor: customCursor,
                    aspectRatio: 16 / 10,
                  ),
                );
              }
              return Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  for (final card in cards)
                    SizedBox(
                      width: (c.maxWidth - 14) / 2,
                      child: LazyHoverVideo(
                        card: card,
                        scrollOffset: scrollOffset,
                        customCursor: customCursor,
                        aspectRatio: 16 / 10,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
        if (study.typeSpecimens.isNotEmpty) ...[
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, c) {
              final stack = c.maxWidth < CaseLayout.stackBreakpoint;
              if (stack) {
                return Column(
                  children: [
                    for (var i = 0; i < study.typeSpecimens.length; i++) ...[
                      if (i > 0) const SizedBox(height: 14),
                      _TypeCard(specimen: study.typeSpecimens[i]),
                    ],
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < study.typeSpecimens.length; i++) ...[
                    if (i > 0) const SizedBox(width: 14),
                    Expanded(
                      child: _TypeCard(specimen: study.typeSpecimens[i]),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
        if (study.componentCards.isNotEmpty) ...[
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, c) {
              final stack = c.maxWidth < CaseLayout.stackBreakpoint;
              if (stack) {
                return CaseSnapGallery(
                  height: 220,
                  viewportFraction: 0.88,
                  itemCount: study.componentCards.length,
                  itemBuilder: (_, i) => LazyHoverVideo(
                    card: study.componentCards[i],
                    scrollOffset: scrollOffset,
                    customCursor: customCursor,
                    aspectRatio: 16 / 10,
                  ),
                );
              }
              return Row(
                children: [
                  for (var i = 0; i < study.componentCards.length; i++) ...[
                    if (i > 0) const SizedBox(width: 14),
                    Expanded(
                      child: LazyHoverVideo(
                        card: study.componentCards[i],
                        scrollOffset: scrollOffset,
                        customCursor: customCursor,
                        aspectRatio: 16 / 10,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ],
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({required this.specimen});

  final CaseStudyTypeSpecimen specimen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = CaseStudyCopy.t(l10n, specimen.labelKey);
    final sample = CaseStudyCopy.t(l10n, specimen.sampleKey);
    if (isTodo(sample)) return const SizedBox.shrink();

    final width = MediaQuery.sizeOf(context).width;

    return Directionality(
      textDirection: specimen.rtl ? TextDirection.rtl : TextDirection.ltr,
      child: PaperCard(
        tilt: specimen.rtl ? 0.015 : -0.015,
        maxTilt:
            CaseLayout.isNarrow(width) ? CaseLayout.narrowTilt : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              softWrap: true,
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
                color: AppColors.flutterBlue,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              sample,
              softWrap: true,
              style: specimen.rtl
                  ? GoogleFonts.reemKufi(
                      fontSize: 22,
                      height: 1.35,
                      color: AppColors.navyInk,
                      decoration: TextDecoration.none,
                    )
                  : GoogleFonts.bebasNeue(
                      fontSize: 26,
                      height: 1.2,
                      color: AppColors.navyInk,
                      decoration: TextDecoration.none,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
