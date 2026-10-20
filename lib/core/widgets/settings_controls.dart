import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/settings/settings_provider.dart';

/// Theme + locale controls for verifying settings persistence during scaffolding.
class SettingsControls extends ConsumerWidget {
  const SettingsControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PopupMenuButton<ThemeMode>(
          tooltip: l10n.themeSystem,
          initialValue: settings.themeMode,
          onSelected: (mode) {
            ref.read(settingsProvider.notifier).setThemeMode(mode);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: ThemeMode.system,
              child: Text(l10n.themeSystem),
            ),
            PopupMenuItem(
              value: ThemeMode.light,
              child: Text(l10n.themeLight),
            ),
            PopupMenuItem(
              value: ThemeMode.dark,
              child: Text(l10n.themeDark),
            ),
          ],
          child: const Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 8),
            child: Icon(Icons.brightness_6_outlined),
          ),
        ),
        PopupMenuButton<String?>(
          tooltip: l10n.languageSystem,
          initialValue: settings.locale?.languageCode,
          onSelected: (code) {
            final locale = code == null ? null : Locale(code);
            ref.read(settingsProvider.notifier).setLocale(locale);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: null,
              child: Text(l10n.languageSystem),
            ),
            PopupMenuItem(
              value: 'en',
              child: Text(l10n.languageEnglish),
            ),
            PopupMenuItem(
              value: 'ar',
              child: Text(l10n.languageArabic),
            ),
          ],
          child: const Padding(
            padding: EdgeInsetsDirectional.only(start: 4, end: 12),
            child: Icon(Icons.language),
          ),
        ),
      ],
    );
  }
}
