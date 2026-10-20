import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/router/app_router.dart';
import 'package:ahmed_rasmy_portfolio/app/settings/settings_provider.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_theme.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/breakpoints.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/cursor_controller.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final router = ref.watch(appRouterProvider);
    final themeMode = settings.themeMode == ThemeMode.system
        ? ThemeMode.dark
        : settings.themeMode;

    final light = AppTheme.withLocale(AppTheme.light, settings.locale);
    final dark = AppTheme.withLocale(AppTheme.dark, settings.locale);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: light,
      darkTheme: dark,
      themeMode: themeMode,
      themeAnimationDuration: const Duration(milliseconds: 400),
      themeAnimationCurve: Curves.easeInOutCubic,
      builder: (context, child) {
        return _CursorShell(child: child ?? const SizedBox.shrink());
      },
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supported) {
        if (settings.locale != null) return settings.locale;
        if (locale == null) return supported.first;
        for (final candidate in supported) {
          if (candidate.languageCode == locale.languageCode) {
            return candidate;
          }
        }
        return supported.first;
      },
      routerConfig: router,
    );
  }
}

class _CursorShell extends StatelessWidget {
  const _CursorShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final touch = MediaQuery.of(context).size.shortestSide < 600 ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
    final enableCustom = kIsWeb &&
        !touch &&
        !reduceMotion &&
        !Breakpoints.isMobile(width);

    cursorController.setEnabled(enableCustom);

    return DefaultTextStyle.merge(
      style: const TextStyle(decoration: TextDecoration.none),
      child: MouseRegion(
        cursor: enableCustom
            ? SystemMouseCursors.none
            : MouseCursor.defer,
        onHover: enableCustom
            ? (e) => cursorController.updatePosition(e.position)
            : null,
        onExit: enableCustom ? (_) => cursorController.hide() : null,
        child: Listener(
          onPointerDown: enableCustom
              ? (_) => cursorController.setPressed(true)
              : null,
          onPointerUp: enableCustom
              ? (_) => cursorController.setPressed(false)
              : null,
          onPointerCancel: enableCustom
              ? (_) => cursorController.setPressed(false)
              : null,
          child: Stack(
            fit: StackFit.expand,
            children: [
              child,
              if (enableCustom)
                CustomCursorOverlay(controller: cursorController),
            ],
          ),
        ),
      ),
    );
  }
}
