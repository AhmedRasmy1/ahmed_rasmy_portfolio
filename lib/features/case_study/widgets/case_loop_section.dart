import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_typography.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/paper_card.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_layout.dart';

class CaseLoopSection extends StatefulWidget {
  const CaseLoopSection({
    super.key,
    required this.study,
    this.scrollOffset,
    this.reduceMotion = false,
    this.customCursor = false,
  });

  final CaseStudy study;
  final ValueNotifier<double>? scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  State<CaseLoopSection> createState() => _CaseLoopSectionState();
}

class _CaseLoopSectionState extends State<CaseLoopSection> {
  int _selected = 0;
  double _pathProgress = 0;
  late List<GlobalKey> _nodeKeys;
  List<Offset> _centers = const [];
  double _radius = 38;

  @override
  void initState() {
    super.initState();
    _nodeKeys = [];
    widget.scrollOffset?.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void didUpdateWidget(covariant CaseLoopSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollOffset != widget.scrollOffset) {
      oldWidget.scrollOffset?.removeListener(_onScroll);
      widget.scrollOffset?.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollOffset?.removeListener(_onScroll);
    super.dispose();
  }

  void _ensureKeys(int count) {
    if (_nodeKeys.length == count) return;
    _nodeKeys = List.generate(count, (_) => GlobalKey());
  }

  void _onScroll() {
    if (!mounted) return;
    if (widget.reduceMotion) {
      if (_pathProgress != 1) setState(() => _pathProgress = 1);
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final viewH = MediaQuery.sizeOf(context).height;
    final p = ((viewH * 0.85 - top) / (viewH * 0.55)).clamp(0.0, 1.0);
    if ((p - _pathProgress).abs() > 0.02) {
      setState(() => _pathProgress = p);
    }
  }

  void _measureCenters(GlobalKey stackKey) {
    final stackBox = stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (stackBox == null || !stackBox.hasSize) return;
    final centers = <Offset>[];
    var radius = _radius;
    for (final key in _nodeKeys) {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) return;
      final centerGlobal = box.localToGlobal(box.size.center(Offset.zero));
      centers.add(stackBox.globalToLocal(centerGlobal));
      radius = box.size.shortestSide / 2;
    }
    var changed = centers.length != _centers.length ||
        (radius - _radius).abs() > 0.5;
    if (!changed) {
      for (var i = 0; i < centers.length; i++) {
        if ((centers[i] - _centers[i]).distance > 0.5) {
          changed = true;
          break;
        }
      }
    }
    if (changed) {
      setState(() {
        _centers = centers;
        _radius = radius;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final headlineKey = widget.study.productHeadlineKey;
    if (headlineKey == null || widget.study.loopSteps.isEmpty) {
      return const SizedBox.shrink();
    }
    final headline = CaseStudyCopy.t(l10n, headlineKey);
    if (isTodo(headline)) return const SizedBox.shrink();

    final steps = widget.study.loopSteps;
    _ensureKeys(steps.length);
    final selected = steps[_selected.clamp(0, steps.length - 1)];
    final detail = CaseStudyCopy.t(l10n, selected.detailKey);
    final showDetail = !isTodo(detail);
    final stackKey = GlobalKey();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '02',
          eyebrow: l10n.caseSecProductEyebrow,
          title: headline,
          intro: '',
          scrollOffset: widget.scrollOffset,
          reduceMotion: widget.reduceMotion,
        ),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, c) {
            final mobile = c.maxWidth < CaseLayout.stackBreakpoint;
            final rtl = Directionality.of(context) == TextDirection.rtl;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _measureCenters(stackKey);
            });

            final nodes = [
              for (var i = 0; i < steps.length; i++)
                KeyedSubtree(
                  key: _nodeKeys[i],
                  child: _LoopNode(
                    index: i,
                    title: CaseStudyCopy.t(l10n, steps[i].titleKey),
                    selected: _selected == i,
                    customCursor: widget.customCursor,
                    onSelect: () => setState(() => _selected = i),
                  ),
                ),
            ];

            return SizedBox(
              height: mobile ? steps.length * 100.0 : 140,
              width: double.infinity,
              child: Stack(
                key: stackKey,
                children: [
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: _LoopConnectorPainter(
                          centers: _centers,
                          radius: _radius,
                          progress: _pathProgress,
                          gap: 8,
                          rtl: rtl,
                          mobile: mobile,
                        ),
                      ),
                    ),
                  ),
                  if (mobile)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: nodes,
                    )
                  else
                    Row(
                      children: [
                        for (final node
                            in (rtl ? nodes.reversed.toList() : nodes))
                          Expanded(child: Center(child: node)),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: showDetail
              ? PaperCard(
                  key: ValueKey(_selected),
                  tilt: 0.01,
                  maxTilt: CaseLayout.isNarrow(
                          MediaQuery.sizeOf(context).width)
                      ? CaseLayout.narrowTilt
                      : null,
                  tapeColor:
                      AppColors.flutterLightBlue.withValues(alpha: 0.8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppTypography.displayCase(
                          context,
                          CaseStudyCopy.t(l10n, selected.titleKey),
                        ),
                        softWrap: true,
                        style: AppTypography.label(
                          context,
                          fontSize: 11,
                          color: AppColors.flutterBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        detail,
                        softWrap: true,
                        style: AppTypography.note(
                          context,
                          fontSize: 16,
                          color: AppColors.navyInk,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ],
    );
  }
}

class _LoopNode extends StatelessWidget {
  const _LoopNode({
    required this.index,
    required this.title,
    required this.selected,
    required this.onSelect,
    required this.customCursor,
  });

  final int index;
  final String title;
  final bool selected;
  final VoidCallback onSelect;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    return CursorTarget(
      enabled: customCursor,
      child: GestureDetector(
        onTap: onSelect,
        child: MouseRegion(
          onEnter: (_) => onSelect(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: selected ? 84 : 72,
            height: selected ? 84 : 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected
                  ? AppColors.flutterBlue
                  : AppColors.paper.withValues(alpha: 0.95),
              border: Border.all(
                color: AppColors.flutterLightBlue
                    .withValues(alpha: selected ? 0.9 : 0.45),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.navyInk
                      .withValues(alpha: selected ? 0.25 : 0.12),
                  blurRadius: selected ? 14 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${index + 1}'.padLeft(2, '0'),
                    style: AppTypography.label(
                      context,
                      fontSize: 10,
                      color: selected
                          ? AppColors.offWhite.withValues(alpha: 0.7)
                          : AppColors.flutterBlue,
                    ),
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: AppTypography.headline(
                      context,
                      fontSize: 15,
                      color: selected ? AppColors.offWhite : AppColors.navyInk,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoopConnectorPainter extends CustomPainter {
  _LoopConnectorPainter({
    required this.centers,
    required this.radius,
    required this.progress,
    required this.gap,
    required this.rtl,
    required this.mobile,
  });

  final List<Offset> centers;
  final double radius;
  final double progress;
  final double gap;
  final bool rtl;
  final bool mobile;

  @override
  void paint(Canvas canvas, Size size) {
    if (centers.length < 2 || progress <= 0) return;
    final paint = Paint()
      ..color = AppColors.flutterLightBlue.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    // Order centers along flow direction.
    final ordered = List<Offset>.from(centers);
    if (!mobile && rtl) {
      // Visual order already mirrored in Row; centers are left-to-right in stack.
      // Flow should go right→left: reverse for connectors.
      ordered.sort((a, b) => b.dx.compareTo(a.dx));
    } else if (!mobile) {
      ordered.sort((a, b) => a.dx.compareTo(b.dx));
    } else {
      ordered.sort((a, b) => a.dy.compareTo(b.dy));
    }

    final path = Path();
    for (var i = 0; i < ordered.length - 1; i++) {
      final a = ordered[i];
      final b = ordered[i + 1];
      final delta = b - a;
      final dist = delta.distance;
      if (dist < 1) continue;
      final dir = delta / dist;
      final start = a + dir * (radius + gap);
      final end = b - dir * (radius + gap);
      if ((end - start).distance < 4) continue;
      if (i == 0) {
        path.moveTo(start.dx, start.dy);
      } else {
        path.moveTo(start.dx, start.dy);
      }
      path.lineTo(end.dx, end.dy);
    }

    for (final metric in path.computeMetrics()) {
      final extract = metric.extractPath(0, metric.length * progress);
      _drawDashed(canvas, extract, paint);
      if (progress > 0.85) {
        final tangent = metric.getTangentForOffset(metric.length * progress);
        if (tangent != null) {
          _drawArrow(canvas, tangent.position, tangent.vector, paint);
        }
      }
    }
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dash = 7.0;
      const gapDash = 5.0;
      while (distance < metric.length) {
        final next = math.min(distance + dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gapDash;
      }
    }
  }

  void _drawArrow(Canvas canvas, Offset tip, Offset tangent, Paint paint) {
    final len = tangent.distance;
    if (len < 0.001) return;
    final dir = tangent / len;
    final left = Offset(
      tip.dx - dir.dx * 10 + dir.dy * 5,
      tip.dy - dir.dy * 10 - dir.dx * 5,
    );
    final right = Offset(
      tip.dx - dir.dx * 10 - dir.dy * 5,
      tip.dy - dir.dy * 10 + dir.dx * 5,
    );
    canvas.drawLine(tip, left, paint);
    canvas.drawLine(tip, right, paint);
  }

  @override
  bool shouldRepaint(covariant _LoopConnectorPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.radius != radius ||
      oldDelegate.rtl != rtl ||
      oldDelegate.mobile != mobile ||
      oldDelegate.centers.length != centers.length ||
      !_centersEqual(oldDelegate.centers, centers);

  bool _centersEqual(List<Offset> a, List<Offset> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if ((a[i] - b[i]).distance > 0.5) return false;
    }
    return true;
  }
}
