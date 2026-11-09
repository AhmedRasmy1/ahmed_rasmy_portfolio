// ignore_for_file: avoid_print
// Analyzes build/web after `flutter build web --release`.
// Usage: dart run tool/size_report.dart
import 'dart:io';

void main(List<String> args) {
  final root = Directory('build/web');
  if (!root.existsSync()) {
    stderr.writeln('build/web not found. Run: flutter build web --release');
    exit(1);
  }

  final files = root
      .listSync(recursive: true)
      .whereType<File>()
      .map((f) => (path: f.path.replaceAll('\\', '/'), size: f.lengthSync()))
      .toList()
    ..sort((a, b) => b.size.compareTo(a.size));

  final total = files.fold<int>(0, (sum, f) => sum + f.size);

  print('=== build/web size report ===');
  print('Total: ${_fmt(total)} (${files.length} files)');
  print('');
  print('Top 20 largest files:');
  for (final f in files.take(20)) {
    final rel = f.path.startsWith('build/web/')
        ? f.path.substring('build/web/'.length)
        : f.path;
    print('  ${_fmt(f.size).padLeft(10)}  $rel');
  }

  // First-visit estimate: HTML shell + main.dart.js + flutter bootstrap +
  // canvaskit/skwasm entry typically fetched (not every optional renderer).
  final firstVisitNames = <String>{
    'index.html',
    'flutter_bootstrap.js',
    'flutter.js',
    'main.dart.js',
    'manifest.json',
    'favicon.png',
  };
  var firstBytes = 0;
  final counted = <String>[];
  for (final f in files) {
    final name = f.path.split('/').last;
    final rel = f.path.startsWith('build/web/')
        ? f.path.substring('build/web/'.length)
        : f.path;
    final isAsset = rel.startsWith('assets/');
    final isPrimaryJs = firstVisitNames.contains(name) ||
        rel == 'main.dart.js' ||
        rel.endsWith('/main.dart.js');
    // Include one canvaskit/skwasm wasm if present (browser picks one renderer).
    final isRenderer = rel.contains('canvaskit/canvaskit.wasm') ||
        rel.contains('canvaskit/skwasm.wasm');
    if (isPrimaryJs ||
        (isRenderer && !counted.any((c) => c.contains('.wasm'))) ||
        (isAsset &&
            (rel.contains('ahmed_rasmy_image') ||
                rel.contains('grain.png') ||
                rel.contains('dash.png')))) {
      firstBytes += f.size;
      counted.add(rel);
    }
  }

  print('');
  print('Estimated first-time visitor download (shell + main JS + one renderer wasm + hero assets):');
  print('  ${_fmt(firstBytes)}');
  for (final c in counted) {
    final match = files.firstWhere((f) => f.path.endsWith(c) || f.path.contains(c));
    print('    ${_fmt(match.size).padLeft(10)}  $c');
  }

  print('');
  print('Suggested safe size reductions:');
  final heavyImages = files.where((f) {
    final lower = f.path.toLowerCase();
    final isImg = lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp');
    return isImg && f.size > 300 * 1024;
  });
  if (heavyImages.isEmpty) {
    print('  - No images over 300 KB found in build/web.');
  } else {
    for (final f in heavyImages) {
      final rel = f.path.startsWith('build/web/')
          ? f.path.substring('build/web/'.length)
          : f.path;
      print(
        '  - Compress $rel (${_fmt(f.size)}) — prefer WebP/optimized PNG; keep visual fidelity.',
      );
    }
  }
  print(
    '  - Drop unused Google Fonts from AppTypography.preload (fallback families on demand).',
  );
  print(
    '  - Avoid shipping both PNG and JPG of the same portrait if one format is enough.',
  );
  print(
    '  - Prefer `flutter build web --wasm` for capable clients when measuring LCP (optional).',
  );
}

String _fmt(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  }
  return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
}
