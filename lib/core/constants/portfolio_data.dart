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

/// Scroll-rail sections for a case study (progress dots).
enum CaseStudySectionId {
  problem,
  product,
  thinking,
  experience,
  system,
  motion,
  code,
  iteration,
  comingNext,
  results,
}

class CaseStudyCompareSide {
  const CaseStudyCompareSide({
    required this.titleKey,
    required this.captionKey,
    required this.stepKeys,
    this.accentTape = false,
  });

  final String titleKey;
  final String captionKey;
  final List<String> stepKeys;
  final bool accentTape;
}

class CaseStudyStoryPanel {
  const CaseStudyStoryPanel({
    required this.index,
    required this.captionKey,
  });

  final int index;
  final String captionKey;

  String assetPath(String slug) =>
      'assets/images/projects/$slug/story/${index.toString().padLeft(2, '0')}.jpg';
}

class CaseStudyLoopStep {
  const CaseStudyLoopStep({
    required this.titleKey,
    required this.detailKey,
  });

  final String titleKey;
  final String detailKey;
}

class CaseStudyQuestion {
  const CaseStudyQuestion({
    required this.questionKey,
    required this.answerKey,
  });

  final String questionKey;
  final String answerKey;
}

class CaseStudyMediaCard {
  const CaseStudyMediaCard({
    required this.id,
    required this.captionKey,
    this.videoAsset,
    this.posterAsset,
  });

  final String id;
  final String captionKey;
  final String? videoAsset;
  final String? posterAsset;
}

class CaseStudyDesignTier {
  const CaseStudyDesignTier({
    required this.titleKey,
    required this.chipKeys,
  });

  final String titleKey;
  final List<String> chipKeys;
}

class CaseStudyColorSwatch {
  const CaseStudyColorSwatch({
    required this.labelKey,
    required this.hex,
  });

  final String labelKey;
  final String hex;
}

class CaseStudyTypeSpecimen {
  const CaseStudyTypeSpecimen({
    required this.labelKey,
    required this.sampleKey,
    this.rtl = false,
  });

  final String labelKey;
  final String sampleKey;
  final bool rtl;
}

class CaseStudyMotionTiming {
  const CaseStudyMotionTiming({
    required this.titleKey,
    required this.durationLabel,
    required this.useKey,
    required this.durationMs,
  });

  final String titleKey;
  final String durationLabel;
  final String useKey;
  final int durationMs;
}

class CaseStudyCodeStep {
  const CaseStudyCodeStep({
    required this.titleKey,
    required this.bodyKey,
  });

  final String titleKey;
  final String bodyKey;
}

/// Full case-study content for `/work/:slug`.
/// Later sub-steps add optional section payloads; null/TODO blocks hide themselves.
class CaseStudy {
  const CaseStudy({
    required this.projectSlug,
    required this.heroTaglineKey,
    this.heroBrushKey,
    this.heroTags = const [],
    this.creditKey,
    this.marketMetaKey,
    this.platformMetaKey,
    this.localeMetaKey,
    this.stackMetaKey,
    this.problemHeadlineKey,
    this.compareTypical,
    this.compareGatherUp,
    this.storyPanels = const [],
    this.productHeadlineKey,
    this.loopSteps = const [],
    this.thinkingHeadlineKey,
    this.thinkingQuestions = const [],
    this.experienceHeadlineKey,
    this.experienceCards = const [],
    this.systemHeadlineKey,
    this.systemCreditKey,
    this.designTiers = const [],
    this.colorSwatches = const [],
    this.themeMedia = const [],
    this.typeSpecimens = const [],
    this.componentCards = const [],
    this.motionHeadlineKey,
    this.motionTimings = const [],
    this.motionVideos = const [],
    this.respectsReduceMotion = false,
    this.codeHeadlineKey,
    this.codeSteps = const [],
    this.codeClosingKey,
    this.nextSlug,
  });

  final String projectSlug;
  final String heroTaglineKey;

  /// Blue brush/script word under the condensed title (optional).
  final String? heroBrushKey;
  final List<String> heroTags;
  final String? creditKey;
  final String? marketMetaKey;
  final String? platformMetaKey;

  /// Hide sticker when null (e.g. no EN/AR · RTL work).
  final String? localeMetaKey;
  final String? stackMetaKey;

  // ── 7B ──
  final String? problemHeadlineKey;
  final CaseStudyCompareSide? compareTypical;
  final CaseStudyCompareSide? compareGatherUp;
  final List<CaseStudyStoryPanel> storyPanels;
  final String? productHeadlineKey;
  final List<CaseStudyLoopStep> loopSteps;
  final String? thinkingHeadlineKey;
  final List<CaseStudyQuestion> thinkingQuestions;

  // ── 7C ──
  final String? experienceHeadlineKey;
  final List<CaseStudyMediaCard> experienceCards;
  final String? systemHeadlineKey;
  final String? systemCreditKey;
  final List<CaseStudyDesignTier> designTiers;
  final List<CaseStudyColorSwatch> colorSwatches;
  final List<CaseStudyMediaCard> themeMedia;
  final List<CaseStudyTypeSpecimen> typeSpecimens;
  final List<CaseStudyMediaCard> componentCards;
  final String? motionHeadlineKey;
  final List<CaseStudyMotionTiming> motionTimings;
  final List<CaseStudyMediaCard> motionVideos;
  final bool respectsReduceMotion;
  final String? codeHeadlineKey;
  final List<CaseStudyCodeStep> codeSteps;
  final String? codeClosingKey;

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
      heroBrushKey: 'caseGatherUpBrush',
      heroTags: [
        'Product',
        'Flutter',
        'Clean Architecture',
        'Provider',
      ],
      creditKey: 'caseGatherUpCredit',
      marketMetaKey: 'caseGatherUpMarketMeta',
      platformMetaKey: 'caseGatherUpPlatformMeta',
      localeMetaKey: 'caseGatherUpLocaleMeta',
      stackMetaKey: 'caseGatherUpStackMeta',
      problemHeadlineKey: 'caseGatherUpProblemHeadline',
      compareTypical: CaseStudyCompareSide(
        titleKey: 'caseGatherUpCompareTypicalTitle',
        captionKey: 'caseGatherUpCompareTypicalCaption',
        stepKeys: [
          'caseGatherUpCompareTypicalS1',
          'caseGatherUpCompareTypicalS2',
          'caseGatherUpCompareTypicalS3',
        ],
      ),
      compareGatherUp: CaseStudyCompareSide(
        titleKey: 'caseGatherUpCompareGuTitle',
        captionKey: 'caseGatherUpCompareGuCaption',
        stepKeys: [
          'caseGatherUpCompareGuS1',
          'caseGatherUpCompareGuS2',
          'caseGatherUpCompareGuS3',
          'caseGatherUpCompareGuS4',
        ],
        accentTape: true,
      ),
      storyPanels: [
        CaseStudyStoryPanel(index: 1, captionKey: 'caseGatherUpStory1'),
        CaseStudyStoryPanel(index: 2, captionKey: 'caseGatherUpStory2'),
        CaseStudyStoryPanel(index: 3, captionKey: 'caseGatherUpStory3'),
        CaseStudyStoryPanel(index: 4, captionKey: 'caseGatherUpStory4'),
      ],
      productHeadlineKey: 'caseGatherUpProductHeadline',
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
      thinkingHeadlineKey: 'caseGatherUpThinkingHeadline',
      thinkingQuestions: [
        CaseStudyQuestion(
          questionKey: 'caseGatherUpQ1',
          answerKey: 'caseGatherUpA1',
        ),
        CaseStudyQuestion(
          questionKey: 'caseGatherUpQ2',
          answerKey: 'caseGatherUpA2',
        ),
        CaseStudyQuestion(
          questionKey: 'caseGatherUpQ3',
          answerKey: 'caseGatherUpA3',
        ),
        CaseStudyQuestion(
          questionKey: 'caseGatherUpQ4',
          answerKey: 'caseGatherUpA4',
        ),
        CaseStudyQuestion(
          questionKey: 'caseGatherUpQ5',
          answerKey: 'caseGatherUpA5',
        ),
        CaseStudyQuestion(
          questionKey: 'caseGatherUpQ6',
          answerKey: 'caseGatherUpA6',
        ),
      ],
      experienceHeadlineKey: 'caseGatherUpExpHeadline',
      experienceCards: [
        CaseStudyMediaCard(
          id: 'discover',
          captionKey: 'caseGatherUpExpDiscover',
          videoAsset: 'assets/videos/gatherup/showcase-discover.mp4',
          posterAsset: 'assets/images/projects/gatherup/posters/discover.png',
        ),
        CaseStudyMediaCard(
          id: 'context',
          captionKey: 'caseGatherUpExpContext',
          videoAsset: 'assets/videos/gatherup/showcase-context.mp4',
          posterAsset: 'assets/images/projects/gatherup/posters/context.png',
        ),
        CaseStudyMediaCard(
          id: 'book',
          captionKey: 'caseGatherUpExpBook',
          videoAsset: 'assets/videos/gatherup/showcase-book.mp4',
          posterAsset: 'assets/images/projects/gatherup/posters/book.png',
        ),
        CaseStudyMediaCard(
          id: 'connect',
          captionKey: 'caseGatherUpExpConnect',
          videoAsset: 'assets/videos/gatherup/showcase-connect.mp4',
          posterAsset: 'assets/images/projects/gatherup/posters/connect.png',
        ),
      ],
      systemHeadlineKey: 'caseGatherUpSysHeadline',
      systemCreditKey: 'caseGatherUpSysCredit',
      designTiers: [
        CaseStudyDesignTier(
          titleKey: 'caseGatherUpTierPrimitives',
          chipKeys: [
            'caseGatherUpChipColor',
            'caseGatherUpChipSpace',
            'caseGatherUpChipRadius',
          ],
        ),
        CaseStudyDesignTier(
          titleKey: 'caseGatherUpTierFoundations',
          chipKeys: [
            'caseGatherUpChipType',
            'caseGatherUpChipIcon',
            'caseGatherUpChipElevation',
          ],
        ),
        CaseStudyDesignTier(
          titleKey: 'caseGatherUpTierCore',
          chipKeys: [
            'caseGatherUpChipButton',
            'caseGatherUpChipInput',
            'caseGatherUpChipChip',
          ],
        ),
        CaseStudyDesignTier(
          titleKey: 'caseGatherUpTierSurfaces',
          chipKeys: [
            'caseGatherUpChipCard',
            'caseGatherUpChipSheet',
            'caseGatherUpChipNav',
          ],
        ),
        CaseStudyDesignTier(
          titleKey: 'caseGatherUpTierPatterns',
          chipKeys: [
            'caseGatherUpChipBooking',
            'caseGatherUpChipChat',
            'caseGatherUpChipMap',
          ],
        ),
      ],
      colorSwatches: [
        CaseStudyColorSwatch(
          labelKey: 'caseGatherUpColorGold',
          hex: '#E8C96A',
        ),
        CaseStudyColorSwatch(
          labelKey: 'caseGatherUpColorNight',
          hex: '#0A1628',
        ),
        CaseStudyColorSwatch(
          labelKey: 'caseGatherUpColorChalk',
          hex: '#F4F8FC',
        ),
      ],
      themeMedia: [
        CaseStudyMediaCard(
          id: 'theme-light',
          captionKey: 'caseGatherUpThemeLight',
          videoAsset: 'assets/videos/gatherup/theme-light.mp4',
          posterAsset: 'assets/images/projects/gatherup/posters/theme-light.png',
        ),
        CaseStudyMediaCard(
          id: 'theme-dark',
          captionKey: 'caseGatherUpThemeDark',
          videoAsset: 'assets/videos/gatherup/theme-dark.mp4',
          posterAsset: 'assets/images/projects/gatherup/posters/theme-dark.png',
        ),
        CaseStudyMediaCard(
          id: 'theme-en',
          captionKey: 'caseGatherUpThemeEn',
          videoAsset: 'assets/videos/gatherup/theme-en.mp4',
          posterAsset: 'assets/images/projects/gatherup/posters/theme-en.png',
        ),
        CaseStudyMediaCard(
          id: 'theme-ar',
          captionKey: 'caseGatherUpThemeAr',
          videoAsset: 'assets/videos/gatherup/theme-ar.mp4',
          posterAsset: 'assets/images/projects/gatherup/posters/theme-ar.png',
        ),
      ],
      typeSpecimens: [
        CaseStudyTypeSpecimen(
          labelKey: 'caseGatherUpTypeEnLabel',
          sampleKey: 'caseGatherUpTypeEnSample',
        ),
        CaseStudyTypeSpecimen(
          labelKey: 'caseGatherUpTypeArLabel',
          sampleKey: 'caseGatherUpTypeArSample',
          rtl: true,
        ),
      ],
      componentCards: [
        CaseStudyMediaCard(
          id: 'comp-buttons',
          captionKey: 'caseGatherUpCompButtons',
          videoAsset: 'assets/videos/gatherup/comp-buttons.mp4',
          posterAsset: 'assets/images/projects/gatherup/posters/comp-buttons.png',
        ),
        CaseStudyMediaCard(
          id: 'comp-chips',
          captionKey: 'caseGatherUpCompChips',
          videoAsset: 'assets/videos/gatherup/comp-chips.mp4',
          posterAsset: 'assets/images/projects/gatherup/posters/comp-chips.png',
        ),
        CaseStudyMediaCard(
          id: 'comp-sheets',
          captionKey: 'caseGatherUpCompSheets',
          videoAsset: 'assets/videos/gatherup/comp-sheets.mp4',
          posterAsset: 'assets/images/projects/gatherup/posters/comp-sheets.png',
        ),
      ],
      motionHeadlineKey: 'caseGatherUpMotionHeadline',
      motionTimings: [
        CaseStudyMotionTiming(
          titleKey: 'caseGatherUpMotionMicro',
          durationLabel: '~150ms',
          useKey: 'caseGatherUpMotionMicroUse',
          durationMs: 150,
        ),
        CaseStudyMotionTiming(
          titleKey: 'caseGatherUpMotionQuick',
          durationLabel: '~250ms',
          useKey: 'caseGatherUpMotionQuickUse',
          durationMs: 250,
        ),
        CaseStudyMotionTiming(
          titleKey: 'caseGatherUpMotionStandard',
          durationLabel: '~350ms',
          useKey: 'caseGatherUpMotionStandardUse',
          durationMs: 350,
        ),
        CaseStudyMotionTiming(
          titleKey: 'caseGatherUpMotionScreen',
          durationLabel: '~500ms',
          useKey: 'caseGatherUpMotionScreenUse',
          durationMs: 500,
        ),
      ],
      motionVideos: [
        CaseStudyMediaCard(
          id: 'motion-tab',
          captionKey: 'caseGatherUpMotionTab',
          videoAsset: 'assets/videos/gatherup/motion-tab.mp4',
          posterAsset: 'assets/images/projects/gatherup/posters/motion-tab.png',
        ),
        CaseStudyMediaCard(
          id: 'motion-push',
          captionKey: 'caseGatherUpMotionPush',
          videoAsset: 'assets/videos/gatherup/motion-push.mp4',
          posterAsset: 'assets/images/projects/gatherup/posters/motion-push.png',
        ),
        CaseStudyMediaCard(
          id: 'motion-sheet',
          captionKey: 'caseGatherUpMotionSheet',
          videoAsset: 'assets/videos/gatherup/motion-sheet.mp4',
          posterAsset: 'assets/images/projects/gatherup/posters/motion-sheet.png',
        ),
        CaseStudyMediaCard(
          id: 'motion-privacy',
          captionKey: 'caseGatherUpMotionPrivacy',
          videoAsset: 'assets/videos/gatherup/motion-privacy.mp4',
          posterAsset:
              'assets/images/projects/gatherup/posters/motion-privacy.png',
        ),
      ],
      respectsReduceMotion: true,
      codeHeadlineKey: 'caseGatherUpCodeHeadline',
      codeSteps: [
        CaseStudyCodeStep(
          titleKey: 'caseGatherUpCodeDesign',
          bodyKey: 'caseGatherUpCodeDesignBody',
        ),
        CaseStudyCodeStep(
          titleKey: 'caseGatherUpCodeCode',
          bodyKey: 'caseGatherUpCodeCodeBody',
        ),
        CaseStudyCodeStep(
          titleKey: 'caseGatherUpCodeShip',
          bodyKey: 'caseGatherUpCodeShipBody',
        ),
      ],
      codeClosingKey: 'caseGatherUpCodeClosing',
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
