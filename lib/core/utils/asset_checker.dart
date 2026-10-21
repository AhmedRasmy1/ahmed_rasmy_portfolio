import 'package:flutter/services.dart';

/// Loads the asset manifest once so optional assets never trigger network 404s.
abstract final class AssetChecker {
  static Set<String> _assets = {};
  static bool _ready = false;

  static bool get isReady => _ready;

  static Future<void> init() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    _assets = manifest.listAssets().toSet();
    _ready = true;
  }

  static bool has(String? path) {
    if (path == null || path.isEmpty) return false;
    if (!_ready) return false;
    if (_assets.contains(path)) return true;
    // Tolerate a leading slash variant.
    if (path.startsWith('/') && _assets.contains(path.substring(1))) {
      return true;
    }
    return false;
  }

  static List<String> existing(Iterable<String> paths) =>
      paths.where(has).toList(growable: false);
}
