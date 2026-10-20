import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ahmed_rasmy_portfolio/app/settings/app_settings.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/app_constants.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main() '
    'after SharedPreferences.getInstance().',
  );
});

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<AppSettings> {
  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale_language_code';

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  AppSettings build() {
    return AppSettings(
      themeMode: _decodeThemeMode(_prefs.getString(_themeKey)),
      locale: _decodeLocale(_prefs.getString(_localeKey)),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _prefs.setString(_themeKey, mode.name);
  }

  /// Pass `null` to clear the override and follow the system locale.
  Future<void> setLocale(Locale? locale) async {
    if (locale == null) {
      state = state.copyWith(clearLocale: true);
      await _prefs.remove(_localeKey);
      return;
    }

    final code = locale.languageCode;
    if (!AppConstants.supportedLanguageCodes.contains(code)) {
      return;
    }

    state = state.copyWith(locale: Locale(code));
    await _prefs.setString(_localeKey, code);
  }

  static ThemeMode _decodeThemeMode(String? raw) {
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' || null => ThemeMode.system,
      _ => ThemeMode.system,
    };
  }

  static Locale? _decodeLocale(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (!AppConstants.supportedLanguageCodes.contains(raw)) return null;
    return Locale(raw);
  }
}
