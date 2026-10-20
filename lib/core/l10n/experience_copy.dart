import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';

/// Resolves experience ARB keys for the active locale.
abstract final class ExperienceCopy {
  static String role(AppLocalizations l10n, Experience e) =>
      switch (e.roleKey) {
        'expGatherUpRole' => l10n.expGatherUpRole,
        'expCenterlyRole' => l10n.expCenterlyRole,
        'expElevateRole' => l10n.expElevateRole,
        _ => e.roleKey,
      };

  static String company(AppLocalizations l10n, Experience e) =>
      switch (e.companyKey) {
        'expGatherUpCompany' => l10n.expGatherUpCompany,
        'expCenterlyCompany' => l10n.expCenterlyCompany,
        'expElevateCompany' => l10n.expElevateCompany,
        _ => e.companyKey,
      };

  static String bullet(AppLocalizations l10n, String key) => switch (key) {
        'expGatherUpB1' => l10n.expGatherUpB1,
        'expGatherUpB2' => l10n.expGatherUpB2,
        'expGatherUpB3' => l10n.expGatherUpB3,
        'expGatherUpB4' => l10n.expGatherUpB4,
        'expCenterlyB1' => l10n.expCenterlyB1,
        'expCenterlyB2' => l10n.expCenterlyB2,
        'expCenterlyB3' => l10n.expCenterlyB3,
        'expElevateB1' => l10n.expElevateB1,
        'expElevateB2' => l10n.expElevateB2,
        'expElevateB3' => l10n.expElevateB3,
        _ => key,
      };

  static String dateRange(AppLocalizations l10n, Experience e) {
    final end = e.end ?? l10n.expPresent;
    return '${e.start} — $end';
  }
}
