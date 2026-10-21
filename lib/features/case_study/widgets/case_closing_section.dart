import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/project_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/navigation/home_sections.dart';
import 'package:ahmed_rasmy_portfolio/core/utils/asset_checker.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/paper_card.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/safe_asset_image.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_layout.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/scroll_reveal.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/project_image_slot.dart';

/// End-of-study footer: project mark, team note, all studies, next card.
class CaseClosingSection extends StatelessWidget {
  const CaseClosingSection({
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

  void _goAll(BuildContext context) {
    context.go('/');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(const Duration(milliseconds: 80), () {
        HomeSectionKeys.scrollTo(HomeSection.work);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final note = study.closingNoteKey == null
        ? null
        : CaseStudyCopy.t(l10n, study.closingNoteKey!);
    final showNote = note != null && !isTodo(note);
    final next = study.nextSlug == null
        ? null
        : PortfolioData.projectBySlug(study.nextSlug!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ScrollReveal(
          scrollOffset: scrollOffset,
          reduceMotion: reduceMotion,
          child: Column(
            children: [
              _ClosingIcon(asset: study.closingIconAsset),
              if (showNote) ...[
                const SizedBox(height: 16),
                Text(
                  note,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: GoogleFonts.kalam(
                    fontSize: 18,
                    height: 1.35,
                    color: zine.ink,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              CursorTarget(
                enabled: customCursor,
                child: TextButton(
                  onPressed: () => _goAll(context),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.flutterLightBlue,
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    l10n.caseAllStudies,
                    style: GoogleFonts.spaceMono(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (next != null) ...[
          const SizedBox(height: 40),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              l10n.caseNextLabel.toUpperCase(),
              style: GoogleFonts.spaceMono(
                fontSize: 11,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
                color: zine.inkMuted,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
          ScrollReveal(
            scrollOffset: scrollOffset,
            reduceMotion: reduceMotion,
            delayFraction: 0.08,
            child: CursorTarget(
              enabled: customCursor,
              child: PaperCard(
                tilt: 0.015,
                maxTilt: CaseLayout.isNarrow(
                        MediaQuery.sizeOf(context).width)
                    ? CaseLayout.narrowTilt
                    : null,
                onTap: next.hasCaseStudy
                    ? () => context.go('/work/${next.slug}')
                    : null,
                child: LayoutBuilder(
                  builder: (context, c) {
                    final stack = c.maxWidth < CaseLayout.stackBreakpoint;
                    final title = ProjectCopy.title(l10n, next);
                    final tagline = ProjectCopy.tagline(l10n, next);
                    final image = ProjectImageSlot(
                      assetPath: next.heroImagePath,
                      label: title,
                      aspectRatio: 16 / 10,
                    );
                    final text = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          softWrap: true,
                          style: GoogleFonts.bebasNeue(
                            fontSize: 28,
                            color: AppColors.navyInk,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        if (!isTodo(tagline)) ...[
                          const SizedBox(height: 6),
                          Text(
                            tagline,
                            softWrap: true,
                            style: GoogleFonts.kalam(
                              fontSize: 15,
                              color:
                                  AppColors.navyInk.withValues(alpha: 0.8),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                        if (!next.hasCaseStudy) ...[
                          const SizedBox(height: 10),
                          Text(
                            l10n.caseComingSoon,
                            softWrap: true,
                            style: GoogleFonts.spaceMono(
                              fontSize: 11,
                              color: AppColors.flutterBlue,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ],
                    );
                    if (stack) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          image,
                          const SizedBox(height: 14),
                          text,
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: image),
                        const SizedBox(width: 20),
                        Expanded(flex: 6, child: text),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ClosingIcon extends StatelessWidget {
  const _ClosingIcon({this.asset});

  final String? asset;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.flutterBlue.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.flutterLightBlue, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        'G',
        style: GoogleFonts.bebasNeue(
          fontSize: 36,
          color: AppColors.flutterLightBlue,
          decoration: TextDecoration.none,
        ),
      ),
    );

    final path = asset;
    if (path == null || isTodo(path) || !AssetChecker.has(path)) {
      return fallback;
    }

    return ClipOval(
      child: SafeAssetImage(
        assetPath: path,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        showDebugPlaceholder: false,
        fallback: fallback,
      ),
    );
  }
}
