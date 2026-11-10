import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_typography.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/host_venue_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';

/// Zine-chip Play Store / App Store buttons. Renders nothing when both URLs are null.
class StoreLinkChips extends StatelessWidget {
  const StoreLinkChips({
    super.key,
    this.playStoreUrl = GatherUpLinks.playStore,
    this.appStoreUrl = GatherUpLinks.appStore,
    this.customCursor = false,
  });

  final String? playStoreUrl;
  final String? appStoreUrl;
  final bool customCursor;

  Future<void> _open(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final links = <(String, String)>[
      if (playStoreUrl != null) (l10n.linkPlayStore, playStoreUrl!),
      if (appStoreUrl != null) (l10n.linkAppStore, appStoreUrl!),
    ];
    if (links.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (var i = 0; i < links.length; i++)
            _StoreChip(
              label: links[i].$1,
              onTap: () => _open(links[i].$2),
              angle: i.isEven ? -0.03 : 0.04,
              customCursor: customCursor,
            ),
        ],
      ),
    );
  }
}

class _StoreChip extends StatefulWidget {
  const _StoreChip({
    required this.label,
    required this.onTap,
    required this.angle,
    required this.customCursor,
  });

  final String label;
  final VoidCallback onTap;
  final double angle;
  final bool customCursor;

  @override
  State<_StoreChip> createState() => _StoreChipState();
}

class _StoreChipState extends State<_StoreChip> {
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
            transformAlignment: Alignment.center,
            transform: Matrix4.rotationZ(_hover ? -0.02 : widget.angle)
              ..setTranslationRaw(0, _hover ? -6.0 : 0, 0),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
            child: Text(
              widget.label,
              style: AppTypography.label(
                context,
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
