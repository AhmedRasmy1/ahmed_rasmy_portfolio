import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/navigation/home_sections.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';

/// Empty numbered section scaffold (filled in later steps).
class SectionPlaceholder extends StatelessWidget {
  const SectionPlaceholder({
    super.key,
    required this.section,
    required this.eyebrow,
    required this.title,
    required this.intro,
    required this.placeholder,
    this.scrollOffset,
    this.reduceMotion = false,
  });

  final HomeSection section;
  final String eyebrow;
  final String title;
  final String intro;
  final String placeholder;
  final ValueNotifier<double>? scrollOffset;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final zine = context.zine;

    return KeyedSubtree(
      key: HomeSectionKeys.key(section),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 72),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              number: section.numberLabel,
              eyebrow: eyebrow,
              title: title,
              intro: intro,
              scrollOffset: scrollOffset,
              reduceMotion: reduceMotion,
            ),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              decoration: BoxDecoration(
                color: zine.paper.withValues(alpha: 0.35),
                border: Border.all(color: zine.divider),
              ),
              child: Text(
                placeholder,
                style: GoogleFonts.spaceMono(
                  fontSize: 12,
                  letterSpacing: 1.4,
                  color: zine.inkMuted,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
