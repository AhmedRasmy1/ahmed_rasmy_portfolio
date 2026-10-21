import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/experience_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/navigation/home_sections.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_typography.dart';
import 'package:ahmed_rasmy_portfolio/core/utils/asset_checker.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/paper_card.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/safe_asset_image.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/experience_photo_stack.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({
    super.key,
    this.scrollOffset,
    this.reduceMotion = false,
    this.customCursor = false,
  });

  final ValueNotifier<double>? scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  double _lineProgress = 0;
  final List<bool> _revealed =
      List.filled(PortfolioData.experiences.length, false);

  @override
  void initState() {
    super.initState();
    widget.scrollOffset?.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    widget.scrollOffset?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final viewH = MediaQuery.sizeOf(context).height;
    final top = box.localToGlobal(Offset.zero).dy;
    final bottom = top + box.size.height;

    // Draw line as the section travels through the viewport.
    final start = viewH * 0.85;
    final end = viewH * 0.15;
    final t = ((start - top) / (start - end + box.size.height * 0.35))
        .clamp(0.0, 1.0);

    var changed = false;
    if ((t - _lineProgress).abs() > 0.01) {
      _lineProgress = t;
      changed = true;
    }

    for (var i = 0; i < _revealed.length; i++) {
      if (_revealed[i]) continue;
      // Reveal cards progressively with the line.
      if (_lineProgress >= (i + 0.35) / (_revealed.length + 0.5)) {
        _revealed[i] = true;
        changed = true;
      }
    }

    // Also reveal when section top is on screen (reduce motion / first paint).
    if (widget.reduceMotion || bottom > 0 && top < viewH) {
      for (var i = 0; i < _revealed.length; i++) {
        if (!_revealed[i] && top < viewH * (0.75 + i * 0.05)) {
          _revealed[i] = true;
          changed = true;
        }
      }
    }

    if (changed) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 700;
    final experiences = PortfolioData.experiences;

    return KeyedSubtree(
      key: HomeSectionKeys.key(HomeSection.experience),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 72),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              number: HomeSection.experience.numberLabel,
              eyebrow: l10n.secExperienceEyebrow,
              title: l10n.secExperienceTitle,
              intro: l10n.secExperienceIntro,
              scrollOffset: widget.scrollOffset,
              reduceMotion: widget.reduceMotion,
            ),
            const SizedBox(height: 40),
            _Timeline(
              experiences: experiences,
              mobile: mobile,
              lineProgress: widget.reduceMotion ? 1 : _lineProgress,
              revealed: widget.reduceMotion
                  ? List.filled(experiences.length, true)
                  : _revealed,
              customCursor: widget.customCursor,
              reduceMotion: widget.reduceMotion,
            ),
          ],
        ),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.experiences,
    required this.mobile,
    required this.lineProgress,
    required this.revealed,
    required this.customCursor,
    required this.reduceMotion,
  });

  final List<Experience> experiences;
  final bool mobile;
  final double lineProgress;
  final List<bool> revealed;
  final bool customCursor;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: mobile ? 11 : 0,
          right: mobile ? null : 0,
          top: 12,
          bottom: 12,
          width: mobile ? 2 : null,
          child: mobile
              ? CustomPaint(
                  painter: _TimelineLinePainter(
                    progress: lineProgress,
                    color: AppColors.flutterLightBlue.withValues(alpha: 0.55),
                    track: AppColors.flutterBlue.withValues(alpha: 0.2),
                  ),
                  child: const SizedBox.expand(),
                )
              : Center(
                  child: SizedBox(
                    width: 2,
                    child: CustomPaint(
                      painter: _TimelineLinePainter(
                        progress: lineProgress,
                        color:
                            AppColors.flutterLightBlue.withValues(alpha: 0.55),
                        track: AppColors.flutterBlue.withValues(alpha: 0.2),
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
        ),
        Column(
          children: [
            for (var i = 0; i < experiences.length; i++) ...[
              if (i > 0) const SizedBox(height: 28),
              _TimelineEntry(
                experience: experiences[i],
                index: i,
                mobile: mobile,
                revealed: revealed[i],
                customCursor: customCursor,
                reduceMotion: reduceMotion,
                tilt: ((i % 2 == 0) ? -1 : 1) * 0.018,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _TimelineLinePainter extends CustomPainter {
  _TimelineLinePainter({
    required this.progress,
    required this.color,
    required this.track,
  });

  final double progress;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final trackPaint = Paint()
      ..color = track
      ..strokeWidth = size.width
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, 0), Offset(cx, size.height), trackPaint);

    final fill = Paint()
      ..color = color
      ..strokeWidth = size.width
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx, 0),
      Offset(cx, size.height * progress.clamp(0.0, 1.0)),
      fill,
    );
  }

  @override
  bool shouldRepaint(covariant _TimelineLinePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.track != track;
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.experience,
    required this.index,
    required this.mobile,
    required this.revealed,
    required this.customCursor,
    required this.reduceMotion,
    required this.tilt,
  });

  final Experience experience;
  final int index;
  final bool mobile;
  final bool revealed;
  final bool customCursor;
  final bool reduceMotion;
  final double tilt;

  @override
  Widget build(BuildContext context) {
    final existingPhotos =
        AssetChecker.existing(experience.visiblePhotos).take(3).toList();
    final photos = existingPhotos.isNotEmpty
        ? ExperiencePhotoStack(
            photos: existingPhotos,
            customCursor: customCursor,
            reduceMotion: reduceMotion,
          )
        : null;

    final card = CursorTarget(
      enabled: customCursor,
      child: PaperCard(
        tilt: tilt,
        tapeColor: index == 0
            ? AppColors.flutterLightBlue.withValues(alpha: 0.85)
            : null,
        child: _ExperienceCardBody(experience: experience),
      ),
    );

    Widget entry;
    final node = Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.flutterLightBlue,
        border: Border.all(color: AppColors.offWhite, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.flutterLightBlue.withValues(alpha: 0.4),
            blurRadius: 8,
          ),
        ],
      ),
    );

    if (mobile) {
      entry = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Padding(
              padding: const EdgeInsets.only(top: 28),
              child: Center(child: node),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                card,
                if (photos != null) ...[
                  const SizedBox(height: 16),
                  photos,
                ],
              ],
            ),
          ),
        ],
      );
    } else {
      final left = index.isEven;
      final side = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: card),
          if (photos != null) ...[
            const SizedBox(width: 16),
            photos,
          ],
        ],
      );
      entry = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left ? side : const SizedBox.shrink()),
          SizedBox(
            width: 48,
            child: Padding(
              padding: const EdgeInsets.only(top: 28),
              child: Center(child: node),
            ),
          ),
          Expanded(child: left ? const SizedBox.shrink() : side),
        ],
      );
    }

    if (reduceMotion) return entry;

    return entry
        .animate(target: revealed ? 1 : 0)
        .fadeIn(duration: 420.ms, curve: Curves.easeOutCubic)
        .slideY(
          begin: 0.14,
          end: 0,
          duration: 480.ms,
          curve: Curves.easeOutCubic,
        )
        .scale(
          begin: const Offset(0.96, 0.96),
          end: const Offset(1, 1),
          duration: 480.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class _ExperienceCardBody extends StatelessWidget {
  const _ExperienceCardBody({required this.experience});

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final company = ExperienceCopy.company(l10n, experience);
    final role = ExperienceCopy.role(l10n, experience);
    final dates = ExperienceCopy.dateRange(l10n, experience);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LogoSlot(path: experience.logoImagePath, label: company),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        role,
                        style: AppTypography.headline(
                          context,
                          fontSize: 24,
                          color: AppColors.navyInk,
                        ),
                      ),
                      if (experience.isCurrent) _NowStamp(label: l10n.expNow),
                    ],
                  ),
                  Text(
                    company,
                    style: AppTypography.label(
                      context,
                      fontSize: 12,
                      color: AppColors.flutterBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dates,
                    style: AppTypography.label(
                      context,
                      fontSize: 11,
                      color: zine.inkMuted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        for (final key in experience.bulletKeys) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.flutterLightBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    ExperienceCopy.bullet(l10n, key),
                    softWrap: true,
                    style: AppTypography.note(
                      context,
                      fontSize: 14,
                      height: AppTypography.isArabic(context) ? 1.55 : 1.4,
                      color: AppColors.navyInk.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _NowStamp extends StatelessWidget {
  const _NowStamp({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.08,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.flutterBlue, width: 1.5),
          color: AppColors.flutterLightBlue.withValues(alpha: 0.15),
        ),
        child: Text(
          AppTypography.displayCase(context, label),
          style: AppTypography.label(
            context,
            fontSize: 10,
            color: AppColors.flutterBlue,
          ),
        ),
      ),
    );
  }
}

class _LogoSlot extends StatelessWidget {
  const _LogoSlot({required this.path, required this.label});

  final String path;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.06),
        border: Border.all(
          color: AppColors.flutterBlue.withValues(alpha: 0.25),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeAssetImage(
        assetPath: path,
        fit: BoxFit.contain,
        showDebugPlaceholder: false,
        fallback: Center(
          child: Text(
            label.isNotEmpty ? String.fromCharCode(label.runes.first) : '?',
            style: AppTypography.headline(
              context,
              fontSize: 22,
              color: AppColors.flutterBlue,
            ),
          ),
        ),
      ),
    );
  }
}
