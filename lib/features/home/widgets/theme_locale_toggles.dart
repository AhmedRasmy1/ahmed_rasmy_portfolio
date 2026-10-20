import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/settings/settings_provider.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/cursor_controller.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';

class ThemeLocaleToggles extends ConsumerWidget {
  const ThemeLocaleToggles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final zine = context.zine;
    final isDark = settings.themeMode != ThemeMode.light;
    final isEn = (settings.locale?.languageCode ?? 'en') != 'ar';

    final custom = cursorController.enabled;

    return CursorTarget(
      enabled: custom,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.end,
        children: [
          _SegmentedToggle(
            left: l10n.themeDark,
            right: l10n.themeLight,
            leftActive: isDark,
            onLeft: () => ref
                .read(settingsProvider.notifier)
                .setThemeMode(ThemeMode.dark),
            onRight: () => ref
                .read(settingsProvider.notifier)
                .setThemeMode(ThemeMode.light),
            ink: zine.ink,
            hideNativeCursor: custom,
          ),
          _SegmentedToggle(
            left: l10n.langEn,
            right: l10n.langAr,
            leftActive: isEn,
            onLeft: () => ref
                .read(settingsProvider.notifier)
                .setLocale(const Locale('en')),
            onRight: () => ref
                .read(settingsProvider.notifier)
                .setLocale(const Locale('ar')),
            ink: zine.ink,
            hideNativeCursor: custom,
          ),
        ],
      ),
    );
  }
}

class _SegmentedToggle extends StatelessWidget {
  const _SegmentedToggle({
    required this.left,
    required this.right,
    required this.leftActive,
    required this.onLeft,
    required this.onRight,
    required this.ink,
    this.hideNativeCursor = false,
  });

  final String left;
  final String right;
  final bool leftActive;
  final VoidCallback onLeft;
  final VoidCallback onRight;
  final Color ink;
  final bool hideNativeCursor;

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.spaceMono(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
      decoration: TextDecoration.none,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ink.withValues(alpha: 0.7), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Seg(
            label: left,
            active: leftActive,
            onTap: onLeft,
            style: style,
            ink: ink,
            hideNativeCursor: hideNativeCursor,
          ),
          _Seg(
            label: right,
            active: !leftActive,
            onTap: onRight,
            style: style,
            ink: ink,
            hideNativeCursor: hideNativeCursor,
          ),
        ],
      ),
    );
  }
}

class _Seg extends StatelessWidget {
  const _Seg({
    required this.label,
    required this.active,
    required this.onTap,
    required this.style,
    required this.ink,
    this.hideNativeCursor = false,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final TextStyle style;
  final Color ink;
  final bool hideNativeCursor;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: hideNativeCursor
          ? SystemMouseCursors.none
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          color: active ? AppColors.flutterBlue : Colors.transparent,
          child: Text(
            label,
            style: style.copyWith(
              color: active ? AppColors.offWhite : ink,
            ),
          ),
        ),
      ),
    );
  }
}
