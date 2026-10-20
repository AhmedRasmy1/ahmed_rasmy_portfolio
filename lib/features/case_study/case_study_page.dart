import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/cursor_controller.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/project_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/paper_card.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/architecture_diagram.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_study_nav.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_study_progress.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/project_image_slot.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/zine_background.dart';

class CaseStudyPage extends StatefulWidget {
  const CaseStudyPage({super.key, required this.slug});

  final String slug;

  @override
  State<CaseStudyPage> createState() => _CaseStudyPageState();
}

class _CaseStudyPageState extends State<CaseStudyPage> {
  final _scroll = ScrollController();
  final _scrollOffset = ValueNotifier<double>(0);
  final _parallax = ValueNotifier<Offset>(Offset.zero);
  final _heroKey = GlobalKey();
  final _productKey = GlobalKey();
  final _roleKey = GlobalKey();
  final _archKey = GlobalKey();
  final _screensKey = GlobalKey();
  final _challengesKey = GlobalKey();
  final _resultsKey = GlobalKey();
  final _learnKey = GlobalKey();
  final _nextKey = GlobalKey();

  String? _activeId;
  double _archProgress = 0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    _scrollOffset.dispose();
    _parallax.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    _scrollOffset.value = _scroll.hasClients ? _scroll.offset : 0;
    final viewH = MediaQuery.sizeOf(context).height;

    final refs = <(String, GlobalKey)>[
      ('hero', _heroKey),
      ('product', _productKey),
      ('role', _roleKey),
      ('arch', _archKey),
      ('screens', _screensKey),
      ('challenges', _challengesKey),
      ('results', _resultsKey),
      ('learn', _learnKey),
      ('next', _nextKey),
    ];

    String? best;
    var bestScore = double.infinity;
    for (final (id, key) in refs) {
      final ctx = key.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final dy = box.localToGlobal(Offset.zero).dy;
      if (dy > viewH * 0.65) continue;
      final score = (dy - 120).abs();
      if (score < bestScore) {
        bestScore = score;
        best = id;
      }
    }

    final archCtx = _archKey.currentContext;
    var archP = _archProgress;
    if (archCtx != null) {
      final box = archCtx.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        final top = box.localToGlobal(Offset.zero).dy;
        archP = ((viewH * 0.8 - top) / (viewH * 0.55)).clamp(0.0, 1.0);
      }
    }

    if (best != _activeId || (archP - _archProgress).abs() > 0.02) {
      setState(() {
        _activeId = best;
        _archProgress = archP;
      });
    }
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
      alignment: 0.08,
    );
  }

  IconData _icon(String name) => switch (name) {
        'event' => Icons.event_available_outlined,
        'lock' => Icons.lock_outline,
        'api' => Icons.hub_outlined,
        'storage' => Icons.storage_outlined,
        'map' => Icons.map_outlined,
        'notifications' => Icons.notifications_outlined,
        'chat' => Icons.chat_bubble_outline,
        'devices' => Icons.devices_outlined,
        _ => Icons.circle_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 700;
    final customCursor = cursorController.enabled && !mobile;
    final project = PortfolioData.projectBySlug(widget.slug);
    final study = PortfolioData.caseStudyBySlug(widget.slug);

    if (project == null || study == null) {
      return Scaffold(
        backgroundColor: zine.canvas,
        body: ZineBackground(
          parallax: _parallax,
          child: Column(
            children: [
              CaseStudyNav(
                title: widget.slug,
                customCursor: customCursor,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    l10n.caseComingSoon,
                    style: GoogleFonts.kalam(
                      fontSize: 18,
                      color: zine.inkMuted,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final title = ProjectCopy.title(l10n, project);
    String t(String key) => CaseStudyCopy.t(l10n, key);

    final filledChallenges = study.challenges.where((c) {
      return !isTodo(t(c.problemKey)) &&
          !isTodo(t(c.solutionKey)) &&
          !isTodo(t(c.learnedKey));
    }).toList();
    final filledStats =
        study.stats.where((s) => !isTodo(s.value)).toList();
    final filledLearnings =
        study.learningKeys.map(t).where((s) => !isTodo(s)).toList();

    final nextProject = study.nextSlug == null
        ? null
        : PortfolioData.projectBySlug(study.nextSlug!);

    final railSections = <CaseStudySectionRef>[
      CaseStudySectionRef(id: 'hero', label: '01', key: _heroKey),
      CaseStudySectionRef(id: 'product', label: '02', key: _productKey),
      CaseStudySectionRef(id: 'role', label: '03', key: _roleKey),
      CaseStudySectionRef(id: 'arch', label: '04', key: _archKey),
      CaseStudySectionRef(id: 'screens', label: '05', key: _screensKey),
      if (filledChallenges.isNotEmpty)
        CaseStudySectionRef(
          id: 'challenges',
          label: '06',
          key: _challengesKey,
        ),
      if (filledStats.isNotEmpty)
        CaseStudySectionRef(id: 'results', label: '07', key: _resultsKey),
      if (filledLearnings.isNotEmpty)
        CaseStudySectionRef(id: 'learn', label: '08', key: _learnKey),
      CaseStudySectionRef(id: 'next', label: '→', key: _nextKey),
    ];

    final bodyStyle = GoogleFonts.kalam(
      fontSize: 16,
      height: 1.5,
      color: zine.inkMuted,
      decoration: TextDecoration.none,
    );

    return Scaffold(
      backgroundColor: zine.canvas,
      body: ZineBackground(
        parallax: _parallax,
        child: Stack(
          children: [
            Column(
              children: [
                CaseStudyNav(title: title, customCursor: customCursor),
                Expanded(
                  child: CustomScrollView(
                    controller: _scroll,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            24,
                            24,
                            mobile ? 24 : 110,
                            64,
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 980),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ── Hero ──
                                KeyedSubtree(
                                  key: _heroKey,
                                  child: _HeroBlock(
                                    study: study,
                                    title: title,
                                    customCursor: customCursor,
                                    mobile: mobile,
                                    bodyStyle: bodyStyle,
                                  ),
                                ),
                                const SizedBox(height: 56),

                                // ── 01 Product ──
                                KeyedSubtree(
                                  key: _productKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SectionHeader(
                                        number: '01',
                                        eyebrow: l10n.caseSecProduct,
                                        title: l10n.caseSecProductTitle,
                                        intro: l10n.caseSecProductIntro,
                                        scrollOffset: _scrollOffset,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(t(study.productP1Key), style: bodyStyle),
                                      const SizedBox(height: 12),
                                      Text(t(study.productP2Key), style: bodyStyle),
                                      const SizedBox(height: 28),
                                      _LoopDiagram(
                                        steps: study.loopSteps,
                                        customCursor: customCursor,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 56),

                                // ── 02 Role ──
                                KeyedSubtree(
                                  key: _roleKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SectionHeader(
                                        number: '02',
                                        eyebrow: l10n.caseSecRole,
                                        title: l10n.caseSecRoleTitle,
                                        intro: l10n.caseSecRoleIntro,
                                        scrollOffset: _scrollOffset,
                                      ),
                                      const SizedBox(height: 24),
                                      Wrap(
                                        spacing: 14,
                                        runSpacing: 14,
                                        children: [
                                          for (var i = 0;
                                              i < study.roleNotes.length;
                                              i++)
                                            SizedBox(
                                              width: mobile
                                                  ? double.infinity
                                                  : (width < 900
                                                      ? (width - 48 - 14) / 2
                                                      : 220),
                                              child: _RoleNote(
                                                note: study.roleNotes[i],
                                                icon: _icon(
                                                  study.roleNotes[i].icon,
                                                ),
                                                tilt: ((i % 2 == 0) ? -1 : 1) *
                                                    0.02,
                                                customCursor: customCursor,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 56),

                                // ── 03 Architecture ──
                                KeyedSubtree(
                                  key: _archKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SectionHeader(
                                        number: '03',
                                        eyebrow: l10n.caseSecArch,
                                        title: l10n.caseSecArchTitle,
                                        intro: l10n.caseSecArchIntro,
                                        scrollOffset: _scrollOffset,
                                      ),
                                      const SizedBox(height: 24),
                                      PaperCard(
                                        tilt: 0.01,
                                        child: ArchitectureDiagram(
                                          progress: _archProgress,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        t(study.architectureWhyKey),
                                        style: bodyStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 56),

                                // ── 04 Screens ──
                                KeyedSubtree(
                                  key: _screensKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SectionHeader(
                                        number: '04',
                                        eyebrow: l10n.caseSecScreens,
                                        title: l10n.caseSecScreensTitle,
                                        intro: l10n.caseSecScreensIntro,
                                        scrollOffset: _scrollOffset,
                                      ),
                                      const SizedBox(height: 24),
                                      _ScreensGallery(
                                        study: study,
                                        customCursor: customCursor,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 56),

                                // ── 05 Challenges (hidden until filled) ──
                                KeyedSubtree(
                                  key: _challengesKey,
                                  child: filledChallenges.isEmpty
                                      ? const SizedBox.shrink()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SectionHeader(
                                              number: '05',
                                              eyebrow: l10n.caseSecChallenges,
                                              title: l10n.caseSecChallengesTitle,
                                              intro: l10n.caseSecChallengesIntro,
                                              scrollOffset: _scrollOffset,
                                            ),
                                            const SizedBox(height: 24),
                                            for (final c
                                                in filledChallenges) ...[
                                              _ChallengeTrio(
                                                challenge: c,
                                                customCursor: customCursor,
                                              ),
                                              const SizedBox(height: 16),
                                            ],
                                            const SizedBox(height: 40),
                                          ],
                                        ),
                                ),

                                // ── 06 Results ──
                                KeyedSubtree(
                                  key: _resultsKey,
                                  child: filledStats.isEmpty
                                      ? const SizedBox.shrink()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SectionHeader(
                                              number: '06',
                                              eyebrow: l10n.caseSecResults,
                                              title: l10n.caseSecResultsTitle,
                                              intro: l10n.caseSecResultsIntro,
                                              scrollOffset: _scrollOffset,
                                            ),
                                            const SizedBox(height: 24),
                                            Wrap(
                                              spacing: 14,
                                              runSpacing: 14,
                                              children: [
                                                for (var i = 0;
                                                    i < filledStats.length;
                                                    i++)
                                                  _StatSticker(
                                                    label: t(
                                                      filledStats[i].labelKey,
                                                    ),
                                                    value: filledStats[i].value!,
                                                    tilt: ((i % 2 == 0)
                                                            ? -1
                                                            : 1) *
                                                        0.04,
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 56),
                                          ],
                                        ),
                                ),

                                // ── 07 Learnings ──
                                KeyedSubtree(
                                  key: _learnKey,
                                  child: filledLearnings.isEmpty
                                      ? const SizedBox.shrink()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SectionHeader(
                                              number: '07',
                                              eyebrow: l10n.caseSecLearn,
                                              title: l10n.caseSecLearnTitle,
                                              intro: l10n.caseSecLearnIntro,
                                              scrollOffset: _scrollOffset,
                                            ),
                                            const SizedBox(height: 20),
                                            for (final note
                                                in filledLearnings)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 10,
                                                ),
                                                child: PaperCard(
                                                  tilt: -0.01,
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: Text(
                                                    '•  $note',
                                                    style: bodyStyle.copyWith(
                                                      color: AppColors.navyInk,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            const SizedBox(height: 56),
                                          ],
                                        ),
                                ),

                                // ── Next ──
                                KeyedSubtree(
                                  key: _nextKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (nextProject != null) ...[
                                        Text(
                                          l10n.caseNextLabel.toUpperCase(),
                                          style: GoogleFonts.spaceMono(
                                            fontSize: 11,
                                            letterSpacing: 1.6,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.flutterLightBlue,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        CursorTarget(
                                          enabled: customCursor,
                                          label: 'VIEW',
                                          child: PaperCard(
                                            tilt: 0.015,
                                            onTap: () => context.go(
                                              '/work/${nextProject.slug}',
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        ProjectCopy.title(
                                                          l10n,
                                                          nextProject,
                                                        ),
                                                        style: GoogleFonts
                                                            .bebasNeue(
                                                          fontSize: 28,
                                                          color: AppColors
                                                              .navyInk,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                      Text(
                                                        ProjectCopy.tagline(
                                                          l10n,
                                                          nextProject,
                                                        ),
                                                        style:
                                                            GoogleFonts.kalam(
                                                          fontSize: 14,
                                                          color: AppColors
                                                              .navyInk
                                                              .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  color: AppColors.flutterBlue,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                      CursorTarget(
                                        enabled: customCursor,
                                        child: TextButton(
                                          onPressed: () => context.go('/'),
                                          child: Text(
                                            l10n.caseAllStudies,
                                            style: GoogleFonts.spaceMono(
                                              fontSize: 12,
                                              letterSpacing: 1.2,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.flutterBlue,
                                              decoration: TextDecoration.none,
                                            ),
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!mobile)
              Positioned(
                right: 18,
                top: 0,
                bottom: 0,
                child: Center(
                  child: CaseStudyProgressRail(
                    sections: railSections,
                    activeId: _activeId,
                    customCursor: customCursor,
                    onSelect: (id) {
                      final key = railSections
                          .firstWhere((s) => s.id == id)
                          .key;
                      _scrollTo(key);
                    },
                  ),
                ),
              ),
            if (customCursor)
              Positioned.fill(
                child: CustomCursorOverlay(controller: cursorController),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeroBlock extends StatelessWidget {
  const _HeroBlock({
    required this.study,
    required this.title,
    required this.customCursor,
    required this.mobile,
    required this.bodyStyle,
  });

  final CaseStudy study;
  final String title;
  final bool customCursor;
  final bool mobile;
  final TextStyle bodyStyle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    String t(String key) => CaseStudyCopy.t(l10n, key);

    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.caseStudyLabel,
          style: GoogleFonts.spaceMono(
            fontSize: 11,
            letterSpacing: 2.2,
            fontWeight: FontWeight.w700,
            color: AppColors.flutterLightBlue,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.bebasNeue(
            fontSize: mobile ? 48 : 64,
            letterSpacing: 1.5,
            color: zine.ink,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          t(study.heroTaglineKey),
          style: GoogleFonts.kalam(
            fontSize: 18,
            color: zine.inkMuted,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tag in study.heroTags)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.flutterBlue.withValues(alpha: 0.45),
                  ),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                    color: zine.ink,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _MetaSticker(
              label: l10n.caseMetaRole,
              value: t(study.roleMetaKey),
              tilt: -0.03,
            ),
            _MetaSticker(
              label: l10n.caseMetaPlatform,
              value: t(study.platformMetaKey),
              tilt: 0.04,
            ),
            _MetaSticker(
              label: l10n.caseMetaPeriod,
              value: t(study.periodMetaKey),
              tilt: -0.02,
            ),
            _MetaSticker(
              label: l10n.caseMetaStack,
              value: t(study.stackMetaKey),
              tilt: 0.03,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          t(study.creditKey),
          style: GoogleFonts.spaceMono(
            fontSize: 11,
            height: 1.45,
            color: zine.inkMuted,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );

    final phone = SizedBox(
      width: mobile ? 180 : 220,
      child: ProjectImageSlot(
        assetPath: study.heroImagePath,
        label: title,
        phoneFrame: true,
      ),
    );

    if (mobile) {
      return Column(
        children: [
          copy,
          const SizedBox(height: 28),
          Center(child: phone),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: copy),
        const SizedBox(width: 32),
        phone,
      ],
    );
  }
}

class _MetaSticker extends StatelessWidget {
  const _MetaSticker({
    required this.label,
    required this.value,
    required this.tilt,
  });

  final String label;
  final String value;
  final double tilt;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: tilt,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.paper,
          boxShadow: [
            BoxShadow(
              color: AppColors.navyInk.withValues(alpha: 0.16),
              blurRadius: 8,
              offset: const Offset(1, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: GoogleFonts.spaceMono(
                fontSize: 9,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
                color: AppColors.flutterBlue,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.kalam(
                fontSize: 13,
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

class _LoopDiagram extends StatelessWidget {
  const _LoopDiagram({
    required this.steps,
    required this.customCursor,
  });

  final List<CaseStudyLoopStep> steps;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0)
            Icon(
              Icons.arrow_forward,
              size: 16,
              color: AppColors.flutterLightBlue.withValues(alpha: 0.7),
            ),
          _LoopStepChip(
            step: steps[i],
            customCursor: customCursor,
          ),
        ],
      ],
    );
  }
}

class _LoopStepChip extends StatefulWidget {
  const _LoopStepChip({
    required this.step,
    required this.customCursor,
  });

  final CaseStudyLoopStep step;
  final bool customCursor;

  @override
  State<_LoopStepChip> createState() => _LoopStepChipState();
}

class _LoopStepChipState extends State<_LoopStepChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = CaseStudyCopy.t(l10n, widget.step.titleKey);
    final detail = CaseStudyCopy.t(l10n, widget.step.detailKey);

    return CursorTarget(
      enabled: widget.customCursor,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: _hover ? 200 : 120,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _hover
                ? AppColors.flutterBlue
                : AppColors.paper.withValues(alpha: 0.9),
            border: Border.all(
              color: AppColors.flutterLightBlue.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: GoogleFonts.spaceMono(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                  color: _hover ? AppColors.offWhite : AppColors.navyInk,
                  decoration: TextDecoration.none,
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    detail,
                    style: GoogleFonts.kalam(
                      fontSize: 13,
                      color: AppColors.offWhite.withValues(alpha: 0.9),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                crossFadeState: _hover
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleNote extends StatelessWidget {
  const _RoleNote({
    required this.note,
    required this.icon,
    required this.tilt,
    required this.customCursor,
  });

  final CaseStudyRoleNote note;
  final IconData icon;
  final double tilt;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = CaseStudyCopy.t(l10n, note.titleKey);
    final detail = note.detailKey == null
        ? null
        : CaseStudyCopy.t(l10n, note.detailKey!);
    final showDetail = detail != null && !isTodo(detail);

    return CursorTarget(
      enabled: customCursor,
      child: PaperCard(
        tilt: tilt,
        padding: const EdgeInsets.fromLTRB(14, 26, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.flutterBlue, size: 22),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.bebasNeue(
                fontSize: 18,
                color: AppColors.navyInk,
                decoration: TextDecoration.none,
              ),
            ),
            if (showDetail) ...[
              const SizedBox(height: 6),
              Text(
                detail,
                style: GoogleFonts.kalam(
                  fontSize: 13,
                  color: AppColors.navyInk.withValues(alpha: 0.75),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ScreensGallery extends StatelessWidget {
  const _ScreensGallery({
    required this.study,
    required this.customCursor,
  });

  final CaseStudy study;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 360,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: study.screens.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          final s = study.screens[i];
          final caption = CaseStudyCopy.t(l10n, s.captionKey);
          return CursorTarget(
            enabled: customCursor,
            child: SizedBox(
              width: 160,
              child: Column(
                children: [
                  Expanded(
                    child: ProjectImageSlot(
                      assetPath: s.assetPath(study.projectSlug),
                      label: caption,
                      phoneFrame: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    caption,
                    style: GoogleFonts.spaceMono(
                      fontSize: 11,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w700,
                      color: context.zine.ink,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChallengeTrio extends StatelessWidget {
  const _ChallengeTrio({
    required this.challenge,
    required this.customCursor,
  });

  final CaseStudyChallenge challenge;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cells = [
      (l10n.caseChallengeProblem, challenge.problemKey),
      (l10n.caseChallengeSolution, challenge.solutionKey),
      (l10n.caseChallengeLearned, challenge.learnedKey),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        final narrow = c.maxWidth < 720;
        final cards = [
          for (var i = 0; i < cells.length; i++)
            PaperCard(
              tilt: ((i % 2 == 0) ? -1 : 1) * 0.015,
              padding: const EdgeInsets.fromLTRB(14, 26, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cells[i].$1.toUpperCase(),
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.w700,
                      color: AppColors.flutterBlue,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    CaseStudyCopy.t(l10n, cells[i].$2),
                    style: GoogleFonts.kalam(
                      fontSize: 14,
                      color: AppColors.navyInk,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
        ];

        if (narrow) {
          return Column(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                cards[i],
              ],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(child: cards[i]),
            ],
          ],
        );
      },
    );
  }
}

class _StatSticker extends StatelessWidget {
  const _StatSticker({
    required this.label,
    required this.value,
    required this.tilt,
  });

  final String label;
  final String value;
  final double tilt;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: tilt,
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.stickyYellow,
          boxShadow: [
            BoxShadow(
              color: AppColors.navyInk.withValues(alpha: 0.18),
              blurRadius: 10,
              offset: const Offset(2, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.bebasNeue(
                fontSize: 32,
                color: AppColors.navyInk,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
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
