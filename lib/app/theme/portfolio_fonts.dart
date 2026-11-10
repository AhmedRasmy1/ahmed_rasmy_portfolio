import 'package:flutter/services.dart';

/// Bundled portfolio fonts (loaded via [FontLoader], not runtime Google Fonts).
///
/// Families are registered only after [loadForArabic] / [loadForLatin] succeeds.
/// Missing assets fail soft so the app still runs with platform fallbacks.
abstract final class PortfolioFonts {
  static const bebasNeue = 'BebasNeue';
  static const permanentMarker = 'PermanentMarker';
  static const kalam = 'Kalam';
  static const spaceMono = 'SpaceMono';
  static const lalezar = 'Lalezar';
  static const marhey = 'Marhey';
  static const playpenSansArabic = 'PlaypenSansArabic';
  static const ibmPlexSansArabic = 'IBMPlexSansArabic';

  static const allowedArabicFamilies = <String>{
    lalezar,
    marhey,
    playpenSansArabic,
    ibmPlexSansArabic,
    // Latin fallbacks declared on Arabic styles for mixed script runs.
    bebasNeue,
    permanentMarker,
    kalam,
    spaceMono,
  };

  static final Set<String> _loaded = {};

  static bool isLoaded(String family) => _loaded.contains(family);

  static Future<void> loadForLocale({required bool arabic}) async {
    if (arabic) {
      await loadForArabic();
    } else {
      await loadForLatin();
    }
  }

  static Future<void> loadForLatin() async {
    await Future.wait([
      _load(bebasNeue, const [
        'assets/fonts/bebasneue/BebasNeue-Regular.ttf',
      ]),
      _load(permanentMarker, const [
        'assets/fonts/permanentmarker/PermanentMarker-Regular.ttf',
      ]),
      _load(kalam, const [
        'assets/fonts/kalam/Kalam-Regular.ttf',
        'assets/fonts/kalam/Kalam-Bold.ttf',
      ]),
      _load(spaceMono, const [
        'assets/fonts/spacemono/SpaceMono-Regular.ttf',
        'assets/fonts/spacemono/SpaceMono-Bold.ttf',
      ]),
    ]);
  }

  static Future<void> loadForArabic() async {
    await Future.wait([
      _load(lalezar, const [
        'assets/fonts/lalezar/Lalezar-Regular.ttf',
      ]),
      _load(marhey, const [
        'assets/fonts/marhey/Marhey-Variable.ttf',
      ]),
      _load(playpenSansArabic, const [
        'assets/fonts/playpensansarabic/PlaypenSansArabic-Variable.ttf',
      ]),
      _load(ibmPlexSansArabic, const [
        'assets/fonts/ibmplexsansarabic/IBMPlexSansArabic-Regular.ttf',
        'assets/fonts/ibmplexsansarabic/IBMPlexSansArabic-SemiBold.ttf',
        'assets/fonts/ibmplexsansarabic/IBMPlexSansArabic-Bold.ttf',
      ]),
      // Latin fallbacks for mixed EN tokens inside Arabic copy.
      _load(bebasNeue, const [
        'assets/fonts/bebasneue/BebasNeue-Regular.ttf',
      ]),
      _load(permanentMarker, const [
        'assets/fonts/permanentmarker/PermanentMarker-Regular.ttf',
      ]),
      _load(kalam, const [
        'assets/fonts/kalam/Kalam-Regular.ttf',
        'assets/fonts/kalam/Kalam-Bold.ttf',
      ]),
      _load(spaceMono, const [
        'assets/fonts/spacemono/SpaceMono-Regular.ttf',
        'assets/fonts/spacemono/SpaceMono-Bold.ttf',
      ]),
    ]);
  }

  /// Loads the opposite locale after first paint (idle).
  static Future<void> loadOtherLocale({required bool currentIsArabic}) {
    return loadForLocale(arabic: !currentIsArabic);
  }

  static Future<void> _load(String family, List<String> assetPaths) async {
    if (_loaded.contains(family)) return;
    try {
      final loader = FontLoader(family);
      for (final path in assetPaths) {
        loader.addFont(rootBundle.load(path));
      }
      await loader.load();
      _loaded.add(family);
    } catch (_) {
      // Asset missing or still downloading — platform fallback until files exist.
    }
  }
}
