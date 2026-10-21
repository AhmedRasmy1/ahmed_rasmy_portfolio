import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/project_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/navigation/home_sections.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/paper_card.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/featured_hero_visual.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/project_image_slot.dart';

class WorkSection extends StatefulWidget {
  const WorkSection({
    super.key,
    this.scrollOffset,
    this.reduceMotion = false,
    this.customCursor = false,
  });

  final ValueNotifier<double>? scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  State<WorkSection> createState() => _WorkSectionState();
}

class _WorkSectionState extends State<WorkSection> {
  ProjectFilter _filter = ProjectFilter.all;

  static const _tapeColors = [
    Color(0xE6A8C8E0),
    Color(0xE613B9FD),
    Color(0xE6E8C96A),
    Color(0xE68BB4D4),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 600;

    final filtered =
        PortfolioData.projects.where((p) => p.matchesFilter(_filter)).toList();
    final featured = filtered.where((p) => p.featured).toList();
    final others = filtered.where((p) => !p.featured).toList();

    return KeyedSubtree(
      key: HomeSectionKeys.key(HomeSection.work),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 72),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              number: HomeSection.work.numberLabel,
              eyebrow: l10n.secWorkEyebrow,
              title: l10n.secWorkTitle,
              intro: l10n.secWorkIntro,
              scrollOffset: widget.scrollOffset,
              reduceMotion: widget.reduceMotion,
            ),
            const SizedBox(height: 28),
            _FilterTabs(
              selected: _filter,
              customCursor: widget.customCursor,
              onChanged: (f) => setState(() => _filter = f),
            ),
            const SizedBox(height: 28),
            AnimatedSize(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: Column(
                  key: ValueKey(_filter),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final project in featured) ...[
                      KeyedSubtree(
                        key: PortfolioScrollTargets.keyForProject(project.slug),
                        child: _FeaturedCard(
                          project: project,
                          customCursor: widget.customCursor,
                          reduceMotion: widget.reduceMotion,
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                    if (others.isNotEmpty)
                      _ProjectGrid(
                        projects: others,
                        mobile: mobile,
                        tapeColors: _tapeColors,
                        customCursor: widget.customCursor,
                      ),
                    if (featured.isEmpty && others.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          l10n.sectionPlaceholder,
                          style: GoogleFonts.spaceMono(
                            fontSize: 12,
                            color: context.zine.inkMuted,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.selected,
    required this.onChanged,
    required this.customCursor,
  });

  final ProjectFilter selected;
  final ValueChanged<ProjectFilter> onChanged;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final items = <(ProjectFilter, String)>[
      (ProjectFilter.all, l10n.filterAll),
      (ProjectFilter.mobile, l10n.filterMobile),
      (ProjectFilter.web, l10n.filterWeb),
      (ProjectFilter.desktop, l10n.filterDesktop),
    ];
    final selectedIndex =
        items.indexWhere((e) => e.$1 == selected).clamp(0, items.length - 1);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: zine.canvasDeep.withValues(alpha: 0.5),
        border: Border.all(color: zine.divider),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabW = constraints.maxWidth / items.length;
          return SizedBox(
            height: 36,
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  left: Directionality.of(context) == TextDirection.rtl
                      ? null
                      : selectedIndex * tabW,
                  right: Directionality.of(context) == TextDirection.rtl
                      ? selectedIndex * tabW
                      : null,
                  top: 0,
                  bottom: 0,
                  width: tabW,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.flutterBlue,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Row(
                  children: [
                    for (final (filter, label) in items)
                      Expanded(
                        child: CursorTarget(
                          enabled: customCursor,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => onChanged(filter),
                            child: Center(
                              child: Text(
                                label,
                                style: GoogleFonts.spaceMono(
                                  fontSize: 11,
                                  letterSpacing: 1.1,
                                  fontWeight: FontWeight.w700,
                                  color: selected == filter
                                      ? AppColors.offWhite
                                      : zine.ink,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.project,
    required this.customCursor,
    this.reduceMotion = false,
  });

  final Project project;
  final bool customCursor;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final narrow = width < 900;
    final hero = FeaturedHeroVisual(
      assetPath: project.heroImagePath,
      isMockup: project.heroIsMockup,
      reduceMotion: reduceMotion,
      maxWidth: narrow ? 150 : 180,
    );

    return CursorTarget(
      enabled: customCursor,
      label: 'VIEW',
      child: PaperCard(
        tilt: 0.01,
        tapeColor: AppColors.flutterLightBlue.withValues(alpha: 0.85),
        child: narrow
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: hero),
                  const SizedBox(height: 20),
                  _FeaturedCopy(project: project, customCursor: customCursor),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  hero,
                  const SizedBox(width: 28),
                  Expanded(
                    child: _FeaturedCopy(
                      project: project,
                      customCursor: customCursor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _FeaturedCopy extends StatelessWidget {
  const _FeaturedCopy({
    required this.project,
    required this.customCursor,
  });

  final Project project;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final title = ProjectCopy.title(l10n, project);
    final tagline = ProjectCopy.tagline(l10n, project);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.bebasNeue(
            fontSize: 36,
            letterSpacing: 1.2,
            color: AppColors.navyInk,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          tagline,
          style: GoogleFonts.kalam(
            fontSize: 16,
            color: zine.inkMuted,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in project.visibleTech.take(6))
              _TagChip(label: t),
          ],
        ),
        if (project.hasCaseStudy) ...[
          const SizedBox(height: 20),
          CursorTarget(
            enabled: customCursor,
            child: TextButton(
              onPressed: () => context.go('/work/${project.slug}'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.flutterBlue,
                padding: EdgeInsets.zero,
              ),
              child: Text(
                l10n.readCaseStudy,
                style: GoogleFonts.spaceMono(
                  fontSize: 12,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProjectGrid extends StatelessWidget {
  const _ProjectGrid({
    required this.projects,
    required this.mobile,
    required this.tapeColors,
    required this.customCursor,
  });

  final List<Project> projects;
  final bool mobile;
  final List<Color> tapeColors;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    if (mobile) {
      return Column(
        children: [
          for (var i = 0; i < projects.length; i++) ...[
            if (i > 0) const SizedBox(height: 20),
            _GridCard(
              project: projects[i],
              tapeColor: tapeColors[i % tapeColors.length],
              customCursor: customCursor,
            ),
          ],
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 20.0;
        final cardW = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < projects.length; i++)
              SizedBox(
                width: cardW,
                child: _GridCard(
                  project: projects[i],
                  tapeColor: tapeColors[i % tapeColors.length],
                  customCursor: customCursor,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _GridCard extends StatelessWidget {
  const _GridCard({
    required this.project,
    required this.tapeColor,
    required this.customCursor,
  });

  final Project project;
  final Color tapeColor;
  final bool customCursor;

  Future<void> _open(String? url) async {
    if (isTodo(url)) return;
    await launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final title = ProjectCopy.title(l10n, project);
    final tagline = ProjectCopy.tagline(l10n, project);

    final links = <(String, String?)>[
      (l10n.linkPlayStore, project.playStoreUrl),
      (l10n.linkGitHub, project.githubUrl),
      (l10n.linkWebsite, project.websiteUrl),
    ].where((e) => !isTodo(e.$2)).toList();

    return KeyedSubtree(
      key: PortfolioScrollTargets.keyForProject(project.slug),
      child: CursorTarget(
        enabled: customCursor,
        label: 'VIEW',
        child: PaperCard(
          tilt: project.cardTilt,
          tapeColor: tapeColor,
          padding: const EdgeInsets.fromLTRB(14, 26, 14, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProjectImageSlot(
                assetPath: project.coverImagePath,
                label: title,
                aspectRatio: 16 / 10,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final p in project.platforms)
                    _TagChip(
                      label: ProjectCopy.platformLabel(l10n, p),
                      filled: true,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.bebasNeue(
                  fontSize: 26,
                  color: AppColors.navyInk,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tagline,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.kalam(
                  fontSize: 14,
                  color: zine.inkMuted,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final t in project.visibleTech.take(4)) _TagChip(label: t),
                ],
              ),
              if (links.isNotEmpty) ...[
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    for (final (label, url) in links)
                      CursorTarget(
                        enabled: customCursor,
                        child: GestureDetector(
                          onTap: () => _open(url),
                          child: Text(
                            label,
                            style: GoogleFonts.spaceMono(
                              fontSize: 11,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w700,
                              color: AppColors.flutterBlue,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, this.filled = false});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: filled
            ? AppColors.flutterBlue.withValues(alpha: 0.12)
            : Colors.transparent,
        border: Border.all(
          color: AppColors.flutterBlue.withValues(alpha: filled ? 0.35 : 0.45),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceMono(
          fontSize: 9,
          letterSpacing: 0.8,
          fontWeight: FontWeight.w700,
          color: AppColors.navyInk,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
