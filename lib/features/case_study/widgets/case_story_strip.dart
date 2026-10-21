import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/painters/tape_painter.dart';
import 'package:ahmed_rasmy_portfolio/core/utils/asset_checker.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/safe_asset_image.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_layout.dart';

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
    final width = MediaQuery.sizeOf(context).width;
    final useSnap = width < CaseLayout.mobileBreakpoint;
    final panels = [
      for (var i = 0; i < study.storyPanels.length; i++)
        if (AssetChecker.has(
              study.storyPanels[i].assetPath(study.projectSlug),
            ) ||
            kDebugMode)
          (i, study.storyPanels[i]),
    ];
    if (panels.isEmpty) return const SizedBox.shrink();

    Widget polaroid(int slot, CaseStudyStoryPanel p) {
      final tilt = reduceMotion
          ? 0.0
          : CaseLayout.tilt(_tilts[slot % _tilts.length], width: width);
      return CursorTarget(
        enabled: customCursor,
        child: _StoryPolaroid(
          assetPath: p.assetPath(study.projectSlug),
          caption: CaseStudyCopy.t(l10n, p.captionKey),
          tilt: tilt,
          tapeColor: _tapes[slot % _tapes.length],
        ),
      );
    }

    if (useSnap) {
      return CaseSnapGallery(
        height: width < CaseLayout.stackBreakpoint ? 300 : 320,
        viewportFraction: width < CaseLayout.stackBreakpoint ? 0.78 : 0.55,
        itemCount: panels.length,
        itemBuilder: (_, i) => Align(
          alignment: Alignment.topCenter,
          child: polaroid(panels[i].$1, panels[i].$2),
        ),
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: [
        for (final entry in panels) polaroid(entry.$1, entry.$2),
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
  });

  final String assetPath;
  final String caption;
  final double tilt;
  final Color tapeColor;

  @override
  State<_StoryPolaroid> createState() => _StoryPolaroidState();
}

class _StoryPolaroidState extends State<_StoryPolaroid> {
  bool _hover = false;
  bool _tapped = false;

  void _setLift(bool v) {
    if (_hover == v && !_tapped) return;
    setState(() {
      _hover = v;
      if (!v) _tapped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lifted = _hover || _tapped;
    final angle = lifted ? 0.0 : widget.tilt;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: () => setState(() => _tapped = !_tapped),
        child: MouseRegion(
          cursor: SystemMouseCursors.none,
          onEnter: (_) => _setLift(true),
          onExit: (_) => _setLift(false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            constraints: const BoxConstraints(maxWidth: 200),
            transformAlignment: Alignment.center,
            transform: Matrix4.rotationZ(angle)
              ..setTranslationRaw(0, lifted ? -8.0 : 0, 0),
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
                            .withValues(alpha: lifted ? 0.28 : 0.16),
                        blurRadius: lifted ? 16 : 10,
                        offset: Offset(0, lifted ? 10 : 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  AppColors.navyInk.withValues(alpha: 0.2),
                              width: 2,
                            ),
                          ),
                          child: SafeAssetImage(
                            assetPath: widget.assetPath,
                            fit: BoxFit.cover,
                            debugLabel: widget.caption,
                            showDebugPlaceholder: kDebugMode,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        curve: Curves.easeOutCubic,
                        transformAlignment: Alignment.center,
                        transform: Matrix4.translationValues(
                          0,
                          lifted ? -4.0 : 0,
                          0,
                        ),
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          widget.caption,
                          textAlign: TextAlign.center,
                          softWrap: true,
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
        ),
      ),
    );
  }
}
