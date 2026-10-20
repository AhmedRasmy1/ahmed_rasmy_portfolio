import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';

/// Resolves project ARB keys for the active locale.
abstract final class ProjectCopy {
  static String title(AppLocalizations l10n, Project p) => switch (p.titleKey) {
        'projGatherUpTitle' => l10n.projGatherUpTitle,
        'projAwwaabTitle' => l10n.projAwwaabTitle,
        'projElmohandesTitle' => l10n.projElmohandesTitle,
        'projFloweryTitle' => l10n.projFloweryTitle,
        'projServiceXTitle' => l10n.projServiceXTitle,
        _ => p.titleKey,
      };

  static String tagline(AppLocalizations l10n, Project p) =>
      switch (p.taglineKey) {
        'projGatherUpTagline' => l10n.projGatherUpTagline,
        'projAwwaabTagline' => l10n.projAwwaabTagline,
        'projElmohandesTagline' => l10n.projElmohandesTagline,
        'projFloweryTagline' => l10n.projFloweryTagline,
        'projServiceXTagline' => l10n.projServiceXTagline,
        _ => p.taglineKey,
      };

  static String summary(AppLocalizations l10n, Project p) =>
      switch (p.summaryKey) {
        'projGatherUpSummary' => l10n.projGatherUpSummary,
        'projAwwaabSummary' => l10n.projAwwaabSummary,
        'projElmohandesSummary' => l10n.projElmohandesSummary,
        'projFlowerySummary' => l10n.projFlowerySummary,
        'projServiceXSummary' => l10n.projServiceXSummary,
        _ => p.summaryKey,
      };

  static String platformLabel(AppLocalizations l10n, String platform) {
    final p = platform.toLowerCase();
    if (p.contains('android')) return l10n.platformAndroid;
    if (p.contains('ios')) return l10n.platformIos;
    if (p.contains('desktop')) return l10n.platformDesktop;
    if (p.contains('web')) return l10n.platformWeb;
    if (p.contains('mobile')) return l10n.platformMobile;
    return platform;
  }
}
