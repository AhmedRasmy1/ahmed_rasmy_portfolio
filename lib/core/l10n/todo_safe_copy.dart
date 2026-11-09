import 'package:flutter/foundation.dart';

/// Hides unresolved `TODO_*` copy so placeholders never leak into the UI.
///
/// In debug, each key is logged once when first resolved as a TODO.
abstract final class TodoSafeCopy {
  static final Set<String> _loggedKeys = <String>{};

  /// Returns [value] unchanged, or `''` when it still contains a `TODO_` marker.
  static String resolve(String key, String value) {
    if (!_isTodoValue(value)) return value;
    if (kDebugMode && _loggedKeys.add(key)) {
      debugPrint('TODO copy still unresolved: $key');
    }
    return '';
  }

  static bool _isTodoValue(String value) =>
      value.isEmpty || value.contains('TODO_');
}
