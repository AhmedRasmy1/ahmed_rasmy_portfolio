import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/settings/settings_provider.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_theme.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_typography.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/portfolio_fonts.dart';
import 'package:ahmed_rasmy_portfolio/core/animation/idle_ticker.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/cursor_controller.dart';
import 'package:ahmed_rasmy_portfolio/core/utils/asset_checker.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/case_study_page.dart';
import 'package:ahmed_rasmy_portfolio/features/home/home_page.dart';
import 'package:ahmed_rasmy_portfolio/features/host_venue/host_venue_page.dart';
import 'package:ahmed_rasmy_portfolio/features/resume/resume_page.dart';

bool _containsArabic(String text) {
  return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
}

void _assertArabicTextStyles(Element element, List<String> failures) {
  final widget = element.widget;
  if (widget is RichText) {
    widget.text.visitChildren((span) {
      if (span is! TextSpan) return true;
      final text = span.text ?? '';
      if (!_containsArabic(text)) return true;
      final style = span.style;
      if (style == null) return true;
      final spacing = style.letterSpacing;
      if (spacing != null && spacing != 0) {
        failures.add(
          'Arabic letterSpacing=$spacing on "${text.length > 40 ? '${text.substring(0, 40)}…' : text}"',
        );
      }
      final family = style.fontFamily;
      final fallbacks = style.fontFamilyFallback ?? const <String>[];
      if (family != null &&
          !PortfolioFonts.allowedArabicFamilies.contains(family)) {
        failures.add(
          'Arabic fontFamily="$family" not allowed on "${text.length > 40 ? '${text.substring(0, 40)}…' : text}"',
        );
      }
      for (final fb in fallbacks) {
        if (!PortfolioFonts.allowedArabicFamilies.contains(fb)) {
          failures.add('Arabic fallback "$fb" not allowed');
        }
      }
      return true;
    });
  } else if (widget is Text) {
    final data = widget.data ?? widget.textSpan?.toPlainText() ?? '';
    if (_containsArabic(data)) {
      final style = widget.style;
      if (style != null) {
        final spacing = style.letterSpacing;
        if (spacing != null && spacing != 0) {
          failures.add('Arabic Text letterSpacing=$spacing on "$data"');
        }
        final family = style.fontFamily;
        if (family != null &&
            !PortfolioFonts.allowedArabicFamilies.contains(family)) {
          failures.add('Arabic Text fontFamily="$family" on "$data"');
        }
      }
    }
  }
}

Future<void> _pumpAr(
  WidgetTester tester, {
  required Widget child,
}) async {
  final prefs = await SharedPreferences.getInstance();
  cursorController.setEnabled(false);
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
        data: const MediaQueryData(
          size: Size(1024, 1400),
          textScaler: TextScaler.noScaling,
          disableAnimations: true,
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale('ar'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.withLocale(AppTheme.dark, const Locale('ar')),
          home: child,
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({'locale_language_code': 'ar'});
    await AssetChecker.init();
    await PortfolioFonts.loadForArabic();
  });

  setUp(() => cursorController.setEnabled(false));
  tearDown(() => cursorController.setEnabled(false));

  testWidgets('AR pages: no letterSpacing / only allowed Arabic families',
      (tester) async {
    final pages = <Widget>[
      const HomePage(),
      const CaseStudyPage(slug: 'gatherup'),
      const HostVenuePage(),
      const ResumePage(),
    ];

    for (final page in pages) {
      await _pumpAr(tester, child: page);
      final failures = <String>[];
      for (final el in tester.allElements) {
        _assertArabicTextStyles(el, failures);
      }
      expect(
        failures,
        isEmpty,
        reason: 'Failures on ${page.runtimeType}:\n${failures.join('\n')}',
      );
    }
  });

  testWidgets('context.caps does not uppercase Arabic locale strings',
      (tester) async {
    await _pumpAr(
      tester,
      child: Builder(
        builder: (context) {
          const sample = 'مرحبا Flutter';
          final cased = context.caps(sample);
          expect(cased, sample);
          expect(AppTypography.displayCase(context, 'Hello'), 'Hello');
          // Latin still uppercases under AR locale? displayCase is locale-gated:
          // under AR locale, even Latin strings are left alone.
          expect(AppTypography.displayCase(context, 'hello'), 'hello');
          return const SizedBox.shrink();
        },
      ),
    );
  });
}
