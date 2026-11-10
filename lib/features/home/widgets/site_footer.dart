import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_typography.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/social_links.dart';
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

  Future<void> _open(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final linkedIn = SocialLinks.linkedin;
    final github = SocialLinks.github;

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
                style: AppTypography.label(context, fontSize: 11, letterSpacing: 1.1, color: zine.inkMuted),
              ),
              if (linkedIn != null || github != null)
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    if (linkedIn != null)
                      _FooterSocialChip(
                        label: l10n.linkLinkedIn,
                        icon: Icons.work_outline,
                        customCursor: customCursor,
                        onTap: () => _open(linkedIn),
                      ),
                    if (github != null)
                      _FooterSocialChip(
                        label: l10n.linkGitHub,
                        icon: Icons.code,
                        customCursor: customCursor,
                        onTap: () => _open(github),
                      ),
                  ],
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
                    style: AppTypography.label(context, fontSize: 11, letterSpacing: 1.4, fontWeight: FontWeight.w700),
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

class _FooterSocialChip extends StatefulWidget {
  const _FooterSocialChip({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.customCursor,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool customCursor;

  @override
  State<_FooterSocialChip> createState() => _FooterSocialChipState();
}

class _FooterSocialChipState extends State<_FooterSocialChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final zine = context.zine;
    final bg = _hover ? AppColors.flutterBlue : zine.chip;
    final fg = _hover ? AppColors.offWhite : AppColors.navyInk;

    return CursorTarget(
      enabled: widget.customCursor,
      child: MouseRegion(
        cursor: widget.customCursor
            ? SystemMouseCursors.none
            : SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: AppColors.navyInk
                      .withValues(alpha: _hover ? 0.25 : 0.12),
                  blurRadius: _hover ? 10 : 5,
                  offset: Offset(0, _hover ? 7 : 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 14, color: fg),
                const SizedBox(width: 6),
                Text(
                  widget.label,
                  style: AppTypography.label(context, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w700, color: fg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
