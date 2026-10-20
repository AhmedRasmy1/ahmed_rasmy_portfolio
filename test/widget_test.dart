import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ahmed_rasmy_portfolio/app/settings/app_settings.dart';
import 'package:ahmed_rasmy_portfolio/app/settings/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('settings default to dark theme and English', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);

    final settings = container.read(settingsProvider);
    expect(settings.themeMode, ThemeMode.dark);
    expect(settings.locale?.languageCode, 'en');
  });

  test('theme and locale persist via settings notifier', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(settingsProvider.notifier);
    await notifier.setThemeMode(ThemeMode.light);
    await notifier.setLocale(const Locale('ar'));

    expect(
      container.read(settingsProvider),
      const AppSettings(themeMode: ThemeMode.light, locale: Locale('ar')),
    );
    expect(prefs.getString('theme_mode'), 'light');
    expect(prefs.getString('locale_language_code'), 'ar');
  });
}
