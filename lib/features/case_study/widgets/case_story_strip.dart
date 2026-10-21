import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/painters/tape_painter.dart';

class CaseStoryStrip extends StatelessWidget {
  const CaseStoryStrip({
    super.key,
    required this.study,
    this.customCursor = false,
    this.reduceMotion = false,
  });

  final CaseStudy study;
  final bool customCursor;
  final bool reduceMotion;

  static const _tilts = [-0.05, 0.04, -0.035, 0.055];
  static const _tapes = [
    Color(0xE6A8C8E0),
    Color(0xE613B9FD),
    Color(0xE6E8C96A),
    Color(0xE68BB4D4),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mobile = MediaQuery.sizeOf(context).width < 700;
    final panels = study.storyPanels;
    if (panels.isEmpty) return const SizedBox.shrink();

    Widget polaroid(int i) {
      final p = panels[i];
      return CursorTarget(
        enabled: customCursor,
        child: _StoryPolaroid(
          assetPath: p.assetPath(study.projectSlug),
          caption: CaseStudyCopy.t(l10n, p.captionKey),
          tilt: reduceMotion ? 0 : _tilts[i % _tilts.length],
          tapeColor: _tapes[i % _tapes.length],
          width: mobile ? 200.0 : 180.0,
        ),
      );
    }

    if (mobile) {
      return SizedBox(
        height: 280,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
          itemCount: panels.length,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (_, i) => polaroid(i),
        ),
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: [
        for (var i = 0; i < panels.length; i++) polaroid(i),
      ],
    );
  }
}

class _StoryPolaroid extends StatefulWidget {
  const _StoryPolaroid({
    required this.assetPath,
    required this.caption,
    required this.tilt,
    required this.tapeColor,
    required this.width,
  });

  final String assetPath;
  final String caption;
  final double tilt;
  final Color tapeColor;
  final double width;

  @override
  State<_StoryPolaroid> createState() => _StoryPolaroidState();
}

class _StoryPolaroidState extends State<_StoryPolaroid> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final angle = _hover ? 0.0 : widget.tilt;

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        width: widget.width,
        transformAlignment: Alignment.center,
        transform: Matrix4.rotationZ(angle)
          ..setTranslationRaw(0, _hover ? -8.0 : 0, 0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
              decoration: BoxDecoration(
                color: AppColors.offWhite,
                border: Border.all(
                  color: AppColors.navyInk.withValues(alpha: 0.12),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.navyInk
                        .withValues(alpha: _hover ? 0.28 : 0.16),
                    blurRadius: _hover ? 16 : 10,
                    offset: Offset(0, _hover ? 10 : 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.navyInk.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Image.asset(
                        widget.assetPath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => ColoredBox(
                          color: AppColors.navy,
                          child: Center(
                            child: Text(
                              widget.caption.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.spaceMono(
                                fontSize: 10,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w700,
                                color: AppColors.flutterLightBlue
                                    .withValues(alpha: 0.8),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    transformAlignment: Alignment.center,
                    transform: Matrix4.translationValues(
                      0,
                      _hover ? -4.0 : 0,
                      0,
                    ),
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      widget.caption,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.kalam(
                        fontSize: 14,
                        color: AppColors.navyInk,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -8,
              left: 0,
              right: 0,
              child: Center(
                child: TapeStrip(
                  color: widget.tapeColor,
                  width: 52,
                  height: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
