import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/settings/settings_provider.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_theme.dart';
import 'package:ahmed_rasmy_portfolio/core/animation/idle_ticker.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/cursor_controller.dart';
import 'package:ahmed_rasmy_portfolio/core/utils/asset_checker.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/case_study_page.dart';
import 'package:ahmed_rasmy_portfolio/features/home/home_page.dart';
import 'package:ahmed_rasmy_portfolio/features/host_venue/host_venue_page.dart';
import 'package:ahmed_rasmy_portfolio/features/resume/resume_page.dart';

/// Logical widths to smoke-test for overflow / layout assertions.
const _widths = <double>[320, 360, 390, 430, 600, 768, 1024, 1440];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    await AssetChecker.init();
  });

  setUp(() {
    // Global cursor ticker must not outlive the test tree.
    cursorController.setEnabled(false);
  });

  tearDown(() {
    cursorController.setEnabled(false);
  });

  for (final locale in const [Locale('en'), Locale('ar')]) {
    for (final width in _widths) {
      testWidgets(
        'HomePage ${locale.languageCode} @ ${width.toInt()}',
        (tester) async {
          await _pumpPage(
            tester,
            locale: locale,
            width: width,
            child: const HomePage(),
          );
        },
      );

      testWidgets(
        'CaseStudyPage gatherup ${locale.languageCode} @ ${width.toInt()}',
        (tester) async {
          await _pumpPage(
            tester,
            locale: locale,
            width: width,
            child: const CaseStudyPage(slug: 'gatherup'),
          );
        },
      );

      testWidgets(
        'HostVenuePage ${locale.languageCode} @ ${width.toInt()}',
        (tester) async {
          await _pumpPage(
            tester,
            locale: locale,
            width: width,
            child: const HostVenuePage(),
          );
        },
      );

      testWidgets(
        'ResumePage ${locale.languageCode} @ ${width.toInt()}',
        (tester) async {
          await _pumpPage(
            tester,
            locale: locale,
            width: width,
            child: const ResumePage(),
          );
        },
      );
    }
  }
}

Future<void> _pumpPage(
  WidgetTester tester, {
  required Locale locale,
  required double width,
  required Widget child,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final height = width < 600 ? 900.0 : 1024.0;

  final errors = <FlutterErrorDetails>[];
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    errors.add(details);
    previous?.call(details);
  };

  addTearDown(() {
    FlutterError.onError = previous;
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1;

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        idleTickerProvider.overrideWith((ref) {
          final ticker = IdleTicker()..setReducedMotion(true);
          ref.onDispose(ticker.dispose);
          return ticker;
        }),
      ],
      child: MediaQuery(
        data: MediaQueryData(
          size: Size(width, height),
          textScaler: TextScaler.noScaling,
          disableAnimations: true,
          accessibleNavigation: true,
          platformBrightness: Brightness.dark,
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.withLocale(AppTheme.dark, locale),
          darkTheme: AppTheme.withLocale(AppTheme.dark, locale),
          themeMode: ThemeMode.dark,
          home: child,
        ),
      ),
    ),
  );

  // Bounded pumps — infinite idle / scroll-hint loops prevent pumpAndSettle.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 16));
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump(const Duration(seconds: 1));

  // Scroll a bit to exercise sticky nav / reveal paths without settling forever.
  final scrollables = find.byType(Scrollable);
  if (scrollables.evaluate().isNotEmpty) {
    await tester.drag(scrollables.first, const Offset(0, -400));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));
  }

  final overflow = errors.where((e) {
    final msg = e.exceptionAsString();
    return msg.contains('overflowed') ||
        msg.contains('RenderFlex') ||
        msg.contains('BOX CONSTRAINTS') ||
        msg.contains('Cannot hit test') ||
        msg.contains('FAILED ASSERTION');
  }).toList();

  expect(
    overflow,
    isEmpty,
    reason:
        'Layout/overflow errors at ${width.toInt()}px ${locale.languageCode}:\n'
        '${overflow.map((e) => e.exceptionAsString()).join('\n---\n')}',
  );

  // Surface any other uncaught exception from the last frame.
  final pending = tester.takeException();
  if (pending != null) {
    fail(
      'Uncaught exception at ${width.toInt()}px ${locale.languageCode}: '
      '$pending\n${StackTrace.current}',
    );
  }
}
