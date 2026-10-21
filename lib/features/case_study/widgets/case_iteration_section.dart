import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/paper_card.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_layout.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/scroll_reveal.dart';

class CaseIterationSection extends StatelessWidget {
  const CaseIterationSection({
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
    final headlineKey = study.iterationHeadlineKey;
    if (headlineKey == null) return const SizedBox.shrink();
    final headline = CaseStudyCopy.t(l10n, headlineKey);
    if (isTodo(headline)) return const SizedBox.shrink();

    final cards = study.iterations.where((c) {
      final before = CaseStudyCopy.t(l10n, c.beforeKey);
      final learned = CaseStudyCopy.t(l10n, c.learnedKey);
      final after = CaseStudyCopy.t(l10n, c.afterKey);
      return !isTodo(before) && !isTodo(learned) && !isTodo(after);
    }).toList();

    if (cards.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '08',
          eyebrow: l10n.caseSecIteration,
          title: headline,
          intro: '',
          scrollOffset: scrollOffset,
          reduceMotion: reduceMotion,
        ),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, c) {
            final stack = c.maxWidth < CaseLayout.stackBreakpoint;
            if (stack) {
              return Column(
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    if (i > 0) const SizedBox(height: 20),
                    ScrollReveal(
                      scrollOffset: scrollOffset,
                      reduceMotion: reduceMotion,
                      delayFraction: i * 0.08,
                      child: _IterationCard(
                        card: cards[i],
                        reduceMotion: reduceMotion,
                      ),
                    ),
                  ],
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < cards.length; i++) ...[
                  if (i > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ScrollReveal(
                      scrollOffset: scrollOffset,
                      reduceMotion: reduceMotion,
                      delayFraction: i * 0.08,
                      child: _IterationCard(
                        card: cards[i],
                        reduceMotion: reduceMotion,
                      ),
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

class _IterationCard extends StatelessWidget {
  const _IterationCard({
    required this.card,
    required this.reduceMotion,
  });

  final CaseStudyIteration card;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = CaseStudyCopy.t(l10n, card.titleKey);

    final width = MediaQuery.sizeOf(context).width;

    return PaperCard(
      tilt: 0.012,
      maxTilt: CaseLayout.isNarrow(width) ? CaseLayout.narrowTilt : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isTodo(title))
            Text(
              title,
              softWrap: true,
              style: GoogleFonts.bebasNeue(
                fontSize: 22,
                color: AppColors.navyInk,
                decoration: TextDecoration.none,
              ),
            ),
          if (!isTodo(title)) const SizedBox(height: 14),
          _PhaseBlock(
            label: l10n.caseBefore,
            body: CaseStudyCopy.t(l10n, card.beforeKey),
            accent: AppColors.navyInk.withValues(alpha: 0.45),
          ),
          const SizedBox(height: 12),
          _PhaseBlock(
            label: l10n.caseLearned,
            body: CaseStudyCopy.t(l10n, card.learnedKey),
            accent: AppColors.flutterBlue,
          ),
          const SizedBox(height: 12),
          _PhaseBlock(
            label: l10n.caseAfter,
            body: CaseStudyCopy.t(l10n, card.afterKey),
            accent: AppColors.flutterLightBlue,
          ),
          if (card.visual != null) ...[
            const SizedBox(height: 16),
            _IterationVisual(
              visual: card.visual!,
              reduceMotion: reduceMotion,
            ),
          ],
        ],
      ),
    );
  }
}

class _PhaseBlock extends StatelessWidget {
  const _PhaseBlock({
    required this.label,
    required this.body,
    required this.accent,
  });

  final String label;
  final String body;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.spaceMono(
            fontSize: 10,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
            color: accent,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          body,
          softWrap: true,
          style: GoogleFonts.kalam(
            fontSize: 14,
            height: 1.4,
            color: AppColors.navyInk.withValues(alpha: 0.88),
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }
}

class _IterationVisual extends StatefulWidget {
  const _IterationVisual({
    required this.visual,
    required this.reduceMotion,
  });

  final CaseStudyIterationVisual visual;
  final bool reduceMotion;

  @override
  State<_IterationVisual> createState() => _IterationVisualState();
}

class _IterationVisualState extends State<_IterationVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    if (widget.reduceMotion) {
      _ctrl.value = 1;
    } else {
      _ctrl.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _IterationVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reduceMotion != oldWidget.reduceMotion) {
      if (widget.reduceMotion) {
        _ctrl.stop();
        _ctrl.value = 1;
      } else {
        _ctrl.repeat(reverse: true);
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return switch (widget.visual) {
            CaseStudyIterationVisual.valueChange => _ValueChangeDemo(
                t: Curves.easeInOut.transform(_ctrl.value),
              ),
            CaseStudyIterationVisual.snackbar => _SnackbarDemo(
                t: Curves.easeInOut.transform(_ctrl.value),
              ),
          };
        },
      ),
    );
  }
}

class _ValueChangeDemo extends StatelessWidget {
  const _ValueChangeDemo({required this.t});

  final double t;

  @override
  Widget build(BuildContext context) {
    final value = (12 + (87 - 12) * t).round();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.flutterBlue.withValues(alpha: 0.08),
        border: Border.all(color: AppColors.paperEdge),
      ),
      child: Row(
        children: [
          Text(
            'VALUE',
            style: GoogleFonts.spaceMono(
              fontSize: 10,
              letterSpacing: 1,
              color: AppColors.navyInk.withValues(alpha: 0.5),
              decoration: TextDecoration.none,
            ),
          ),
          const Spacer(),
          Text(
            '$value',
            style: GoogleFonts.bebasNeue(
              fontSize: 28,
              color: AppColors.flutterBlue,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}

class _SnackbarDemo extends StatelessWidget {
  const _SnackbarDemo({required this.t});

  final double t;

  @override
  Widget build(BuildContext context) {
    // Before: center-ish / mid; After: bottom-aligned.
    final alignY = -0.55 + 1.1 * t;
    return SizedBox(
      height: 72,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.navyInk.withValues(alpha: 0.06),
          border: Border.all(color: AppColors.paperEdge),
        ),
        child: Align(
          alignment: Alignment(0, alignY),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.navyInk,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Saved',
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                color: AppColors.offWhite,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
