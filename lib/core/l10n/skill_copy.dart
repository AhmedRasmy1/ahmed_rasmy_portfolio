import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';

abstract final class SkillCopy {
  static String groupTitle(AppLocalizations l10n, SkillGroup g) =>
      switch (g.titleKey) {
        'skillCoreTitle' => l10n.skillCoreTitle,
        'skillApiTitle' => l10n.skillApiTitle,
        'skillStorageTitle' => l10n.skillStorageTitle,
        'skillUiTitle' => l10n.skillUiTitle,
        'skillQaTitle' => l10n.skillQaTitle,
        'skillAiTitle' => l10n.skillAiTitle,
        _ => g.titleKey,
      };
}

abstract final class CourseCopy {
  static String title(AppLocalizations l10n, Course c) => switch (c.titleKey) {
        'courseIti' => l10n.courseIti,
        'courseElevate' => l10n.courseElevate,
        'courseCenterly' => l10n.courseCenterly,
        'courseUdemy' => l10n.courseUdemy,
        'coursePayments' => l10n.coursePayments,
        _ => c.titleKey,
      };

  static String? org(AppLocalizations l10n, Course c) {
    if (c.orgKey == null) return null;
    return switch (c.orgKey) {
      'courseItiOrg' => l10n.courseItiOrg,
      'courseElevateOrg' => l10n.courseElevateOrg,
      'courseCenterlyOrg' => l10n.courseCenterlyOrg,
      'courseUdemyOrg' => l10n.courseUdemyOrg,
      _ => c.orgKey,
    };
  }
}

/// Maps skill labels to optional icon asset basenames under `assets/icons/`.
abstract final class SkillIconPaths {
  static String? assetFor(String skill) {
    final key = skill.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    const known = {
      'dart': 'dart',
      'flutter': 'flutter',
      'bloc': 'bloc',
      'firebase_auth': 'firebase',
      'firestore': 'firebase',
      'fcm': 'firebase',
      'git': 'git',
      'github': 'github',
      'github_actions': 'github',
      'supabase': 'supabase',
      'stripe': 'stripe',
      'paypal': 'paypal',
      'google_maps_api': 'google_maps',
      'figma': 'figma',
      'jira': 'jira',
      'cursor': 'cursor',
      'claude': 'claude',
      'gemini': 'gemini',
      'chatgpt': 'chatgpt',
      'hive': 'hive',
      'dio': 'dio',
      'vs_code': 'vscode',
      'android_studio': 'android_studio',
      'postman': 'postman',
      'codemagic': 'codemagic',
    };
    final base = known[key];
    if (base == null) return null;
    return 'assets/icons/$base.png';
  }
}
