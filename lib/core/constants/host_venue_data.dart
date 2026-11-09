import 'package:flutter/widgets.dart';

/// Host & Venue Mode deep-dive — typed content (EN + AR). Flip status when live.
enum FeatureStatus { inQa, shippingSoon, releasedAndroid, releasedAndroidIos }

const kHostVenueStatus = FeatureStatus.shippingSoon;

const kHostVenueRoute = '/work/gatherup/host-venue-mode';
const kHostVenueAssetDir = 'assets/images/projects/gatherup/host-venue';

String featureStatusStamp(FeatureStatus s, {required bool ar}) => switch (s) {
      FeatureStatus.inQa => ar ? 'قيد الاختبار' : 'IN QA',
      FeatureStatus.shippingSoon =>
        ar ? 'قريبًا · أندرويد أولًا' : 'SHIPPING SOON · ANDROID FIRST',
      FeatureStatus.releasedAndroid =>
        ar ? 'مباشر على أندرويد · iOS لاحقًا' : 'LIVE ON ANDROID · iOS NEXT',
      FeatureStatus.releasedAndroidIos =>
        ar ? 'مباشر على أندرويد و iOS' : 'LIVE ON ANDROID & iOS',
    };

class LocalizedText {
  const LocalizedText(this.en, this.ar);
  final String en;
  final String ar;

  /// Empty when the active locale still contains a `TODO_` marker.
  String t(bool isAr) {
    final raw = isAr ? ar : en;
    if (raw.contains('TODO_')) return '';
    return raw;
  }

  String of(BuildContext context) =>
      t(Localizations.localeOf(context).languageCode == 'ar');
}

enum OperatorRole { member, host, venue }

class OwnershipArea {
  const OwnershipArea({
    required this.label,
    required this.lines,
    required this.ahmedPercent,
  });
  final LocalizedText label;
  final int? lines; // null = n/a
  final double ahmedPercent; // 0–100
}

class SubFeatureCommit {
  const SubFeatureCommit({
    required this.label,
    required this.commits,
  });
  final LocalizedText label;
  final int commits;
}

class DecisionCard {
  const DecisionCard({
    required this.decision,
    required this.why,
    required this.tradeOff,
  });
  final LocalizedText decision;
  final LocalizedText why;
  final LocalizedText tradeOff;
}

class IsolationStep {
  const IsolationStep({
    required this.title,
    required this.body,
  });
  final LocalizedText title;
  final LocalizedText body;
}

class ChallengeCard {
  const ChallengeCard({
    required this.problem,
    required this.solution,
    required this.learned,
  });
  final LocalizedText problem;
  final LocalizedText solution;

  /// TODO_REPLACE hides the learned line.
  final LocalizedText learned;
}

class CodeSnippet {
  const CodeSnippet({
    required this.title,
    required this.explanation,
    required this.code,
  });
  final LocalizedText title;
  final LocalizedText explanation;
  final String code;
}

class RoleCapability {
  const RoleCapability({
    required this.role,
    required this.can,
    required this.cannot,
    required this.screenshot,
  });
  final OperatorRole role;
  final List<LocalizedText> can;
  final List<LocalizedText> cannot;
  final String screenshot;
}

class GalleryShot {
  const GalleryShot({
    required this.file,
    required this.caption,
    required this.mode,
  });
  final String file;
  final LocalizedText caption;
  final OperatorRole mode;
  String get path => '$kHostVenueAssetDir/$file';
}

class QualityFact {
  const QualityFact({required this.label, required this.value});
  final LocalizedText label;
  final LocalizedText value;
}

/// Source of truth for `/work/gatherup/host-venue-mode`.
abstract final class HostVenueData {
  static const heroLabel = LocalizedText('FEATURE DEEP-DIVE', 'تعمق في الميزة');
  static const heroTitle = LocalizedText('Host & Venue Mode', 'وضع المضيف والمكان');
  static const heroBrush = LocalizedText('one app, three roles', 'تطبيق واحد، ثلاثة أدوار');
  static const heroTagline = LocalizedText(
    'Operator tools for the people who run gatherings, built into the member app.',
    'أدوات تشغيل لمن يديرون اللقاءات، داخل تطبيق الأعضاء.',
  );

  static const metaRole = LocalizedText(
    'Flutter engineer (end-to-end)',
    'مهندس فلاتر (من الطرف إلى الطرف)',
  );
  static const metaApp = LocalizedText(
    'GatherUp (iOS · Android)',
    'GatherUp (iOS · Android)',
  );
  static const metaStack = LocalizedText(
    'Flutter · Provider · REST · fl_chart',
    'Flutter · Provider · REST · fl_chart',
  );
  static const metaPeriod = LocalizedText(
    'Sep 14 to Oct 22, 2026',
    '١٤ سبتمبر إلى ٢٢ أكتوبر ٢٠٢٦',
  );

  static const credit = LocalizedText(
    'Product decisions made with the GatherUp team. Flutter implementation: Ahmed. Public venue profile page: Sayed El Mohamady.',
    'قرارات المنتج مع فريق GatherUp. تنفيذ فلاتر: أحمد. صفحة ملف المكان العامة: سيد المحمدي.',
  );

  // ── 01 Receipts ──
  static const receiptsHeadline = LocalizedText(
    'Built end-to-end, and I can prove it.',
    'بُني من الطرف إلى الطرف، وأستطيع إثباته.',
  );
  static const receiptsSub = LocalizedText(
    'Numbers from git blame on HEAD (merge and bot commits excluded), Flutter code only.',
    'أرقام من git blame على HEAD (باستثناء دمج وبوتات)، كود فلاتر فقط.',
  );

  static const receiptCommits = 36;
  static const receiptLines = 23000;
  static const receiptOwnershipPercent = 100;
  static const receiptTimeline = LocalizedText(
    'Sep 14 → Oct 22',
    '١٤ سبتمبر → ٢٢ أكتوبر',
  );

  static const receiptStatCommits = LocalizedText(
    'non-merge commits',
    'التزامات غير دمج',
  );
  static const receiptStatLines = LocalizedText(
    'surviving lines',
    'أسطر باقية',
  );
  static const receiptStatOwned = LocalizedText(
    'of Host & Venue Mode lines',
    'من أسطر وضع المضيف والمكان',
  );
  static const receiptStatTimeline = LocalizedText('timeline', 'الجدول الزمني');

  static const ownershipAreas = <OwnershipArea>[
    OwnershipArea(
      label: LocalizedText('Host screens', 'شاشات المضيف'),
      lines: 12131,
      ahmedPercent: 100,
    ),
    OwnershipArea(
      label: LocalizedText('Venue Mode screens', 'شاشات وضع المكان'),
      lines: 5233,
      ahmedPercent: 100,
    ),
    OwnershipArea(
      label: LocalizedText(
        'Providers, repositories, mode switch',
        'المزوّدات والمستودعات وتبديل الوضع',
      ),
      lines: 2933,
      ahmedPercent: 100,
    ),
    OwnershipArea(
      label: LocalizedText('Host & Venue models', 'نماذج المضيف والمكان'),
      lines: 2708,
      ahmedPercent: 100,
    ),
    OwnershipArea(
      label: LocalizedText(
        'Localization (host + venueMode EN/AR blocks)',
        'التعريب (كتل المضيف والمكان إن/عر)',
      ),
      lines: 661,
      ahmedPercent: 100,
    ),
    OwnershipArea(
      label: LocalizedText('Related tests (~70 cases)', 'اختبارات ذات صلة (~٧٠)'),
      lines: null,
      ahmedPercent: 87,
    ),
  ];

  static const ownershipFootnote = LocalizedText(
    'Not counted as mine: the public venue profile page (attendee-facing, ~1,579 lines) was built by Sayed El Mohamady. Including it, my share of the whole folder is 93.6%. Also: Backend work is a shared effort and is not part of these numbers.',
    'غير محسوب لي: صفحة ملف المكان العامة (للحضور، ~١٬٥٧٩ سطرًا) بناها سيد المحمدي. بإضافتها، حصتي من المجلد كاملًا ٩٣٫٦٪. كذلك: عمل الخلفية جهد مشترك وليس ضمن هذه الأرقام.',
  );

  static const subFeatures = <SubFeatureCommit>[
    SubFeatureCommit(label: LocalizedText('Mode switching', 'تبديل الوضع'), commits: 8),
    SubFeatureCommit(label: LocalizedText('Host home', 'رئيسية المضيف'), commits: 15),
    SubFeatureCommit(
      label: LocalizedText('Session create/edit/cancel', 'إنشاء/تعديل/إلغاء الجلسة'),
      commits: 18,
    ),
    SubFeatureCommit(label: LocalizedText('Door', 'الباب'), commits: 6),
    SubFeatureCommit(label: LocalizedText('Community CRM', 'إدارة المجتمع'), commits: 11),
    SubFeatureCommit(label: LocalizedText('Analytics', 'التحليلات'), commits: 2),
    SubFeatureCommit(label: LocalizedText('Brand profile', 'ملف العلامة'), commits: 8),
    SubFeatureCommit(label: LocalizedText('Wallet UI', 'واجهة المحفظة'), commits: 5),
    SubFeatureCommit(label: LocalizedText('Venue home', 'رئيسية المكان'), commits: 4),
    SubFeatureCommit(label: LocalizedText('Venue schedule', 'جدول المكان'), commits: 4),
    SubFeatureCommit(
      label: LocalizedText('Gathering detail + guests', 'تفاصيل اللقاء والضيوف'),
      commits: 2,
    ),
    SubFeatureCommit(label: LocalizedText('Visitors', 'الزوار'), commits: 4),
    SubFeatureCommit(
      label: LocalizedText('Performance charts', 'مخططات الأداء'),
      commits: 1,
    ),
    SubFeatureCommit(
      label: LocalizedText('Payments history', 'سجل المدفوعات'),
      commits: 1,
    ),
    SubFeatureCommit(
      label: LocalizedText('Venue profile editor', 'محرر ملف المكان'),
      commits: 2,
    ),
    SubFeatureCommit(
      label: LocalizedText('Providers/repos', 'المزوّدات/المستودعات'),
      commits: 13,
    ),
  ];

  // ── 02 Overview ──
  static const overviewHeadline = LocalizedText(
    'One app. Three roles.',
    'تطبيق واحد. ثلاثة أدوار.',
  );
  static const overviewSummary = LocalizedText(
    'Host Mode and Venue Mode are operator shells inside the same member app. Hosts (brand admins) create and manage sessions, run the door, manage their community, see analytics and edit their brand. Venue partners get a read-mostly diary of the gatherings at their place, visitors, performance charts, payments history and a profile editor. Switching modes swaps the whole navigation without re-login.',
    'وضع المضيف ووضع المكان غلافان تشغيليان داخل تطبيق الأعضاء نفسه. المضيفون (مسؤولو العلامة) ينشئون الجلسات ويديرونها ويشغّلون الباب ويديرون مجتمعهم ويرون التحليلات ويعدّلون علامتهم. شركاء المكان يحصلون على يوميات للقراءات غالبًا للقاءات في مكانهم، والزوار، ومخططات الأداء، وسجل المدفوعات، ومحرر الملف. تبديل الأوضاع يبدّل التنقل كاملًا دون إعادة تسجيل الدخول.',
  );
  static const overviewWhy = LocalizedText(
    'We moved operator work into the phone, so hosts and venues can follow their gatherings on the go, instead of only from the web dashboard.',
    'نقلنا عمل التشغيل إلى الهاتف، حتى يتابع المضيفون والأماكن لقاءاتهم أثناء التنقل بدل لوحة الويب فقط.',
  );
  static const overviewWhyLabel = LocalizedText('Why it exists', 'لماذا وُجد');

  static const roleMemberLabel = LocalizedText('MEMBER', 'عضو');
  static const roleHostLabel = LocalizedText('HOST', 'مضيف');
  static const roleVenueLabel = LocalizedText('VENUE', 'مكان');

  static const roles = <RoleCapability>[
    RoleCapability(
      role: OperatorRole.member,
      can: [
        LocalizedText('Discover and book sessions', 'اكتشف واحجز الجلسات'),
        LocalizedText('Chat and clubs', 'الدردشة والأندية'),
      ],
      cannot: [
        LocalizedText(
          'Cannot enter operator shells without capability',
          'لا يدخل أغلفة التشغيل دون صلاحية',
        ),
      ],
      screenshot: '$kHostVenueAssetDir/01-switch-pill.png',
    ),
    RoleCapability(
      role: OperatorRole.host,
      can: [
        LocalizedText('Create/update/cancel sessions', 'إنشاء/تحديث/إلغاء الجلسات'),
        LocalizedText(
          'Door: attended, no-show, waitlist, walk-ins',
          'الباب: حضور، غياب، قائمة انتظار، حضور مباشر',
        ),
        LocalizedText('Community CRM, notes, CSV export', 'إدارة المجتمع والملاحظات وتصدير CSV'),
        LocalizedText('Analytics and earnings UI', 'التحليلات وواجهة الأرباح'),
        LocalizedText('Brand profile, reviews, session chat', 'ملف العلامة والمراجعات ودردشة الجلسة'),
      ],
      cannot: [
        LocalizedText(
          'Cannot use Venue Mode at the same time',
          'لا يستخدم وضع المكان في الوقت نفسه',
        ),
      ],
      screenshot: '$kHostVenueAssetDir/03-host-home.png',
    ),
    RoleCapability(
      role: OperatorRole.venue,
      can: [
        LocalizedText('Overview and schedule diary', 'نظرة عامة ويوميات الجدول'),
        LocalizedText('Gathering guest list (read-only)', 'قائمة ضيوف اللقاء (قراءة فقط)'),
        LocalizedText('Visitors directory', 'دليل الزوار'),
        LocalizedText('Performance charts', 'مخططات الأداء'),
        LocalizedText('Payments history', 'سجل المدفوعات'),
        LocalizedText('Venue profile editor', 'محرر ملف المكان'),
        LocalizedText('Switch venues they manage', 'تبديل الأماكن التي يديرونها'),
      ],
      cannot: [
        LocalizedText(
          'Cannot create or cancel sessions, or run the door',
          'لا ينشئ أو يلغي الجلسات ولا يشغّل الباب',
        ),
      ],
      screenshot: '$kHostVenueAssetDir/09-venue-home.png',
    ),
  ];

  // ── 04 Decisions ──
  static const decisionsHeadline = LocalizedText(
    'Design decisions',
    'قرارات التصميم',
  );

  static const decisions = <DecisionCard>[
    DecisionCard(
      decision: LocalizedText('Mutually exclusive modes', 'أوضاع متبادلة الاستبعاد'),
      why: LocalizedText(
        'A team decision so hosts and venues can follow everything from the phone, with one clear context at a time, and the tab index is shared across shells.',
        'قرار الفريق حتى يتابع المضيفون والأماكن كل شيء من الهاتف، بسياق واحد واضح في كل مرة، وفهرس التبويب مشترك عبر الأغلفة.',
      ),
      tradeOff: LocalizedText(
        'You lose your tab position when switching.',
        'تفقد موضع التبويب عند التبديل.',
      ),
    ),
    DecisionCard(
      decision: LocalizedText('Venue Mode is read-mostly', 'وضع المكان للقراءة غالبًا'),
      why: LocalizedText(
        'A partner diary, not host powers.',
        'يوميات شريك، لا صلاحيات مضيف.',
      ),
      tradeOff: LocalizedText(
        'No door operations for venues in the app.',
        'لا عمليات باب للأماكن في التطبيق.',
      ),
    ),
    DecisionCard(
      decision: LocalizedText(
        'Acting context is a selector, not authority',
        'سياق العمل محدد اختيار لا سلطة',
      ),
      why: LocalizedText(
        'The client says which brand/venue it is acting as; the server re-validates membership on every call.',
        'العميل يحدد العلامة/المكان الذي يعمل به؛ والخادم يعيد التحقق من العضوية في كل طلب.',
      ),
      tradeOff: LocalizedText(
        'Client must stay honest about context; server is the source of truth.',
        'يجب أن يبقى العميل صادقًا بشأن السياق؛ الخادم مصدر الحقيقة.',
      ),
    ),
    DecisionCard(
      decision: LocalizedText(
        'Persisted mode is capability-gated',
        'الوضع المحفوظ مربوط بالصلاحية',
      ),
      why: LocalizedText(
        'The saved preference is combined with the live capability, so a revoked role cannot keep the user stuck in an operator shell.',
        'التفضيل المحفوظ يُدمج مع الصلاحية الحية، فلا يُبقي دور ملغى المستخدم عالقًا في غلاف تشغيل.',
      ),
      tradeOff: LocalizedText(
        'Mode restore may fall back to Member when capability disappears.',
        'قد يعود الوضع إلى العضو عند اختفاء الصلاحية.',
      ),
    ),
    DecisionCard(
      decision: LocalizedText(
        'SharedPreferences for persistence',
        'SharedPreferences للحفظ',
      ),
      why: LocalizedText(
        'The data is tiny (mode plus active brand/venue id), so the simplest tool wins.',
        'البيانات صغيرة (الوضع ومعرّف العلامة/المكان النشط)، فأبسط أداة تفوز.',
      ),
      tradeOff: LocalizedText(
        'Not encrypted, which is fine because nothing sensitive is stored.',
        'غير مشفّر، وهذا مقبول لأنه لا يُخزَّن شيء حسّاس.',
      ),
    ),
    DecisionCard(
      decision: LocalizedText(
        'Separate HostProvider / VenueProvider',
        'HostProvider و VenueProvider منفصلان',
      ),
      why: LocalizedText(
        'Identity lives in AppProvider; domain caches live in their own providers and are rebound on every switch.',
        'الهوية في AppProvider؛ وذاكرة المجال في مزوّداتها وتُعاد الربط عند كل تبديل.',
      ),
      tradeOff: LocalizedText('More wiring.', 'مزيد من الربط.'),
    ),
    DecisionCard(
      decision: LocalizedText('Repository facades', 'واجهات المستودعات'),
      why: LocalizedText(
        'Screens never construct services.',
        'الشاشات لا تبني الخدمات مباشرة.',
      ),
      tradeOff: LocalizedText('A thin extra layer.', 'طبقة رقيقة إضافية.'),
    ),
  ];

  // ── 05 Isolation ──
  static const isolationHeadline = LocalizedText(
    "Making sure one host never sees another host's data.",
    'التأكد من أن مضيفًا لا يرى بيانات مضيف آخر.',
  );
  static const isolationIntro = LocalizedText(
    'Hosts can manage several brands and venues from one account, and the phone keeps the previous screens alive. The risk: data from brand A showing up under brand B. I designed isolation into the state layer instead of patching leaks later.',
    'يمكن للمضيفين إدارة عدة علامات وأماكن من حساب واحد، والهاتف يبقي الشاشات السابقة حيّة. الخطر: بيانات العلامة أ تظهر تحت العلامة ب. صمّمت العزل في طبقة الحالة بدل ترقيع التسريبات لاحقًا.',
  );

  static const isolationSteps = <IsolationStep>[
    IsolationStep(
      title: LocalizedText('One source of identity', 'مصدر هوية واحد'),
      body: LocalizedText(
        'AppProvider holds a single active brand and a single active venue. Every API call carries that context.',
        'AppProvider يحتفظ بعلامة نشطة واحدة ومكان نشط واحد. كل طلب API يحمل هذا السياق.',
      ),
    ),
    IsolationStep(
      title: LocalizedText('Rebind on switch', 'إعادة الربط عند التبديل'),
      body: LocalizedText(
        'bindApp on HostProvider and VenueProvider resets caches when the brand/venue id changes or the mode turns off, then force-refreshes when it turns on.',
        'bindApp على HostProvider و VenueProvider يصفّر الذاكرة عند تغيّر المعرّف أو إيقاف الوضع، ثم يفرض التحديث عند التشغيل.',
      ),
    ),
    IsolationStep(
      title: LocalizedText('Stale-response guards', 'حماية من الردود المتأخرة'),
      body: LocalizedText(
        'A request counter (venue) and a generation counter (host CRM) make late responses from the previous context get ignored.',
        'عداد طلب (المكان) وعداد جيل (CRM المضيف) يجعلان الردود المتأخرة من السياق السابق تُتجاهل.',
      ),
    ),
    IsolationStep(
      title: LocalizedText('Session teardown', 'تفكيك الجلسة'),
      body: LocalizedText(
        'clear() on logout or a 401 drops every operator cache.',
        'clear() عند الخروج أو ٤٠١ يُسقط كل ذاكرة تشغيل.',
      ),
    ),
    IsolationStep(
      title: LocalizedText('Capability AND preference', 'الصلاحية و التفضيل معًا'),
      body: LocalizedText(
        'A revoked membership cannot keep a stale tenant on screen.',
        'عضوية ملغاة لا تُبقي مستأجرًا قديمًا على الشاشة.',
      ),
    ),
  ];

  static const challenges = <ChallengeCard>[
    ChallengeCard(
      problem: LocalizedText(
        'Multi-brand Host context',
        'سياق مضيف متعدد العلامات',
      ),
      solution: LocalizedText(
        'Persist and reconcile the active brand id, rebind host caches on every switch (shipped Sep 25).',
        'حفظ ومواءمة معرّف العلامة النشط، وإعادة ربط ذاكرة المضيف عند كل تبديل (أُطلق ٢٥ سبتمبر).',
      ),
      learned: LocalizedText('TODO_REPLACE', 'TODO_REPLACE'),
    ),
    ChallengeCard(
      problem: LocalizedText(
        'Three shells, one tab index',
        'ثلاثة أغلفة، فهرس تبويب واحد',
      ),
      solution: LocalizedText(
        'Mutual exclusion plus forcing Home so Member, Host and Venue tabs never collide.',
        'استبعاد متبادل مع فرض الرئيسية حتى لا تتصادم تبويبات العضو والمضيف والمكان.',
      ),
      learned: LocalizedText('TODO_REPLACE', 'TODO_REPLACE'),
    ),
    ChallengeCard(
      problem: LocalizedText('Venue async races', 'سباقات غير متزامنة للمكان'),
      solution: LocalizedText(
        'Overview and demand load in parallel with a request generation so a fast venue switch can never paint the wrong tenant.',
        'تحميل النظرة والطلب بالتوازي مع جيل طلب حتى لا يرسم تبديل مكان سريع المستأجر الخاطئ.',
      ),
      learned: LocalizedText('TODO_REPLACE', 'TODO_REPLACE'),
    ),
  ];

  // ── 07 Code ──
  static const codeHeadline = LocalizedText('From design to code', 'من التصميم إلى الكود');

  static const snippets = <CodeSnippet>[
    CodeSnippet(
      title: LocalizedText('Mode resolution', 'حل الوضع'),
      explanation: LocalizedText(
        'Capability + current mode decide the switch target: chooser, host, venue, or back to member.',
        'الصلاحية والوضع الحالي يحددان هدف التبديل: المختار، المضيف، المكان، أو العودة للعضو.',
      ),
      code: r'''OperatorSwitchTarget resolveOperatorSwitch({
  required bool hostModeActive,
  required bool venueModeActive,
  required bool canHost,
  required bool isVenueAdmin,
}) {
  if (hostModeActive || venueModeActive) return OperatorSwitchTarget.user;
  if (canHost && isVenueAdmin) return OperatorSwitchTarget.chooser;
  if (canHost) return OperatorSwitchTarget.host;
  if (isVenueAdmin) return OperatorSwitchTarget.venue;
  return OperatorSwitchTarget.user;
}''',
    ),
    CodeSnippet(
      title: LocalizedText('Mutual exclusion + tab reset', 'استبعاد متبادل وإعادة التبويب'),
      explanation: LocalizedText(
        'Host and Venue cannot both be on; switching forces Home so shells never share a stale tab.',
        'المضيف والمكان لا يعملان معًا؛ التبديل يفرض الرئيسية فلا تتشارك الأغلفة تبويبًا قديمًا.',
      ),
      code: r'''Future<void> _applyOperatorMode({required bool host, required bool venue}) async {
  if (host && venue) venue = false;
  _isHostModeActive = host;
  _isVenueModeActive = venue;
  _currentTabIndex = 0;
  // persist operator mode: host | venue | user
  notifyListeners();
}''',
    ),
    CodeSnippet(
      title: LocalizedText('Context isolation on brand bind', 'عزل السياق عند ربط العلامة'),
      explanation: LocalizedText(
        'When the active brand changes, host caches reset and refresh so brand A never paints under brand B.',
        'عند تغيّر العلامة النشطة تُصفَّر ذاكرة المضيف وتُحدَّث حتى لا تُرسم أ تحت ب.',
      ),
      code: r'''void bindApp(AppProvider app) {
  final brandId = app.activeHostBrand?.id;
  final brandChanged = brandId != _boundBrandId;
  _boundBrandId = brandId;
  if (brandChanged || modeTurnedOff) _resetAnalyticsCache();
  if (hostMode && (brandChanged || modeTurnedOn)) {
    unawaited(refreshAll(force: true));
  }
}''',
    ),
    CodeSnippet(
      title: LocalizedText('Stale-response guard', 'حماية الرد المتأخر'),
      explanation: LocalizedText(
        'A request counter drops late responses after a fast venue switch.',
        'عداد طلب يُسقط الردود المتأخرة بعد تبديل مكان سريع.',
      ),
      code: r'''final request = ++_request;
try {
  // fetch overview + demand in parallel
  if (request != _request) return;
  _overview = overview;
} catch (e, st) {
  if (request != _request) return;
  // log non-fatal; surface error string
}''',
    ),
  ];

  // ── 08 Quality ──
  static const qualityHeadline = LocalizedText('Quality bar', 'شريط الجودة');

  static const qualityFacts = <QualityFact>[
    QualityFact(
      label: LocalizedText('Tests', 'الاختبارات'),
      value: LocalizedText(
        '~70 cases (about 61 unit, 9 widget)',
        '~٧٠ حالة (حوالي ٦١ وحدة، ٩ ودجت)',
      ),
    ),
    QualityFact(
      label: LocalizedText('States', 'الحالات'),
      value: LocalizedText(
        'Loading, empty, error and load-more across screens',
        'تحميل، فارغ، خطأ وتحميل المزيد عبر الشاشات',
      ),
    ),
    QualityFact(
      label: LocalizedText('Locale', 'اللغة'),
      value: LocalizedText(
        'EN/AR with RTL (host + venueMode blocks)',
        'إن/عر مع RTL (كتل المضيف والمكان)',
      ),
    ),
    QualityFact(
      label: LocalizedText('Motion', 'الحركة'),
      value: LocalizedText(
        'Haptics and reduce-motion on mode pill and tabs',
        'اهتزاز واحترام تقليل الحركة على حبة الوضع والتبويبات',
      ),
    ),
    QualityFact(
      label: LocalizedText('Errors', 'الأخطاء'),
      value: LocalizedText(
        'Provider catch, non-fatal log, empty + retry',
        'التقاط المزوّد، سجل غير قاتل، فارغ + إعادة',
      ),
    ),
    QualityFact(
      label: LocalizedText('Integrations', 'التكاملات'),
      value: LocalizedText(
        'REST, SharedPreferences, ImagePicker + uploads, fl_chart, share_plus (CSV)',
        'REST و SharedPreferences و ImagePicker والرفع و fl_chart و share_plus (CSV)',
      ),
    ),
  ];

  // ── 09 Learnings ──
  static const learningsHeadline = LocalizedText('What I learned', 'ما تعلّمته');

  static const learnings = <LocalizedText>[
    LocalizedText(
      'Decide the isolation strategy before writing screens, not after.',
      'قرّر استراتيجية العزل قبل كتابة الشاشات، لا بعدها.',
    ),
    LocalizedText(
      'Persist the smallest thing you can, and re-check it against live capability.',
      'احفظ أصغر شيء ممكن، وأعد فحصه مقابل الصلاحية الحية.',
    ),
    LocalizedText(
      'A simple tool like SharedPreferences is the right tool when the data is tiny.',
      'أداة بسيطة مثل SharedPreferences هي الصحيحة عندما تكون البيانات صغيرة.',
    ),
  ];

  // ── Gallery ──
  static const galleryHeadline = LocalizedText('Screens', 'الشاشات');

  static const gallery = <GalleryShot>[
    GalleryShot(
      file: '01-switch-pill.png',
      caption: LocalizedText('Mode pill', 'حبة الوضع'),
      mode: OperatorRole.member,
    ),
    GalleryShot(
      file: '02-chooser.png',
      caption: LocalizedText('Chooser', 'المختار'),
      mode: OperatorRole.member,
    ),
    GalleryShot(
      file: '03-host-home.png',
      caption: LocalizedText('Host home', 'رئيسية المضيف'),
      mode: OperatorRole.host,
    ),
    GalleryShot(
      file: '04-host-schedule.png',
      caption: LocalizedText('Host schedule', 'جدول المضيف'),
      mode: OperatorRole.host,
    ),
    GalleryShot(
      file: '05-host-create.png',
      caption: LocalizedText('Create session', 'إنشاء جلسة'),
      mode: OperatorRole.host,
    ),
    GalleryShot(
      file: '06-host-door.png',
      caption: LocalizedText('Door', 'الباب'),
      mode: OperatorRole.host,
    ),
    GalleryShot(
      file: '07-host-crm.png',
      caption: LocalizedText('Community CRM', 'إدارة المجتمع'),
      mode: OperatorRole.host,
    ),
    GalleryShot(
      file: '08-host-analytics.png',
      caption: LocalizedText('Analytics', 'التحليلات'),
      mode: OperatorRole.host,
    ),
    GalleryShot(
      file: '09-venue-home.png',
      caption: LocalizedText('Venue home', 'رئيسية المكان'),
      mode: OperatorRole.venue,
    ),
    GalleryShot(
      file: '10-venue-schedule.png',
      caption: LocalizedText('Venue schedule', 'جدول المكان'),
      mode: OperatorRole.venue,
    ),
    GalleryShot(
      file: '11-venue-detail.png',
      caption: LocalizedText('Gathering detail', 'تفاصيل اللقاء'),
      mode: OperatorRole.venue,
    ),
    GalleryShot(
      file: '12-venue-visitors.png',
      caption: LocalizedText('Visitors', 'الزوار'),
      mode: OperatorRole.venue,
    ),
    GalleryShot(
      file: '13-venue-performance.png',
      caption: LocalizedText('Performance', 'الأداء'),
      mode: OperatorRole.venue,
    ),
    GalleryShot(
      file: '14-ar-host-home.png',
      caption: LocalizedText('Host home · AR', 'رئيسية المضيف · عربي'),
      mode: OperatorRole.host,
    ),
    GalleryShot(
      file: '15-dark-venue-home.png',
      caption: LocalizedText('Venue home · dark', 'رئيسية المكان · داكن'),
      mode: OperatorRole.venue,
    ),
  ];

  // ── Features I owned card (GatherUp case study) ──
  static const ownedFeatureTitle = LocalizedText(
    'Host & Venue Mode',
    'وضع المضيف والمكان',
  );
  static const ownedFeatureSummary = LocalizedText(
    'Operator shells for hosts and venues inside the member app — sessions, door, CRM, analytics, and a read-mostly venue diary.',
    'أغلفة تشغيل للمضيفين والأماكن داخل تطبيق الأعضاء — جلسات، باب، إدارة مجتمع، تحليلات، ويوميات مكان للقراءة غالبًا.',
  );

  // ── Home experience line ──
  static const experienceBullet = LocalizedText(
    'Built Host & Venue Mode end-to-end (Flutter)',
    'بناء وضع المضيف والمكان من الطرف إلى الطرف (فلاتر)',
  );

  // ── Architecture note ──
  static const archNote = LocalizedText(
    'Provider with ChangeNotifierProxyProvider binds Host/Venue to App on every identity change; the shell swap happens in one AuthenticatedAppShell consumer.',
    'المزوّد مع ChangeNotifierProxyProvider يربط المضيف/المكان بالتطبيق عند كل تغيّر هوية؛ تبديل الغلاف يحدث في مستهلك AuthenticatedAppShell واحد.',
  );

  static const statusMachineFootnote = LocalizedText(
    'Venue Mode shows statuses only. Venues cannot trigger transitions.',
    'وضع المكان يعرض الحالات فقط. الأماكن لا تُطلق الانتقالات.',
  );

  static const flowsHeadline = LocalizedText('Flows', 'التدفقات');
  static const isolationStackLabel = LocalizedText('Isolation stack', 'مكدس العزل');
  static const raceVisualLabel = LocalizedText(
    'Late response discarded',
    'الرد المتأخر يُتجاهل',
  );
}
