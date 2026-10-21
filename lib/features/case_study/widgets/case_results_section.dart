import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_layout.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/scroll_reveal.dart';

class CaseResultsSection extends StatelessWidget {
  const CaseResultsSection({
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
    final headlineKey = study.resultsHeadlineKey;
    if (headlineKey == null) return const SizedBox.shrink();
    final headline = CaseStudyCopy.t(l10n, headlineKey);
    if (isTodo(headline)) return const SizedBox.shrink();

    final stats = study.resultStats.where((s) => s.value != null).toList();
    final bars = study.resultBarLists.where((b) => b.items.isNotEmpty).toList();

    // Hide completely until real numbers / bar data exist.
    if (stats.isEmpty && bars.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '10',
          eyebrow: l10n.caseSecResults,
          title: headline,
          intro: '',
          scrollOffset: scrollOffset,
          reduceMotion: reduceMotion,
        ),
        if (stats.isNotEmpty) ...[
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, c) {
              final stack = c.maxWidth < CaseLayout.stackBreakpoint;
              final w = MediaQuery.sizeOf(context).width;
              final children = [
                for (var i = 0; i < stats.length; i++)
                  ScrollReveal(
                    scrollOffset: scrollOffset,
                    reduceMotion: reduceMotion,
                    delayFraction: i * 0.08,
                    child: _StatSticker(
                      stat: stats[i],
                      tilt: CaseLayout.tilt(
                        i.isEven ? -0.04 : 0.05,
                        width: w,
                      ),
                      scrollOffset: scrollOffset,
                      reduceMotion: reduceMotion,
                    ),
                  ),
              ];
              if (stack) {
                return Column(
                  children: [
                    for (var i = 0; i < children.length; i++) ...[
                      if (i > 0) const SizedBox(height: 16),
                      children[i],
                    ],
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0) const SizedBox(width: 16),
                    Expanded(child: children[i]),
                  ],
                ],
              );
            },
          ),
        ],
        if (bars.isNotEmpty) ...[
          const SizedBox(height: 36),
          LayoutBuilder(
            builder: (context, c) {
              final stack = c.maxWidth < CaseLayout.stackBreakpoint;
              final cards = [
                for (var i = 0; i < bars.length; i++)
                  ScrollReveal(
                    scrollOffset: scrollOffset,
                    reduceMotion: reduceMotion,
                    delayFraction: 0.1 + i * 0.08,
                    child: _BarListCard(
                      list: bars[i],
                      reduceMotion: reduceMotion,
                      scrollOffset: scrollOffset,
                    ),
                  ),
              ];
              if (stack) {
                return Column(
                  children: [
                    for (var i = 0; i < cards.length; i++) ...[
                      if (i > 0) const SizedBox(height: 16),
                      cards[i],
                    ],
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    if (i > 0) const SizedBox(width: 20),
                    Expanded(child: cards[i]),
                  ],
                ],
              );
            },
          ),
        ],
      ],
    );
  }
}

class _StatSticker extends StatefulWidget {
  const _StatSticker({
    required this.stat,
    required this.tilt,
    required this.scrollOffset,
    required this.reduceMotion,
  });

  final CaseStudyStat stat;
  final double tilt;
  final ValueNotifier<double> scrollOffset;
  final bool reduceMotion;

  @override
  State<_StatSticker> createState() => _StatStickerState();
}

class _StatStickerState extends State<_StatSticker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    if (widget.reduceMotion) {
      _ctrl.value = 1;
      _started = true;
    } else {
      widget.scrollOffset.addListener(_maybeStart);
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStart());
    }
  }

  @override
  void dispose() {
    widget.scrollOffset.removeListener(_maybeStart);
    _ctrl.dispose();
    super.dispose();
  }

  void _maybeStart() {
    if (!mounted || _started) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final dy = box.localToGlobal(Offset.zero).dy;
    final h = MediaQuery.sizeOf(context).height;
    if (dy < h * 0.88) {
      _started = true;
      _ctrl.forward();
    }
  }

  String _format(double t) {
    final target = widget.stat.value!;
    final current = target * t;
    if (widget.stat.decimals > 0) {
      return current.toStringAsFixed(widget.stat.decimals) + widget.stat.suffix;
    }
    return '${current.round()}${widget.stat.suffix}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = CaseStudyCopy.t(l10n, widget.stat.labelKey);

    return Transform.rotate(
      angle: widget.tilt,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.stickyYellow,
          boxShadow: [
            BoxShadow(
              color: AppColors.navyInk.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (context, _) {
                  final t = Curves.easeOutCubic.transform(_ctrl.value);
                  return Text(
                    _format(t),
                    softWrap: true,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 40,
                      height: 1,
                      color: AppColors.navyInk,
                      decoration: TextDecoration.none,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              softWrap: true,
              style: GoogleFonts.kalam(
                fontSize: 15,
                color: AppColors.navyInk.withValues(alpha: 0.8),
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarListCard extends StatefulWidget {
  const _BarListCard({
    required this.list,
    required this.reduceMotion,
    required this.scrollOffset,
  });

  final CaseStudyBarList list;
  final bool reduceMotion;
  final ValueNotifier<double> scrollOffset;

  @override
  State<_BarListCard> createState() => _BarListCardState();
}

class _BarListCardState extends State<_BarListCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (widget.reduceMotion) {
      _ctrl.value = 1;
      _started = true;
    } else {
      widget.scrollOffset.addListener(_maybeStart);
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStart());
    }
  }

  @override
  void dispose() {
    widget.scrollOffset.removeListener(_maybeStart);
    _ctrl.dispose();
    super.dispose();
  }

  void _maybeStart() {
    if (!mounted || _started) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final dy = box.localToGlobal(Offset.zero).dy;
    final h = MediaQuery.sizeOf(context).height;
    if (dy < h * 0.9) {
      _started = true;
      _ctrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = CaseStudyCopy.t(l10n, widget.list.titleKey);
    final zine = context.zine;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: zine.paper,
        boxShadow: [
          BoxShadow(
            color: AppColors.navyInk.withValues(alpha: 0.14),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            softWrap: true,
            style: GoogleFonts.bebasNeue(
              fontSize: 20,
              color: AppColors.navyInk,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 14),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (context, _) {
                final t = Curves.easeOutCubic.transform(_ctrl.value);
                return Column(
                  children: [
                    for (var i = 0; i < widget.list.items.length; i++) ...[
                      if (i > 0) const SizedBox(height: 10),
                      _BarRow(
                        item: widget.list.items[i],
                        progress: t,
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BarRow extends StatelessWidget {
  const _BarRow({
    required this.item,
    required this.progress,
  });

  final CaseStudyBarItem item;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = CaseStudyCopy.t(l10n, item.labelKey);
    final width = item.fraction.clamp(0.0, 1.0) * progress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                softWrap: true,
                style: GoogleFonts.kalam(
                  fontSize: 13,
                  color: AppColors.navyInk.withValues(alpha: 0.85),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Text(
              '${(item.fraction.clamp(0.0, 1.0) * 100 * progress).round()}%',
              style: GoogleFonts.spaceMono(
                fontSize: 11,
                color: AppColors.flutterBlue,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(
            height: 8,
            child: Stack(
              children: [
                ColoredBox(
                  color: AppColors.flutterBlue.withValues(alpha: 0.12),
                  child: const SizedBox.expand(),
                ),
                FractionallySizedBox(
                  widthFactor: width,
                  child: const ColoredBox(color: AppColors.flutterLightBlue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
