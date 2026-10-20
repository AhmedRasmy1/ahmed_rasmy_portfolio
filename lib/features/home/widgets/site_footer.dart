import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/footer_marquee.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({
    super.key,
    required this.onBackToTop,
    this.reduceMotion = false,
    this.customCursor = false,
  });

  final VoidCallback onBackToTop;
  final bool reduceMotion;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      child: Column(
        children: [
          FooterMarquee(reduceMotion: reduceMotion),
          const SizedBox(height: 8),
          Divider(color: zine.divider, thickness: 1),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 24,
            runSpacing: 12,
            children: [
              Text(
                l10n.footerCopyright,
                style: GoogleFonts.spaceMono(
                  fontSize: 11,
                  letterSpacing: 1.1,
                  color: zine.inkMuted,
                  decoration: TextDecoration.none,
                ),
              ),
              CursorTarget(
                enabled: customCursor,
                child: TextButton(
                  onPressed: onBackToTop,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.flutterLightBlue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    l10n.footerBackToTop,
                    style: GoogleFonts.spaceMono(
                      fontSize: 11,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
