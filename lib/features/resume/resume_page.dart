import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/asset_paths.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/experience_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/project_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/skill_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/utils/download_file.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/paper_card.dart';

class ResumePage extends StatelessWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final edu = PortfolioData.education;

    return Scaffold(
      backgroundColor: zine.canvas,
      appBar: AppBar(
        backgroundColor: zine.canvas,
        foregroundColor: zine.ink,
        elevation: 0,
        title: Text(
          l10n.navResume,
          style: GoogleFonts.spaceMono(
            fontSize: 13,
            letterSpacing: 1.2,
            decoration: TextDecoration.none,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 48),
            children: [
              PaperCard(
                tilt: -0.008,
                tapeColor: AppColors.flutterLightBlue.withValues(alpha: 0.85),
                padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      PortfolioData.fullName,
                      style: GoogleFonts.bebasNeue(
                        fontSize: 40,
                        letterSpacing: 1.4,
                        color: AppColors.navyInk,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      l10n.resumeHeadline,
                      style: GoogleFonts.spaceMono(
                        fontSize: 13,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w700,
                        color: AppColors.flutterBlue,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${PortfolioData.location}  ·  ${PortfolioData.email}  ·  ${PortfolioData.phone}',
                      style: GoogleFonts.spaceMono(
                        fontSize: 11,
                        color: AppColors.navyInk.withValues(alpha: 0.7),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.resumeIntro,
                      style: (isAr
                              ? GoogleFonts.cairo(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: AppColors.navyInk,
                                )
                              : GoogleFonts.kalam(
                                  fontSize: 16,
                                  height: 1.45,
                                  color: AppColors.navyInk,
                                ))
                          .copyWith(decoration: TextDecoration.none),
                    ),
                    const SizedBox(height: 22),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: FilledButton.icon(
                        onPressed: () => downloadAssetFile(
                          assetPath: AssetPaths.resumePdf,
                          fileName: AssetPaths.resumePdfFileName,
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.flutterBlue,
                          foregroundColor: AppColors.offWhite,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          shape: const RoundedRectangleBorder(),
                        ),
                        icon: const Icon(Icons.download_rounded, size: 18),
                        label: Text(
                          l10n.resumeDownload,
                          style: GoogleFonts.spaceMono(
                            fontSize: 12,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _SectionLabel(l10n.resumeSummaryTitle),
                    const SizedBox(height: 16),
                    _SectionLabel(l10n.resumeExperienceHeading),
                    const SizedBox(height: 10),
                    for (final exp in PortfolioData.experiences) ...[
                      Text(
                        '${ExperienceCopy.role(l10n, exp)} — ${ExperienceCopy.company(l10n, exp)}',
                        style: GoogleFonts.spaceMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navyInk,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Text(
                        ExperienceCopy.dateRange(l10n, exp),
                        style: GoogleFonts.spaceMono(
                          fontSize: 11,
                          color: AppColors.flutterBlue,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 6),
                      for (final key in exp.bulletKeys)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4, left: 8),
                          child: Text(
                            '• ${ExperienceCopy.bullet(l10n, key)}',
                            style: (isAr
                                    ? GoogleFonts.cairo(
                                        fontSize: 13,
                                        height: 1.4,
                                        color: AppColors.navyInk
                                            .withValues(alpha: 0.85),
                                      )
                                    : GoogleFonts.kalam(
                                        fontSize: 14,
                                        height: 1.35,
                                        color: AppColors.navyInk
                                            .withValues(alpha: 0.85),
                                      ))
                                .copyWith(decoration: TextDecoration.none),
                          ),
                        ),
                      const SizedBox(height: 14),
                    ],
                    _SectionLabel(l10n.resumeEducationHeading),
                    const SizedBox(height: 8),
                    Text(
                      l10n.eduDegree,
                      style: GoogleFonts.spaceMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navyInk,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      '${l10n.eduSchool}  ·  ${edu.start} — ${edu.end}',
                      style: GoogleFonts.spaceMono(
                        fontSize: 11,
                        color: AppColors.flutterBlue,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      '${l10n.eduGrade}  ·  ${l10n.eduProject}',
                      style: GoogleFonts.kalam(
                        fontSize: 14,
                        color: AppColors.navyInk.withValues(alpha: 0.85),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _SectionLabel(l10n.resumeSkillsHeading),
                    const SizedBox(height: 8),
                    for (final g in PortfolioData.skillGroups)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${SkillCopy.groupTitle(l10n, g)}: ',
                                style: GoogleFonts.spaceMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.flutterBlue,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text: g.items.join(' · '),
                                style: GoogleFonts.spaceMono(
                                  fontSize: 11,
                                  color: AppColors.navyInk,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    _SectionLabel(l10n.resumeProjectsHeading),
                    const SizedBox(height: 8),
                    for (final p in PortfolioData.projects)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '${ProjectCopy.title(l10n, p)} — ${ProjectCopy.tagline(l10n, p)}',
                          style: GoogleFonts.kalam(
                            fontSize: 14,
                            color: AppColors.navyInk,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.spaceMono(
        fontSize: 11,
        letterSpacing: 1.8,
        fontWeight: FontWeight.w700,
        color: AppColors.flutterLightBlue,
        decoration: TextDecoration.none,
      ),
    );
  }
}
