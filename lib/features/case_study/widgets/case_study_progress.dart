import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';

class CaseStudySectionRef {
  const CaseStudySectionRef({
    required this.id,
    required this.label,
    required this.key,
  });

  final String id;
  final String label;
  final GlobalKey key;
}

class CaseStudyProgressRail extends StatelessWidget {
  const CaseStudyProgressRail({
    super.key,
    required this.sections,
    required this.activeId,
    required this.onSelect,
    this.customCursor = false,
  });

  final List<CaseStudySectionRef> sections;
  final String? activeId;
  final ValueChanged<String> onSelect;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final s in sections)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: CursorTarget(
              enabled: customCursor,
              child: GestureDetector(
                onTap: () => onSelect(s.id),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: activeId == s.id ? 10 : 7,
                      height: activeId == s.id ? 10 : 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: activeId == s.id
                            ? AppColors.flutterLightBlue
                            : AppColors.flutterBlue.withValues(alpha: 0.35),
                        boxShadow: activeId == s.id
                            ? [
                                BoxShadow(
                                  color: AppColors.flutterLightBlue
                                      .withValues(alpha: 0.45),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 72,
                      child: Text(
                        s.label,
                        style: GoogleFonts.spaceMono(
                          fontSize: 9,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                          color: activeId == s.id
                              ? AppColors.flutterLightBlue
                              : context.zine.inkMuted,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
