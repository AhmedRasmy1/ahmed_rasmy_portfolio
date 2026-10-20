import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
// zine extension via app_colors

/// Placeholder case-study route — content filled in a later step.
class CaseStudyPage extends StatelessWidget {
  const CaseStudyPage({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final project = PortfolioData.projectBySlug(slug);

    return Scaffold(
      backgroundColor: zine.canvas,
      appBar: AppBar(
        backgroundColor: zine.canvas,
        foregroundColor: zine.ink,
        title: Text(
          project == null ? slug : _title(l10n, project.titleKey),
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.sectionPlaceholder,
            textAlign: TextAlign.center,
            style: GoogleFonts.kalam(
              fontSize: 18,
              color: zine.inkMuted,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }

  static String _title(AppLocalizations l10n, String key) {
    return switch (key) {
      'projGatherUpTitle' => l10n.projGatherUpTitle,
      'projAwwaabTitle' => l10n.projAwwaabTitle,
      'projElmohandesTitle' => l10n.projElmohandesTitle,
      'projFloweryTitle' => l10n.projFloweryTitle,
      'projServiceXTitle' => l10n.projServiceXTitle,
      _ => key,
    };
  }
}
