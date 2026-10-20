import 'package:flutter/material.dart';

/// Typed portfolio content — source of truth for structure & IDs.
/// Display strings live in EN/AR ARB files; this file holds non-localized facts,
/// slugs, and null/TODO markers (UI must hide TODO / null blocks).

const String kTodoUrl = 'TODO_URL';
const String kTodoReplace = 'TODO_REPLACE';

bool isTodo(String? value) =>
    value == null ||
    value.isEmpty ||
    value.startsWith('TODO_');

class Experience {
  const Experience({
    required this.id,
    required this.roleKey,
    required this.companyKey,
    required this.start,
    this.end,
    required this.bulletKeys,
  });

  final String id;
  final String roleKey;
  final String companyKey;
  final String start;
  final String? end;
  final List<String> bulletKeys;

  bool get isCurrent => end == null;

  String get logoImagePath => 'assets/images/logos/$id.png';
}

enum ProjectFilter { all, mobile, web, desktop }

class Project {
  const Project({
    required this.id,
    required this.slug,
    required this.titleKey,
    required this.taglineKey,
    required this.summaryKey,
    required this.platforms,
    required this.tech,
    this.playStoreUrl,
    this.githubUrl,
    this.websiteUrl,
    this.featured = false,
    this.hasCaseStudy = false,
  });

  final String id;
  final String slug;
  final String titleKey;
  final String taglineKey;
  final String summaryKey;
  final List<String> platforms;
  final List<String> tech;
  final String? playStoreUrl;
  final String? githubUrl;
  final String? websiteUrl;
  final bool featured;
  final bool hasCaseStudy;

  String get heroImagePath => 'assets/images/projects/$slug/hero.png';
  String get coverImagePath => 'assets/images/projects/$slug/cover.png';

  List<String> get visibleTech =>
      tech.where((t) => !isTodo(t)).toList(growable: false);

  bool matchesFilter(ProjectFilter filter) {
    if (filter == ProjectFilter.all) return true;
    final lower = platforms.map((p) => p.toLowerCase()).toList();
    return switch (filter) {
      ProjectFilter.mobile =>
        lower.any((p) => p.contains('android') || p.contains('ios') || p == 'mobile'),
      ProjectFilter.web =>
        lower.any((p) => p.contains('web') || p.contains('website')),
      ProjectFilter.desktop => lower.any((p) => p.contains('desktop')),
      ProjectFilter.all => true,
    };
  }

  /// Deterministic card tilt from slug (−0.04 … 0.04).
  double get cardTilt {
    final h = slug.hashCode;
    return ((h % 80) - 40) / 1000.0;
  }
}

class SkillGroup {
  const SkillGroup({
    required this.id,
    required this.titleKey,
    required this.items,
  });

  final String id;
  final String titleKey;
  final List<String> items;
}

class Course {
  const Course({
    required this.id,
    required this.titleKey,
    this.orgKey,
    this.url,
  });

  final String id;
  final String titleKey;
  final String? orgKey;
  final String? url;
}

class CaseStudyLoopStep {
  const CaseStudyLoopStep({
    required this.titleKey,
    required this.detailKey,
  });

  final String titleKey;
  final String detailKey;
}

class CaseStudyRoleNote {
  const CaseStudyRoleNote({
    required this.titleKey,
    required this.icon,
    this.detailKey,
  });

  final String titleKey;
  final String icon;
  final String? detailKey;
}

class CaseStudyScreen {
  const CaseStudyScreen({
    required this.index,
    required this.captionKey,
  });

  final int index;
  final String captionKey;

  String assetPath(String slug) =>
      'assets/images/projects/$slug/screens/${index.toString().padLeft(2, '0')}.png';
}

class CaseStudyChallenge {
  const CaseStudyChallenge({
    required this.problemKey,
    required this.solutionKey,
    required this.learnedKey,
  });

  final String problemKey;
  final String solutionKey;
  final String learnedKey;
}

class CaseStudyStat {
  const CaseStudyStat({
    required this.labelKey,
    this.value,
  });

  final String labelKey;

  /// Null / TODO → sticker stays hidden.
  final String? value;
}

/// Full case-study content for `/work/:slug`. Add a new entry + images to ship another.
class CaseStudy {
  const CaseStudy({
    required this.projectSlug,
    required this.heroTaglineKey,
    required this.heroTags,
    required this.creditKey,
    required this.roleMetaKey,
    required this.platformMetaKey,
    required this.periodMetaKey,
    required this.stackMetaKey,
    required this.productP1Key,
    required this.productP2Key,
    required this.loopSteps,
    required this.roleNotes,
    required this.architectureWhyKey,
    required this.screens,
    this.challenges = const [],
    this.stats = const [],
    this.learningKeys = const [],
    this.nextSlug,
  });

  final String projectSlug;
  final String heroTaglineKey;
  final List<String> heroTags;
  final String creditKey;
  final String roleMetaKey;
  final String platformMetaKey;
  final String periodMetaKey;
  final String stackMetaKey;
  final String productP1Key;
  final String productP2Key;
  final List<CaseStudyLoopStep> loopSteps;
  final List<CaseStudyRoleNote> roleNotes;
  final String architectureWhyKey;
  final List<CaseStudyScreen> screens;
  final List<CaseStudyChallenge> challenges;
  final List<CaseStudyStat> stats;
  final List<String> learningKeys;
  final String? nextSlug;

  String get heroImagePath => 'assets/images/projects/$projectSlug/hero.png';
}

class SocialLink {
  const SocialLink({
    required this.id,
    required this.labelKey,
    required this.url,
  });

  final String id;
  final String labelKey;
  final String url;
}

class EducationFact {
  const EducationFact({
    required this.degreeKey,
    required this.schoolKey,
    required this.start,
    required this.end,
    required this.gradeKey,
    required this.projectKey,
  });

  final String degreeKey;
  final String schoolKey;
  final String start;
  final String end;
  final String gradeKey;
  final String projectKey;
}

/// Static portfolio dataset for Ahmed Hisham Rasmy.
abstract final class PortfolioData {
  static const fullName = 'Ahmed Hisham Rasmy';
  static const firstName = 'Ahmed';
  static const lastName = 'Rasmy';
  static const title = 'Flutter Developer';
  static const location = 'Cairo, Egypt';
  static const email = 'ahmedhishamrasmy1@gmail.com';
  static const phone = '+201154126873';

  /// Hero shipped-apps counter (GatherUp, Awwaab, Elmohandes, Flowery).
  static const shippedAppsCount = 4;

  static const socials = <SocialLink>[
    SocialLink(id: 'linkedin', labelKey: 'linkLinkedIn', url: kTodoUrl),
    SocialLink(id: 'github', labelKey: 'linkGitHub', url: kTodoUrl),
  ];

  static const education = EducationFact(
    degreeKey: 'eduDegree',
    schoolKey: 'eduSchool',
    start: '10/2021',
    end: '06/2025',
    gradeKey: 'eduGrade',
    projectKey: 'eduProject',
  );

  static const experiences = <Experience>[
    Experience(
      id: 'gatherup',
      roleKey: 'expGatherUpRole',
      companyKey: 'expGatherUpCompany',
      start: '06/2026',
      bulletKeys: [
        'expGatherUpB1',
        'expGatherUpB2',
        'expGatherUpB3',
        'expGatherUpB4',
      ],
    ),
    Experience(
      id: 'centerly',
      roleKey: 'expCenterlyRole',
      companyKey: 'expCenterlyCompany',
      start: '03/2026',
      end: '06/2026',
      bulletKeys: [
        'expCenterlyB1',
        'expCenterlyB2',
        'expCenterlyB3',
      ],
    ),
    Experience(
      id: 'elevate',
      roleKey: 'expElevateRole',
      companyKey: 'expElevateCompany',
      start: '10/2024',
      end: '04/2025',
      bulletKeys: [
        'expElevateB1',
        'expElevateB2',
        'expElevateB3',
      ],
    ),
  ];

  static const projects = <Project>[
    Project(
      id: 'gatherup',
      slug: 'gatherup',
      titleKey: 'projGatherUpTitle',
      taglineKey: 'projGatherUpTagline',
      summaryKey: 'projGatherUpSummary',
      platforms: ['Android', 'iOS', 'Website'],
      tech: [
        'Clean Architecture',
        'Provider',
        'REST',
        'JWT',
        'Google Maps',
        'FCM',
      ],
      featured: true,
      hasCaseStudy: true,
    ),
    Project(
      id: 'awwaab',
      slug: 'awwaab',
      titleKey: 'projAwwaabTitle',
      taglineKey: 'projAwwaabTagline',
      summaryKey: 'projAwwaabSummary',
      platforms: ['Android'],
      tech: [
        'Clean Architecture',
        'BLoC',
        'Geolocation',
        'WorkManager',
        'Local notifications',
      ],
      playStoreUrl: kTodoUrl,
    ),
    Project(
      id: 'elmohandes',
      slug: 'elmohandes',
      titleKey: 'projElmohandesTitle',
      taglineKey: 'projElmohandesTagline',
      summaryKey: 'projElmohandesSummary',
      platforms: ['Android', 'Desktop'],
      tech: [
        'Clean Architecture',
        'BLoC',
        'Dio',
        'Retrofit',
        'SharedPreferences',
        'PDF',
      ],
    ),
    Project(
      id: 'flowery',
      slug: 'flowery',
      titleKey: 'projFloweryTitle',
      taglineKey: 'projFloweryTagline',
      summaryKey: 'projFlowerySummary',
      platforms: ['Mobile'],
      tech: ['Clean Architecture', 'BLoC', 'Dio', 'REST'],
    ),
    Project(
      id: 'servicex',
      slug: 'servicex',
      titleKey: 'projServiceXTitle',
      taglineKey: 'projServiceXTagline',
      summaryKey: 'projServiceXSummary',
      platforms: ['Mobile'],
      tech: [kTodoReplace],
    ),
  ];

  static const heroChipSlugs = <String>[
    'gatherup',
    'awwaab',
    'elmohandes',
    'flowery',
    'servicex',
  ];

  static Project? projectBySlug(String slug) {
    for (final p in projects) {
      if (p.slug == slug) return p;
    }
    return null;
  }

  static const skillGroups = <SkillGroup>[
    SkillGroup(
      id: 'core',
      titleKey: 'skillCoreTitle',
      items: [
        'Dart',
        'Flutter',
        'BLoC',
        'Cubit',
        'Clean Architecture',
        'SOLID',
        'MVVM',
        'Repository pattern',
        'get_it',
        'injectable',
      ],
    ),
    SkillGroup(
      id: 'api',
      titleKey: 'skillApiTitle',
      items: [
        'REST',
        'Dio',
        'Retrofit',
        'HTTP',
        'Firebase Auth',
        'Firestore',
        'FCM',
        'Storage',
        'Supabase',
        'Google Maps API',
        'Stripe',
        'PayPal',
      ],
    ),
    SkillGroup(
      id: 'storage',
      titleKey: 'skillStorageTitle',
      items: [
        'Hive',
        'SharedPreferences',
        'Local / remote data sources',
      ],
    ),
    SkillGroup(
      id: 'ui',
      titleKey: 'skillUiTitle',
      items: [
        'Responsive layouts',
        'Adaptive layouts',
        'Flutter animations',
        'Pixel-perfect UI',
        'UI/UX principles',
      ],
    ),
    SkillGroup(
      id: 'qa',
      titleKey: 'skillQaTitle',
      items: [
        'Unit tests',
        'Widget tests',
        'Git',
        'GitHub',
        'GitHub Actions',
        'Codemagic',
      ],
    ),
    SkillGroup(
      id: 'ai',
      titleKey: 'skillAiTitle',
      items: [
        'Cursor',
        'Claude',
        'Gemini',
        'ChatGPT',
        'Prompt engineering',
        'VS Code',
        'Android Studio',
        'Postman',
        'Jira',
        'Figma',
      ],
    ),
  ];

  static const courses = <Course>[
    Course(
      id: 'iti',
      titleKey: 'courseIti',
      orgKey: 'courseItiOrg',
      url: kTodoUrl,
    ),
    Course(
      id: 'elevate',
      titleKey: 'courseElevate',
      orgKey: 'courseElevateOrg',
      url: kTodoUrl,
    ),
    Course(
      id: 'centerly',
      titleKey: 'courseCenterly',
      orgKey: 'courseCenterlyOrg',
      url: kTodoUrl,
    ),
    Course(
      id: 'udemy',
      titleKey: 'courseUdemy',
      orgKey: 'courseUdemyOrg',
      url: kTodoUrl,
    ),
    Course(
      id: 'payments',
      titleKey: 'coursePayments',
      url: kTodoUrl,
    ),
  ];

  static const caseStudies = <CaseStudy>[
    CaseStudy(
      projectSlug: 'gatherup',
      heroTaglineKey: 'caseGatherUpHeroTagline',
      heroTags: [
        'Flutter',
        'Clean Architecture',
        'Provider',
        'REST',
        'FCM',
      ],
      creditKey: 'caseGatherUpCredit',
      roleMetaKey: 'caseGatherUpRoleMeta',
      platformMetaKey: 'caseGatherUpPlatformMeta',
      periodMetaKey: 'caseGatherUpPeriodMeta',
      stackMetaKey: 'caseGatherUpStackMeta',
      productP1Key: 'caseGatherUpProductP1',
      productP2Key: 'caseGatherUpProductP2',
      loopSteps: [
        CaseStudyLoopStep(
          titleKey: 'caseGatherUpLoopDiscover',
          detailKey: 'caseGatherUpLoopDiscoverD',
        ),
        CaseStudyLoopStep(
          titleKey: 'caseGatherUpLoopJoin',
          detailKey: 'caseGatherUpLoopJoinD',
        ),
        CaseStudyLoopStep(
          titleKey: 'caseGatherUpLoopMeet',
          detailKey: 'caseGatherUpLoopMeetD',
        ),
        CaseStudyLoopStep(
          titleKey: 'caseGatherUpLoopConnect',
          detailKey: 'caseGatherUpLoopConnectD',
        ),
      ],
      roleNotes: [
        CaseStudyRoleNote(
          titleKey: 'caseGatherUpRoleBooking',
          icon: 'event',
          detailKey: 'caseGatherUpRoleBookingD',
        ),
        CaseStudyRoleNote(
          titleKey: 'caseGatherUpRoleAuth',
          icon: 'lock',
          detailKey: 'caseGatherUpRoleAuthD',
        ),
        CaseStudyRoleNote(
          titleKey: 'caseGatherUpRoleRest',
          icon: 'api',
          detailKey: 'caseGatherUpRoleRestD',
        ),
        CaseStudyRoleNote(
          titleKey: 'caseGatherUpRoleCache',
          icon: 'storage',
          detailKey: 'caseGatherUpRoleCacheD',
        ),
        CaseStudyRoleNote(
          titleKey: 'caseGatherUpRoleMaps',
          icon: 'map',
          detailKey: 'caseGatherUpRoleMapsD',
        ),
        CaseStudyRoleNote(
          titleKey: 'caseGatherUpRoleFcm',
          icon: 'notifications',
          detailKey: 'caseGatherUpRoleFcmD',
        ),
        CaseStudyRoleNote(
          titleKey: 'caseGatherUpRoleChat',
          icon: 'chat',
          detailKey: 'caseGatherUpRoleChatD',
        ),
        CaseStudyRoleNote(
          titleKey: 'caseGatherUpRoleUi',
          icon: 'devices',
          detailKey: 'caseGatherUpRoleUiD',
        ),
      ],
      architectureWhyKey: 'caseGatherUpArchWhy',
      screens: [
        CaseStudyScreen(index: 1, captionKey: 'caseGatherUpScrDiscover'),
        CaseStudyScreen(index: 2, captionKey: 'caseGatherUpScrDetails'),
        CaseStudyScreen(index: 3, captionKey: 'caseGatherUpScrBook'),
        CaseStudyScreen(index: 4, captionKey: 'caseGatherUpScrChat'),
        CaseStudyScreen(index: 5, captionKey: 'caseGatherUpScrMap'),
        CaseStudyScreen(index: 6, captionKey: 'caseGatherUpScrNotif'),
      ],
      challenges: [
        CaseStudyChallenge(
          problemKey: 'caseGatherUpCh1Problem',
          solutionKey: 'caseGatherUpCh1Solution',
          learnedKey: 'caseGatherUpCh1Learned',
        ),
        CaseStudyChallenge(
          problemKey: 'caseGatherUpCh2Problem',
          solutionKey: 'caseGatherUpCh2Solution',
          learnedKey: 'caseGatherUpCh2Learned',
        ),
        CaseStudyChallenge(
          problemKey: 'caseGatherUpCh3Problem',
          solutionKey: 'caseGatherUpCh3Solution',
          learnedKey: 'caseGatherUpCh3Learned',
        ),
      ],
      stats: [
        CaseStudyStat(labelKey: 'caseGatherUpStatUsers', value: null),
        CaseStudyStat(labelKey: 'caseGatherUpStatBookings', value: null),
        CaseStudyStat(labelKey: 'caseGatherUpStatRating', value: null),
      ],
      learningKeys: [
        'caseGatherUpLearn1',
        'caseGatherUpLearn2',
        'caseGatherUpLearn3',
      ],
      nextSlug: 'awwaab',
    ),
  ];

  static CaseStudy? caseStudyBySlug(String slug) {
    for (final c in caseStudies) {
      if (c.projectSlug == slug) return c;
    }
    return null;
  }
}

/// GlobalKeys for scrolling to Selected Work cards (registered when section mounts).
abstract final class PortfolioScrollTargets {
  static final Map<String, GlobalKey> projectKeys = {};

  static GlobalKey keyForProject(String slug) =>
      projectKeys.putIfAbsent(slug, GlobalKey.new);

  static Future<void> scrollToProject(String slug) async {
    final ctx = projectKeys[slug]?.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOutCubic,
      alignment: 0.1,
    );
  }
}
