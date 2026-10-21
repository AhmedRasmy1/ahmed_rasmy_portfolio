import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/skill_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/navigation/home_sections.dart';
import 'package:ahmed_rasmy_portfolio/core/utils/asset_checker.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/paper_card.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/safe_asset_image.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({
    super.key,
    this.scrollOffset,
    this.reduceMotion = false,
    this.customCursor = false,
  });

  final ValueNotifier<double>? scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  static const _tapeColors = [
    Color(0xE6A8C8E0),
    Color(0xE613B9FD),
    Color(0xE6E8C96A),
    Color(0xE68BB4D4),
    Color(0xE6B8D4C8),
    Color(0xE6C5B8E0),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 700;
    final groups = PortfolioData.skillGroups;

    return KeyedSubtree(
      key: HomeSectionKeys.key(HomeSection.skills),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 72),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              number: HomeSection.skills.numberLabel,
              eyebrow: l10n.secSkillsEyebrow,
              title: l10n.secSkillsTitle,
              intro: l10n.secSkillsIntro,
              scrollOffset: scrollOffset,
              reduceMotion: reduceMotion,
            ),
            const SizedBox(height: 32),
            if (mobile)
              Column(
                children: [
                  for (var i = 0; i < groups.length; i++) ...[
                    if (i > 0) const SizedBox(height: 18),
                    _SkillNote(
                      group: groups[i],
                      tapeColor: _tapeColors[i % _tapeColors.length],
                      tilt: ((i % 2 == 0) ? -1 : 1) * (0.012 + i * 0.004),
                      customCursor: customCursor,
                    ),
                  ],
                ],
              )
            else
              _MasonryBoard(
                groups: groups,
                tapeColors: _tapeColors,
                customCursor: customCursor,
              ),
          ],
        ),
      ),
    );
  }
}

/// Two-column scrapbook board — uneven note heights read as masonry.
class _MasonryBoard extends StatelessWidget {
  const _MasonryBoard({
    required this.groups,
    required this.tapeColors,
    required this.customCursor,
  });

  final List<SkillGroup> groups;
  final List<Color> tapeColors;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final left = <int>[];
    final right = <int>[];
    for (var i = 0; i < groups.length; i++) {
      (i.isEven ? left : right).add(i);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 20.0;
        final colW = (constraints.maxWidth - gap) / 2;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: colW,
              child: Column(
                children: [
                  for (var n = 0; n < left.length; n++) ...[
                    if (n > 0) SizedBox(height: 18.0 + (n * 4)),
                    _SkillNote(
                      group: groups[left[n]],
                      tapeColor: tapeColors[left[n] % tapeColors.length],
                      tilt: -0.015 - left[n] * 0.003,
                      customCursor: customCursor,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: gap),
            SizedBox(
              width: colW,
              child: Column(
                children: [
                  const SizedBox(height: 28),
                  for (var n = 0; n < right.length; n++) ...[
                    if (n > 0) SizedBox(height: 22.0 + (n * 6)),
                    _SkillNote(
                      group: groups[right[n]],
                      tapeColor: tapeColors[right[n] % tapeColors.length],
                      tilt: 0.018 + right[n] * 0.002,
                      customCursor: customCursor,
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SkillNote extends StatelessWidget {
  const _SkillNote({
    required this.group,
    required this.tapeColor,
    required this.tilt,
    required this.customCursor,
  });

  final SkillGroup group;
  final Color tapeColor;
  final double tilt;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = SkillCopy.groupTitle(l10n, group);

    return CursorTarget(
      enabled: customCursor,
      child: PaperCard(
        tilt: tilt,
        tapeColor: tapeColor,
        padding: const EdgeInsets.fromLTRB(14, 26, 14, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.bebasNeue(
                fontSize: 22,
                letterSpacing: 1,
                color: AppColors.navyInk,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < group.items.length; i++)
                  _StampChip(
                    label: group.items[i],
                    angle: ((i % 5) - 2) * 0.025,
                    customCursor: customCursor,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StampChip extends StatefulWidget {
  const _StampChip({
    required this.label,
    required this.angle,
    required this.customCursor,
  });

  final String label;
  final double angle;
  final bool customCursor;

  @override
  State<_StampChip> createState() => _StampChipState();
}

class _StampChipState extends State<_StampChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final iconPath = SkillIconPaths.assetFor(widget.label);
    final angle = _hover ? 0.0 : widget.angle;

    return CursorTarget(
      enabled: widget.customCursor,
      child: MouseRegion(
        cursor: SystemMouseCursors.none,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transformAlignment: Alignment.center,
          transform: Matrix4.rotationZ(angle)
            ..setTranslationRaw(0, _hover ? -4.0 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: _hover
                ? AppColors.flutterLightBlue.withValues(alpha: 0.12)
                : Colors.transparent,
            border: Border.all(
              color: AppColors.flutterBlue
                  .withValues(alpha: _hover ? 0.7 : 0.45),
              width: 1.4,
            ),
            borderRadius: BorderRadius.circular(3),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: AppColors.navyInk.withValues(alpha: 0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconPath != null) _SkillIcon(path: iconPath),
              Text(
                widget.label,
                style: GoogleFonts.spaceMono(
                  fontSize: 10,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navyInk,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Renders a tech icon only when the asset exists; otherwise nothing.
class _SkillIcon extends StatelessWidget {
  const _SkillIcon({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    if (!AssetChecker.has(path)) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 6),
      child: SafeAssetImage(
        assetPath: path,
        width: 14,
        height: 14,
        showDebugPlaceholder: false,
      ),
    );
  }
}
