import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/case_study_copy.dart';

class CaseStudySectionAnchor {
  CaseStudySectionAnchor(this.id) : key = GlobalKey(debugLabel: id.name);

  final CaseStudySectionId id;
  final GlobalKey key;
}

/// Right-rail progress dots. Active id comes from a single [ValueNotifier].
class CaseStudyProgressRail extends StatelessWidget {
  const CaseStudyProgressRail({
    super.key,
    required this.anchors,
    required this.activeId,
    required this.onSelect,
    this.customCursor = false,
  });

  final List<CaseStudySectionAnchor> anchors;
  final ValueNotifier<CaseStudySectionId?> activeId;
  final ValueChanged<CaseStudySectionId> onSelect;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ValueListenableBuilder<CaseStudySectionId?>(
      valueListenable: activeId,
      builder: (context, active, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final a in anchors)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CursorTarget(
                  enabled: customCursor,
                  child: Tooltip(
                    message: CaseStudyCopy.sectionTooltip(l10n, a.id),
                    preferBelow: false,
                    waitDuration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      onTap: () => onSelect(a.id),
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        width: active == a.id ? 12 : 8,
                        height: active == a.id ? 12 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active == a.id
                              ? AppColors.flutterLightBlue
                              : AppColors.flutterBlue.withValues(alpha: 0.35),
                          boxShadow: active == a.id
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
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
