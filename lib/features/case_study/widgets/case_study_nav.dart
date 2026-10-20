import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/theme_locale_toggles.dart';

class CaseStudyNav extends StatelessWidget {
  const CaseStudyNav({
    super.key,
    required this.title,
    this.customCursor = false,
  });

  final String title;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final narrow = MediaQuery.sizeOf(context).width < 700;

    return Material(
      color: zine.canvas.withValues(alpha: 0.94),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: zine.divider)),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                CursorTarget(
                  enabled: customCursor,
                  child: TextButton(
                    onPressed: () => context.go('/'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.flutterLightBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Text(
                      l10n.caseBackToPortfolio,
                      style: GoogleFonts.spaceMono(
                        fontSize: 11,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                if (!narrow) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.bebasNeue(
                        fontSize: 22,
                        letterSpacing: 1,
                        color: zine.ink,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ] else
                  const Spacer(),
                const ThemeLocaleToggles(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
