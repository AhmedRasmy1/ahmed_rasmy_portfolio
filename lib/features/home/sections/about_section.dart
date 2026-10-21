import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_typography.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/navigation/home_sections.dart';
import 'package:ahmed_rasmy_portfolio/core/painters/tape_painter.dart';
import 'package:ahmed_rasmy_portfolio/core/utils/asset_checker.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/safe_asset_image.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({
    super.key,
    this.scrollOffset,
    this.reduceMotion = false,
    this.customCursor = false,
  });

  final ValueNotifier<double>? scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final width = MediaQuery.sizeOf(context).width;
    final narrow = width < 900;
    final bodyStyle = AppTypography.body(
      context,
      fontSize: 15,
      height: AppTypography.isArabic(context) ? 1.6 : 1.5,
      color: zine.inkMuted,
    );

    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.aboutP1, style: bodyStyle),
        const SizedBox(height: 16),
        Text(l10n.aboutP2, style: bodyStyle),
        const SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _FactChip(label: l10n.aboutFactCairo),
            _Dot(),
            _FactChip(label: l10n.aboutFactLang),
            _Dot(),
            _FactChip(label: l10n.aboutFactOpen, accent: true),
          ],
        ),
      ],
    );

    final collage = _PolaroidCollage(
      customCursor: customCursor,
      captions: [
        l10n.aboutCaptionWorkspace,
        l10n.aboutCaptionAction,
        l10n.aboutCaptionCraft,
        l10n.aboutCaptionStudio,
      ],
    );

    return KeyedSubtree(
      key: HomeSectionKeys.key(HomeSection.about),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 72),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              number: HomeSection.about.numberLabel,
              eyebrow: l10n.secAboutEyebrow,
              title: l10n.secAboutTitle,
              intro: l10n.secAboutIntro,
              scrollOffset: scrollOffset,
              reduceMotion: reduceMotion,
            ),
            const SizedBox(height: 32),
            if (narrow) ...[
              copy,
              const SizedBox(height: 36),
              collage,
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 5, child: copy),
                  const SizedBox(width: 36),
                  Expanded(flex: 6, child: collage),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _FactChip extends StatelessWidget {
  const _FactChip({required this.label, this.accent = false});

  final String label;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTypography.label(
        context,
        fontSize: 11,
        color: accent ? AppColors.flutterLightBlue : context.zine.ink,
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '·',
      style: AppTypography.label(
        context,
        fontSize: 14,
        color: context.zine.inkMuted,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _PolaroidCollage extends StatelessWidget {
  const _PolaroidCollage({
    required this.captions,
    required this.customCursor,
  });

  final List<String> captions;
  final bool customCursor;

  static const _assets = [
    'assets/images/about/about_01.jpg',
    'assets/images/about/about_02.jpg',
    'assets/images/about/about_03.jpg',
    'assets/images/about/about_04.jpg',
  ];

  static const _tilts = [-0.045, 0.04, -0.035, 0.05];
  static const _tapeColors = [
    Color(0xE6A8C8E0),
    Color(0xE613B9FD),
    Color(0xE6E8C96A),
    Color(0xE68BB4D4),
  ];

  @override
  Widget build(BuildContext context) {
    final visible = <int>[
      for (var i = 0; i < _assets.length; i++)
        if (AssetChecker.has(_assets[i]) || kDebugMode) i,
    ];
    if (visible.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth.clamp(260.0, 520.0);
        final cardW = w * 0.40;
        // Fixed height from width — no IntrinsicHeight parent.
        return SizedBox(
          height: w * 0.98,
          width: w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (final i in visible)
                Positioned(
                  left: i.isEven
                      ? w * (0.00 + (i == 2 ? 0.06 : 0.02))
                      : w * (0.52 + (i == 3 ? 0.02 : 0.0)),
                  top: i < 2
                      ? w * (0.00 + i * 0.04)
                      : w * (0.48 + (i - 2) * 0.04),
                  child: CursorTarget(
                    enabled: customCursor,
                    child: _Polaroid(
                      assetPath: _assets[i],
                      caption: captions[i],
                      tilt: _tilts[i],
                      tapeColor: _tapeColors[i],
                      width: cardW,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Polaroid extends StatefulWidget {
  const _Polaroid({
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
  State<_Polaroid> createState() => _PolaroidState();
}

class _PolaroidState extends State<_Polaroid> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    if (!AssetChecker.has(widget.assetPath) && !kDebugMode) {
      return const SizedBox.shrink();
    }

    final angle = _hover ? 0.0 : widget.tilt;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cacheW = (widget.width * dpr * 2).round().clamp(400, 1600);

    final imageChild = SafeAssetImage(
      assetPath: widget.assetPath,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      cacheWidth: cacheW,
      debugLabel: widget.caption,
    );

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
          ..setTranslationRaw(0, _hover ? -6.0 : 0, 0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 12),
              decoration: BoxDecoration(
                color: AppColors.offWhite,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.navyInk
                        .withValues(alpha: _hover ? 0.3 : 0.18),
                    blurRadius: _hover ? 16 : 10,
                    offset: Offset(0, _hover ? 10 : 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: ClipRect(child: imageChild),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.caption,
                    textAlign: TextAlign.center,
                    style: AppTypography.note(
                      context,
                      fontSize: 13,
                      color: AppColors.navyInk,
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
                  width: 56,
                  height: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
