import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/cursor_controller.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/project_copy.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_code_section.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_experience_section.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_loop_section.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_motion_section.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_problem_section.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_study_nav.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_study_progress.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_system_section.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_thinking_section.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/comic_burst.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/project_image_slot.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/zine_background.dart';

/// GatherUp (and future) case study. 7A–7C shell through Design + Code.
class CaseStudyPage extends StatefulWidget {
  const CaseStudyPage({super.key, required this.slug});

  final String slug;

  @override
  State<CaseStudyPage> createState() => _CaseStudyPageState();
}

class _CaseStudyPageState extends State<CaseStudyPage> {
  final _scroll = ScrollController();
  final _parallax = ValueNotifier<Offset>(Offset.zero);
  final _scrollOffset = ValueNotifier<double>(0);
  final _activeSection = ValueNotifier<CaseStudySectionId?>(null);

  late final List<CaseStudySectionAnchor> _anchors = [
    for (final id in CaseStudySectionId.values) CaseStudySectionAnchor(id),
  ];

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
    _parallax.dispose();
    _scrollOffset.dispose();
    _activeSection.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    if (_scroll.hasClients) _scrollOffset.value = _scroll.offset;
    final viewH = MediaQuery.sizeOf(context).height;
    CaseStudySectionId? best;
    var bestScore = double.infinity;

    for (final a in _anchors) {
      final ctx = a.key.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final dy = box.localToGlobal(Offset.zero).dy;
      if (dy > viewH * 0.7) continue;
      final score = (dy - 140).abs();
      if (score < bestScore) {
        bestScore = score;
        best = a.id;
      }
    }

    if (best != _activeSection.value) {
      _activeSection.value = best;
    }
  }

  Future<void> _scrollTo(CaseStudySectionId id) async {
    final anchor = _anchors.firstWhere((a) => a.id == id);
    final ctx = anchor.key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 750),
      curve: Curves.easeInOutCubic,
      alignment: 0.12,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 700;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
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
                mobile: mobile,
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

    return Scaffold(
      backgroundColor: zine.canvas,
      body: ZineBackground(
        parallax: _parallax,
        child: Stack(
          children: [
            Column(
              children: [
                CaseStudyNav(
                  title: title,
                  customCursor: customCursor,
                  mobile: mobile,
                ),
                Expanded(
                  child: CustomScrollView(
                    controller: _scroll,
                    physics: const ClampingScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            24,
                            28,
                            mobile ? 24 : 88,
                            48,
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1000),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _CaseStudyHero(
                                  study: study,
                                  title: title,
                                  mobile: mobile,
                                  reduceMotion: reduceMotion,
                                  customCursor: customCursor,
                                ),
                                const SizedBox(height: 56),
                                for (final a in _anchors) ...[
                                  KeyedSubtree(
                                    key: a.key,
                                    child: _sectionFor(
                                      a.id,
                                      study: study,
                                      reduceMotion: reduceMotion,
                                      customCursor: customCursor,
                                    ),
                                  ),
                                  const SizedBox(height: 56),
                                ],
                                const SizedBox(height: 40),
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
                right: 20,
                top: 0,
                bottom: 0,
                child: Center(
                  child: CaseStudyProgressRail(
                    anchors: _anchors,
                    activeId: _activeSection,
                    customCursor: customCursor,
                    onSelect: _scrollTo,
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

  Widget _sectionFor(
    CaseStudySectionId id, {
    required CaseStudy study,
    required bool reduceMotion,
    required bool customCursor,
  }) {
    return switch (id) {
      CaseStudySectionId.problem => CaseProblemSection(
          study: study,
          scrollOffset: _scrollOffset,
          reduceMotion: reduceMotion,
          customCursor: customCursor,
        ),
      CaseStudySectionId.product => CaseLoopSection(
          study: study,
          scrollOffset: _scrollOffset,
          reduceMotion: reduceMotion,
          customCursor: customCursor,
        ),
      CaseStudySectionId.thinking => CaseThinkingSection(
          study: study,
          scrollOffset: _scrollOffset,
          reduceMotion: reduceMotion,
          customCursor: customCursor,
        ),
      CaseStudySectionId.experience => CaseExperienceSection(
          study: study,
          scrollOffset: _scrollOffset,
          reduceMotion: reduceMotion,
          customCursor: customCursor,
        ),
      CaseStudySectionId.system => CaseSystemSection(
          study: study,
          scrollOffset: _scrollOffset,
          reduceMotion: reduceMotion,
          customCursor: customCursor,
        ),
      CaseStudySectionId.motion => CaseMotionSection(
          study: study,
          scrollOffset: _scrollOffset,
          reduceMotion: reduceMotion,
          customCursor: customCursor,
        ),
      CaseStudySectionId.code => CaseCodeSection(
          study: study,
          scrollOffset: _scrollOffset,
          reduceMotion: reduceMotion,
          customCursor: customCursor,
        ),
      _ => const SizedBox(height: 1),
    };
  }
}

class _CaseStudyHero extends StatelessWidget {
  const _CaseStudyHero({
    required this.study,
    required this.title,
    required this.mobile,
    required this.reduceMotion,
    required this.customCursor,
  });

  final CaseStudy study;
  final String title;
  final bool mobile;
  final bool reduceMotion;
  final bool customCursor;

  String? _meta(AppLocalizations l10n, String? key) {
    if (key == null) return null;
    final v = CaseStudyCopy.t(l10n, key);
    return isTodo(v) ? null : v;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final tagline = CaseStudyCopy.t(l10n, study.heroTaglineKey);
    final brush = study.heroBrushKey == null
        ? null
        : _meta(l10n, study.heroBrushKey);
    final credit = study.creditKey == null
        ? null
        : CaseStudyCopy.t(l10n, study.creditKey!);

    final market = _meta(l10n, study.marketMetaKey);
    final platform = _meta(l10n, study.platformMetaKey);
    final locale = _meta(l10n, study.localeMetaKey);
    final stack = _meta(l10n, study.stackMetaKey);

    final titleStyle = (isAr
            ? GoogleFonts.reemKufi(
                fontSize: mobile ? 44.0 : 64.0,
                height: 0.95,
                fontWeight: FontWeight.w700,
                color: zine.ink,
              )
            : GoogleFonts.bebasNeue(
                fontSize: mobile ? 52.0 : 72.0,
                height: 0.9,
                letterSpacing: 1.5,
                color: zine.ink,
              ))
        .copyWith(decoration: TextDecoration.none);

    final brushStyle = (isAr
            ? GoogleFonts.reemKufi(
                fontSize: mobile ? 28.0 : 40.0,
                fontWeight: FontWeight.w700,
                color: AppColors.flutterLightBlue,
              )
            : GoogleFonts.permanentMarker(
                fontSize: mobile ? 32.0 : 44.0,
                color: AppColors.flutterLightBlue,
              ))
        .copyWith(decoration: TextDecoration.none);

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
        const SizedBox(height: 10),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 10,
          children: [
            Text(title, style: titleStyle),
            if (brush != null)
              Transform.rotate(
                angle: -0.06,
                child: Text(brush, style: brushStyle),
              ),
          ],
        ),
        if (!isTodo(tagline)) ...[
          const SizedBox(height: 12),
          Text(
            tagline,
            style: GoogleFonts.kalam(
              fontSize: mobile ? 16 : 18,
              height: 1.35,
              color: zine.inkMuted,
              decoration: TextDecoration.none,
            ),
          ),
        ],
        if (study.heroTags.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            study.heroTags.join(' · '),
            style: GoogleFonts.spaceMono(
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
              color: zine.ink.withValues(alpha: 0.8),
              decoration: TextDecoration.none,
            ),
          ),
        ],
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (market != null)
              _MetaSticker(
                label: l10n.caseMetaMarket,
                value: market,
                tilt: -0.03,
              ),
            if (platform != null)
              _MetaSticker(
                label: l10n.caseMetaPlatform,
                value: platform,
                tilt: 0.035,
              ),
            if (locale != null)
              _MetaSticker(
                label: l10n.caseMetaLocale,
                value: locale,
                tilt: -0.02,
              ),
            if (stack != null)
              _MetaSticker(
                label: l10n.caseMetaStack,
                value: stack,
                tilt: 0.025,
              ),
          ],
        ),
        if (credit != null && !isTodo(credit)) ...[
          const SizedBox(height: 18),
          Text(
            credit,
            style: GoogleFonts.spaceMono(
              fontSize: 11,
              height: 1.45,
              color: zine.inkMuted,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ],
    );

    final phone = SizedBox(
      width: mobile ? 170 : 210,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Opacity(
            opacity: 0.28,
            child: ComicBurst(
              size: mobile ? 260 : 320,
              reduceMotion: reduceMotion,
              mobile: mobile,
            ),
          ),
          ProjectImageSlot(
            assetPath: study.heroImagePath,
            label: title,
            phoneFrame: true,
          ),
        ],
      ),
    );

    if (mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          copy,
          const SizedBox(height: 32),
          Center(child: phone),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 6, child: copy),
        const SizedBox(width: 28),
        Expanded(flex: 4, child: Center(child: phone)),
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
        constraints: const BoxConstraints(maxWidth: 210),
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
