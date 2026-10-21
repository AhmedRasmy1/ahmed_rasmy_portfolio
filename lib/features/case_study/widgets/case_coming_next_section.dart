import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/paper_card.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/safe_asset_image.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_layout.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/lazy_hover_video.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/scroll_reveal.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/project_image_slot.dart';

class CaseComingNextSection extends StatelessWidget {
  const CaseComingNextSection({
    super.key,
    required this.study,
    required this.scrollOffset,
    this.reduceMotion = false,
    this.customCursor = false,
  });

  final CaseStudy study;
  final ValueNotifier<double> scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final headlineKey = study.comingNextHeadlineKey;
    if (headlineKey == null) return const SizedBox.shrink();
    final headline = CaseStudyCopy.t(l10n, headlineKey);
    if (isTodo(headline)) return const SizedBox.shrink();

    final features = study.upcomingFeatures
        .where((f) => f.visibility != FeatureVisibility.hidden)
        .toList();
    if (features.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '09',
          eyebrow: l10n.caseSecComingNext,
          title: headline,
          intro: '',
          scrollOffset: scrollOffset,
          reduceMotion: reduceMotion,
        ),
        const SizedBox(height: 12),
        _ComingSoonDecor(label: l10n.caseComingSoonSticky),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, c) {
            final stack = c.maxWidth < CaseLayout.stackBreakpoint;
            return Column(
              children: [
                for (var i = 0; i < features.length; i++) ...[
                  if (i > 0) const SizedBox(height: 28),
                  ScrollReveal(
                    scrollOffset: scrollOffset,
                    reduceMotion: reduceMotion,
                    delayFraction: i * 0.1,
                    child: _FeatureRow(
                      feature: features[i],
                      index: i,
                      stack: stack,
                      scrollOffset: scrollOffset,
                      customCursor: customCursor,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ComingSoonDecor extends StatelessWidget {
  const _ComingSoonDecor({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        CustomPaint(
          size: const Size(48, 28),
          painter: _HandArrowPainter(),
        ),
        Transform.rotate(
          angle: CaseLayout.tilt(-0.08, width: width),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.stickyYellow,
              boxShadow: [
                BoxShadow(
                  color: AppColors.navyInk.withValues(alpha: 0.18),
                  blurRadius: 6,
                  offset: const Offset(2, 3),
                ),
              ],
            ),
            child: Text(
              label,
              softWrap: true,
              style: GoogleFonts.kalam(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.navyInk,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HandArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.flutterLightBlue
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(4, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.1,
        size.width - 6,
        size.height * 0.55,
      );
    canvas.drawPath(path, paint);
    canvas.drawLine(
      Offset(size.width - 6, size.height * 0.55),
      Offset(size.width - 16, size.height * 0.35),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - 6, size.height * 0.55),
      Offset(size.width - 14, size.height * 0.72),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.feature,
    required this.index,
    required this.stack,
    required this.scrollOffset,
    required this.customCursor,
  });

  final UpcomingFeature feature;
  final int index;
  final bool stack;
  final ValueNotifier<double> scrollOffset;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final mediaFirst = stack || index.isEven;
    final width = MediaQuery.sizeOf(context).width;
    final maxTilt =
        CaseLayout.isNarrow(width) ? CaseLayout.narrowTilt : null;
    final card = feature.visibility == FeatureVisibility.teaser
        ? _TeaserCard(feature: feature, maxTilt: maxTilt)
        : _FullCard(
            feature: feature,
            scrollOffset: scrollOffset,
            customCursor: customCursor,
            maxTilt: maxTilt,
          );

    if (stack) return card;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: mediaFirst
          ? [
              Expanded(flex: 11, child: card),
              const SizedBox(width: 24),
              const Expanded(flex: 1, child: SizedBox()),
            ]
          : [
              const Expanded(flex: 1, child: SizedBox()),
              const SizedBox(width: 24),
              Expanded(flex: 11, child: card),
            ],
    );
  }
}

class _FullCard extends StatelessWidget {
  const _FullCard({
    required this.feature,
    required this.scrollOffset,
    required this.customCursor,
    this.maxTilt,
  });

  final UpcomingFeature feature;
  final ValueNotifier<double> scrollOffset;
  final bool customCursor;
  final double? maxTilt;

  bool _isVideo(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.mov');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = CaseStudyCopy.t(l10n, feature.titleKey);
    final summary = CaseStudyCopy.t(l10n, feature.summaryKey);
    final status = feature.statusKey == null
        ? null
        : CaseStudyCopy.t(l10n, feature.statusKey!);
    final highlights = feature.highlightKeys
        .map((k) => CaseStudyCopy.t(l10n, k))
        .where((s) => !isTodo(s))
        .toList();
    final tech = feature.tech.where((t) => !isTodo(t)).toList();
    final media = feature.media;

    final width = MediaQuery.sizeOf(context).width;

    return CursorTarget(
      enabled: customCursor,
      child: PaperCard(
        tilt: 0.01,
        maxTilt: maxTilt,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isTodo(title))
                  Text(
                    title,
                    softWrap: true,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 28,
                      color: AppColors.navyInk,
                      decoration: TextDecoration.none,
                    ),
                  ),
                if (media != null && !isTodo(media)) ...[
                  const SizedBox(height: 14),
                  if (_isVideo(media))
                    LazyHoverVideo(
                      card: CaseStudyMediaCard(
                        id: feature.titleKey,
                        captionKey: feature.titleKey,
                        videoAsset: media,
                      ),
                      scrollOffset: scrollOffset,
                      customCursor: customCursor,
                      aspectRatio: 16 / 9,
                    )
                  else
                    ProjectImageSlot(
                      assetPath: media,
                      label: isTodo(title) ? 'Preview' : title,
                      aspectRatio: 16 / 9,
                    ),
                ],
                if (!isTodo(summary)) ...[
                  const SizedBox(height: 14),
                  Text(
                    summary,
                    softWrap: true,
                    style: GoogleFonts.kalam(
                      fontSize: 15,
                      height: 1.45,
                      color: AppColors.navyInk.withValues(alpha: 0.88),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
                if (highlights.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  for (final h in highlights)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '→ ',
                            style: GoogleFonts.spaceMono(
                              fontSize: 12,
                              color: AppColors.flutterBlue,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              h,
                              softWrap: true,
                              style: GoogleFonts.kalam(
                                fontSize: 14,
                                color: AppColors.navyInk
                                    .withValues(alpha: 0.85),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
                if (tech.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final t in tech)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color:
                                AppColors.flutterBlue.withValues(alpha: 0.1),
                            border: Border.all(
                              color: AppColors.flutterBlue
                                  .withValues(alpha: 0.35),
                            ),
                          ),
                          child: Text(
                            t,
                            softWrap: true,
                            style: GoogleFonts.spaceMono(
                              fontSize: 11,
                              color: AppColors.flutterBlue,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
            if (status != null && !isTodo(status))
              PositionedDirectional(
                top: -6,
                end: -4,
                child: Transform.rotate(
                  angle: CaseLayout.tilt(0.12, width: width),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.flutterLightBlue,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.navyInk.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(1, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      status.toUpperCase(),
                      softWrap: true,
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: AppColors.navyInk,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TeaserCard extends StatelessWidget {
  const _TeaserCard({required this.feature, this.maxTilt});

  final UpcomingFeature feature;
  final double? maxTilt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = CaseStudyCopy.t(l10n, feature.titleKey);
    final teaserLine = feature.teaserLineKey == null
        ? null
        : CaseStudyCopy.t(l10n, feature.teaserLineKey!);
    final preview = feature.teaserPreviewAsset;
    final width = MediaQuery.sizeOf(context).width;

    return PaperCard(
      tilt: -0.015,
      maxTilt: maxTilt,
      tapeColor: AppColors.stickyYellow.withValues(alpha: 0.85),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isTodo(title))
                Text(
                  title,
                  softWrap: true,
                  style: GoogleFonts.bebasNeue(
                    fontSize: 26,
                    color: AppColors.navyInk,
                    decoration: TextDecoration.none,
                  ),
                ),
              if (preview != null && !isTodo(preview)) ...[
                const SizedBox(height: 12),
                OptionalAssetFrame(
                  assetPath: preview,
                  debugPlaceholder: kDebugMode
                      ? ColoredBox(
                          color: AppColors.navyInk.withValues(alpha: 0.12),
                          child: Center(
                            child: Text(
                              '??',
                              style: GoogleFonts.bebasNeue(
                                fontSize: 40,
                                color: AppColors.navyInk
                                    .withValues(alpha: 0.3),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        )
                      : null,
                  builder: (context, image) => AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: image,
                    ),
                  ),
                ),
              ],
              if (teaserLine != null && !isTodo(teaserLine)) ...[
                const SizedBox(height: 12),
                Text(
                  teaserLine,
                  softWrap: true,
                  style: GoogleFonts.kalam(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: AppColors.navyInk.withValues(alpha: 0.7),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ],
          ),
          PositionedDirectional(
            top: -4,
            end: 0,
            child: Transform.rotate(
              angle: CaseLayout.tilt(0.14, width: width),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                color: AppColors.navyInk,
                child: Text(
                  l10n.caseClassified,
                  softWrap: true,
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    color: AppColors.stickyYellow,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
