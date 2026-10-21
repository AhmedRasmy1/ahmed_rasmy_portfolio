import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/navigation/home_sections.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/theme_locale_toggles.dart';

/// Top bar: ← Back to Portfolio + portfolio sticky-nav links + theme/locale.
class CaseStudyNav extends StatelessWidget {
  const CaseStudyNav({
    super.key,
    required this.title,
    this.customCursor = false,
    this.mobile = false,
  });

  final String title;
  final bool customCursor;
  final bool mobile;

  void _goHome(BuildContext context, [HomeSection? section]) {
    context.go('/');
    if (section == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(const Duration(milliseconds: 80), () {
        HomeSectionKeys.scrollTo(section);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;

    return Material(
      color: zine.canvas.withValues(alpha: 0.94),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: zine.divider)),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: mobile
                ? Row(
                    children: [
                      CursorTarget(
                        enabled: customCursor,
                        child: TextButton(
                          onPressed: () => _goHome(context),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.flutterLightBlue,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: Text(
                            l10n.caseBackToPortfolio,
                            style: GoogleFonts.spaceMono(
                              fontSize: 11,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      const ThemeLocaleToggles(),
                    ],
                  )
                : Row(
                    children: [
                      CursorTarget(
                        enabled: customCursor,
                        child: TextButton(
                          onPressed: () => _goHome(context),
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
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          spacing: 2,
                          runSpacing: 4,
                          alignment: WrapAlignment.center,
                          children: [
                            _Link(
                              label: l10n.navWork,
                              onTap: () => _goHome(context, HomeSection.work),
                              customCursor: customCursor,
                            ),
                            _Link(
                              label: l10n.navAbout,
                              onTap: () => _goHome(context, HomeSection.about),
                              customCursor: customCursor,
                            ),
                            _Link(
                              label: l10n.navExperience,
                              onTap: () =>
                                  _goHome(context, HomeSection.experience),
                              customCursor: customCursor,
                            ),
                            _Link(
                              label: l10n.navSkills,
                              onTap: () => _goHome(context, HomeSection.skills),
                              customCursor: customCursor,
                            ),
                            _Link(
                              label: l10n.navResume,
                              onTap: () => context.go('/resume'),
                              customCursor: customCursor,
                            ),
                            _Link(
                              label: l10n.navContact,
                              onTap: () =>
                                  _goHome(context, HomeSection.contact),
                              customCursor: customCursor,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        title,
                        style: GoogleFonts.bebasNeue(
                          fontSize: 18,
                          letterSpacing: 1,
                          color: zine.ink.withValues(alpha: 0.55),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const ThemeLocaleToggles(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _Link extends StatelessWidget {
  const _Link({
    required this.label,
    required this.onTap,
    required this.customCursor,
  });

  final String label;
  final VoidCallback onTap;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    return CursorTarget(
      enabled: customCursor,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: context.zine.ink,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          label,
          style: GoogleFonts.spaceMono(
            fontSize: 11,
            letterSpacing: 1,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
