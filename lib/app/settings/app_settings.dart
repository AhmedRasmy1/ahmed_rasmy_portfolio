import 'package:flutter/material.dart';

@immutable
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.locale,
  });

  /// [ThemeMode.system] follows the OS / browser preference.
  final ThemeMode themeMode;

  /// `null` means follow the platform locale (with EN fallback via MaterialApp).
  final Locale? locale;

  AppSettings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool clearLocale = false,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: clearLocale ? null : (locale ?? this.locale),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AppSettings &&
        other.themeMode == themeMode &&
        other.locale == locale;
  }

  @override
  int get hashCode => Object.hash(themeMode, locale);
}
