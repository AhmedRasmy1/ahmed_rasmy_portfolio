import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/painters/tape_painter.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';

class CaseThinkingSection extends StatefulWidget {
  const CaseThinkingSection({
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
  State<CaseThinkingSection> createState() => _CaseThinkingSectionState();
}

class _CaseThinkingSectionState extends State<CaseThinkingSection> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final headlineKey = widget.study.thinkingHeadlineKey;
    final questions = widget.study.thinkingQuestions;
    if (headlineKey == null || questions.isEmpty) {
      return const SizedBox.shrink();
    }
    final headline = CaseStudyCopy.t(l10n, headlineKey);
    if (isTodo(headline)) return const SizedBox.shrink();

    String? answer;
    if (_selected != null) {
      final raw = CaseStudyCopy.t(l10n, questions[_selected!].answerKey);
      if (!isTodo(raw)) answer = raw;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '03',
          eyebrow: l10n.caseSecThinking,
          title: headline,
          intro: '',
          scrollOffset: widget.scrollOffset,
          reduceMotion: widget.reduceMotion,
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < questions.length; i++)
              _QuestionChip(
                label: CaseStudyCopy.t(l10n, questions[i].questionKey),
                selected: _selected == i,
                customCursor: widget.customCursor,
                onSelect: () => setState(() => _selected = i),
              ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: answer == null
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _StickyAnswer(
                    key: ValueKey(_selected),
                    text: answer,
                  ),
                ),
        ),
      ],
    );
  }
}

class _QuestionChip extends StatelessWidget {
  const _QuestionChip({
    required this.label,
    required this.selected,
    required this.onSelect,
    required this.customCursor,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelect;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    return CursorTarget(
      enabled: customCursor,
      child: MouseRegion(
        onEnter: (_) => onSelect(),
        child: GestureDetector(
          onTap: onSelect,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.flutterBlue
                  : AppColors.paper.withValues(alpha: 0.9),
              border: Border.all(
                color: AppColors.flutterBlue
                    .withValues(alpha: selected ? 0.9 : 0.35),
              ),
            ),
            child: Text(
              label,
              style: GoogleFonts.spaceMono(
                fontSize: 11,
                letterSpacing: 0.6,
                fontWeight: FontWeight.w700,
                color: selected ? AppColors.offWhite : AppColors.navyInk,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StickyAnswer extends StatelessWidget {
  const _StickyAnswer({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.02,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 120),
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 22),
            decoration: BoxDecoration(
              color: AppColors.stickyYellow,
              boxShadow: [
                BoxShadow(
                  color: AppColors.navyInk.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(2, 6),
                ),
              ],
            ),
            child: Text(
              text,
              style: GoogleFonts.kalam(
                fontSize: 18,
                height: 1.4,
                color: AppColors.navyInk,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          const Positioned(
            top: -8,
            left: 0,
            right: 0,
            child: Center(
              child: TapeStrip(
                color: Color(0xE613B9FD),
                width: 64,
                height: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
