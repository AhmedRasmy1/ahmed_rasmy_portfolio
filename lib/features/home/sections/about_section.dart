import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/navigation/home_sections.dart';
import 'package:ahmed_rasmy_portfolio/core/painters/tape_painter.dart';
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
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    final bodyStyle = (isAr
            ? GoogleFonts.cairo(
                fontSize: 15,
                height: 1.55,
                color: zine.inkMuted,
              )
            : GoogleFonts.kalam(
                fontSize: 16,
                height: 1.5,
                color: zine.inkMuted,
              ))
        .copyWith(decoration: TextDecoration.none);

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: copy),
                  const SizedBox(width: 36),
                  Expanded(flex: 5, child: collage),
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
      style: GoogleFonts.spaceMono(
        fontSize: 11,
        letterSpacing: 1.4,
        fontWeight: FontWeight.w700,
        color: accent ? AppColors.flutterLightBlue : context.zine.ink,
        decoration: TextDecoration.none,
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '·',
      style: GoogleFonts.spaceMono(
        fontSize: 14,
        color: context.zine.inkMuted,
        decoration: TextDecoration.none,
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

  static const _tilts = [-0.06, 0.05, -0.04, 0.07];
  static const _tapeColors = [
    Color(0xE6A8C8E0),
    Color(0xE613B9FD),
    Color(0xE6E8C96A),
    Color(0xE68BB4D4),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth.clamp(260.0, 480.0);
        final cardW = w * 0.42;
        return SizedBox(
          height: w * 0.92,
          width: w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (var i = 0; i < 4; i++)
                Positioned(
                  left: i.isEven ? w * (0.02 + i * 0.04) : w * (0.48 - (i - 1) * 0.03),
                  top: i < 2 ? w * (0.02 + i * 0.06) : w * (0.42 + (i - 2) * 0.05),
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
                    child: Image.asset(
                      widget.assetPath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _PhotoPlaceholder(
                        label: widget.caption,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.caption,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.kalam(
                      fontSize: 13,
                      color: AppColors.navyInk,
                      decoration: TextDecoration.none,
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

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.navy,
      child: CustomPaint(
        painter: const _GridPainter(),
        child: Center(
          child: Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceMono(
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
              color: AppColors.flutterLightBlue.withValues(alpha: 0.8),
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = AppColors.flutterLightBlue.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    const step = 14.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
