// ignore_for_file: avoid_print

import 'dart:io';

/// Scans portfolio content sources for remaining TODO markers.
///
/// Usage: `dart run tool/find_todos.dart`
void main() {
  final root = Directory.current;
  final targets = <String, List<String>>{
    'l10n ARB': [
      'lib/app/l10n/app_en.arb',
      'lib/app/l10n/app_ar.arb',
    ],
    'portfolio_data': ['lib/core/constants/portfolio_data.dart'],
    'host_venue_data': ['lib/core/constants/host_venue_data.dart'],
  };

  const markers = ['TODO_REPLACE', 'TODO_URL', 'TODO_NAMES'];
  var total = 0;

  for (final entry in targets.entries) {
    final sectionHits = <String>[];
    for (final relative in entry.value) {
      final file = File(
        [
          root.path,
          ...relative.split('/'),
        ].join(Platform.pathSeparator),
      );
      if (!file.existsSync()) {
        sectionHits.add('  (missing) $relative');
        continue;
      }
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        for (final marker in markers) {
          if (!line.contains(marker)) continue;
          final key = _guessKey(line) ?? '(line ${i + 1})';
          sectionHits.add('  $marker  $key  →  $relative:${i + 1}');
          total++;
        }
      }
    }
    print('=== ${entry.key} (${sectionHits.length}) ===');
    if (sectionHits.isEmpty) {
      print('  (none)');
    } else {
      for (final hit in sectionHits) {
        print(hit);
      }
    }
    print('');
  }

  print('Total TODO markers: $total');
}

String? _guessKey(String line) {
  final arb = RegExp(r'"([A-Za-z0-9_]+)"\s*:').firstMatch(line);
  if (arb != null) return arb.group(1);

  final named = RegExp(r'([A-Za-z0-9_]+)\s*:\s*').firstMatch(line);
  if (named != null && line.contains('TODO_')) {
    final candidate = named.group(1)!;
    if (candidate != 'const' && candidate != 'final' && candidate != 'var') {
      return candidate;
    }
  }

  if (line.contains('LocalizedText(') && line.contains('TODO_')) {
    return 'LocalizedText';
  }
  return null;
}
