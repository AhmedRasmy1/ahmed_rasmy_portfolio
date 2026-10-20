import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ahmed_rasmy_portfolio/app/app.dart';
import 'package:ahmed_rasmy_portfolio/app/settings/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hydrate prefs before first frame to avoid theme/locale flash.
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const PortfolioApp(),
    ),
  );
}
