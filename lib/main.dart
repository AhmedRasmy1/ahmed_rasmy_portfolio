import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ahmed_rasmy_portfolio/app/app.dart';
import 'package:ahmed_rasmy_portfolio/app/settings/settings_provider.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_theme.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/asset_paths.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/branded_loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Yellow text baselines from debug paint must never ship.
  debugPaintBaselinesEnabled = false;

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const _BootstrapApp(),
    ),
  );
}

class _BootstrapApp extends StatefulWidget {
  const _BootstrapApp();

  @override
  State<_BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<_BootstrapApp> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    // Preload Latin + Arabic fonts to avoid FOUT on first paint / locale switch.
    await AppTheme.preloadFonts();
    if (!mounted) return;
    setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: BrandedLoader()),
      );
    }
    return const _PrecacheShell(child: PortfolioApp());
  }
}

/// Precaches portrait / dash / grain once a real MediaQuery exists.
class _PrecacheShell extends StatefulWidget {
  const _PrecacheShell({required this.child});

  final Widget child;

  @override
  State<_PrecacheShell> createState() => _PrecacheShellState();
}

class _PrecacheShellState extends State<_PrecacheShell> {
  bool _imagesReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_imagesReady) return;
    _precache();
  }

  Future<void> _precache() async {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    // Decode at ≥2× expected max display width for crisp portraits.
    final portraitWidth = (620 * dpr * 2).round().clamp(1200, 2800);

    await Future.wait([
      precacheImage(
        ResizeImage(
          const AssetImage(AssetPaths.portrait),
          width: portraitWidth,
        ),
        context,
      ),
      precacheImage(const AssetImage(AssetPaths.dash), context),
      precacheImage(const AssetImage(AssetPaths.grain), context),
    ]);

    if (mounted) setState(() => _imagesReady = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_imagesReady) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: BrandedLoader()),
      );
    }
    return widget.child;
  }
}
