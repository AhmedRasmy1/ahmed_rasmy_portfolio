// ignore_for_file: avoid_print
// Cross-platform asset importer: strip metadata, resize without upscale/crop.
// Usage: dart run tool/import_assets.dart
import 'dart:io';

import 'package:image/image.dart' as img;

enum _Kind { cover, screenshot }

class _Mapping {
  const _Mapping({
    required this.source,
    required this.dest,
    required this.kind,
  });

  final String source;
  /// Preferred destination. Covers may become `.jpg` when JPEG is much smaller.
  final String dest;
  final _Kind kind;
}

/// Repeatable source → dest table (verified against visual content).
const _mappings = <_Mapping>[
  _Mapping(
    source: 'incoming_assets/elmohamndes_image.png',
    dest: 'assets/images/projects/elmohandes/cover.png',
    kind: _Kind.cover,
  ),
  _Mapping(
    source: 'incoming_assets/flowery_image.png',
    dest: 'assets/images/projects/flowery/cover.png',
    kind: _Kind.cover,
  ),
  _Mapping(
    source: 'incoming_assets/servicex_image.png',
    dest: 'assets/images/projects/servicex/cover.png',
    kind: _Kind.cover,
  ),
  _Mapping(
    source: 'incoming_assets/اعلان 1 للابليكيشن.png',
    dest: 'assets/images/projects/awwaab/cover.png',
    kind: _Kind.cover,
  ),
  // Host Mode screenshots (classified by looking at each image)
  _Mapping(
    source: 'incoming_assets/WhatsApp Image 2026-11-05 at 1.54.34 PM (1).jpeg',
    dest: 'assets/images/projects/gatherup/host-venue/host-01-home.jpg',
    kind: _Kind.screenshot,
  ),
  _Mapping(
    source: 'incoming_assets/WhatsApp Image 2026-11-05 at 1.54.34 PM.jpeg',
    dest: 'assets/images/projects/gatherup/host-venue/host-02-sessions.jpg',
    kind: _Kind.screenshot,
  ),
  _Mapping(
    source: 'incoming_assets/WhatsApp Image 2026-11-05 at 3.55.27 PM (1).jpeg',
    dest: 'assets/images/projects/gatherup/host-venue/host-03-create.jpg',
    kind: _Kind.screenshot,
  ),
  _Mapping(
    source: 'incoming_assets/WhatsApp Image 2026-11-05 at 3.55.27 PM.jpeg',
    dest: 'assets/images/projects/gatherup/host-venue/host-04-create-options.jpg',
    kind: _Kind.screenshot,
  ),
  _Mapping(
    source: 'incoming_assets/WhatsApp Image 2026-11-05 at 1.54.35 PM (3).jpeg',
    dest: 'assets/images/projects/gatherup/host-venue/host-05-members.jpg',
    kind: _Kind.screenshot,
  ),
  _Mapping(
    source: 'incoming_assets/WhatsApp Image 2026-11-05 at 1.54.35 PM (2).jpeg',
    dest: 'assets/images/projects/gatherup/host-venue/host-06-reviews.jpg',
    kind: _Kind.screenshot,
  ),
  _Mapping(
    source: 'incoming_assets/WhatsApp Image 2026-11-05 at 1.54.35 PM (1).jpeg',
    dest: 'assets/images/projects/gatherup/host-venue/host-07-chats.jpg',
    kind: _Kind.screenshot,
  ),
  _Mapping(
    source: 'incoming_assets/WhatsApp Image 2026-11-05 at 1.54.35 PM.jpeg',
    dest: 'assets/images/projects/gatherup/host-venue/host-08-insights.jpg',
    kind: _Kind.screenshot,
  ),
];

String _fmt(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  }
  return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
}

img.Image _downscaleOnly(img.Image src, int maxWidth) {
  if (src.width <= maxWidth) return src;
  final h = (src.height * (maxWidth / src.width)).round();
  return img.copyResize(
    src,
    width: maxWidth,
    height: h,
    interpolation: img.Interpolation.linear,
  );
}

bool _hasTransparency(img.Image image) {
  if (!image.hasAlpha) return false;
  for (final p in image) {
    if (p.a < 255) return true;
  }
  return false;
}

String _jpgSibling(String pngPath) {
  if (pngPath.toLowerCase().endsWith('.png')) {
    return '${pngPath.substring(0, pngPath.length - 4)}.jpg';
  }
  return pngPath;
}

/// Returns the path actually written.
Future<String> _writeCover(img.Image image, String destPath) async {
  final resized = _downscaleOnly(image, 1600);
  final pngBytes = img.encodePng(resized, level: 9);

  if (!_hasTransparency(resized)) {
    final jpgBytes = img.encodeJpg(resized, quality: 85);
    if (jpgBytes.length < pngBytes.length * 0.65) {
      final jpgPath = _jpgSibling(destPath);
      // Remove a stale PNG if we previously wrote one.
      final png = File(destPath);
      if (png.existsSync() && jpgPath != destPath) {
        png.deleteSync();
      }
      await File(jpgPath).writeAsBytes(jpgBytes, flush: true);
      print('    encoded as JPEG (PNG would be ${_fmt(pngBytes.length)})');
      return jpgPath;
    }
  }

  final jpgSibling = File(_jpgSibling(destPath));
  if (jpgSibling.existsSync() && jpgSibling.path != destPath) {
    jpgSibling.deleteSync();
  }
  await File(destPath).writeAsBytes(pngBytes, flush: true);
  print('    encoded as PNG');
  return destPath;
}

Future<void> _writeScreenshot(img.Image image, String destPath) async {
  final resized = _downscaleOnly(image, 1170);
  final bytes = img.encodeJpg(resized, quality: 82);
  await File(destPath).writeAsBytes(bytes, flush: true);
}

Future<void> main() async {
  print('=== import_assets ===');
  var ok = 0;
  var fail = 0;

  for (final m in _mappings) {
    final src = File(m.source);
    if (!src.existsSync()) {
      stderr.writeln('MISSING source: ${m.source}');
      fail++;
      continue;
    }

    final before = src.lengthSync();
    final bytes = await src.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      stderr.writeln('FAILED decode: ${m.source}');
      fail++;
      continue;
    }

    // Working copy; re-encode drops EXIF / WhatsApp metadata.
    final clean = img.Image.from(decoded);

    File(m.dest).parent.createSync(recursive: true);

    print(m.source);
    print('  mapped: ${m.dest}');
    print('  before: ${_fmt(before)} (${decoded.width}x${decoded.height})');

    late final String written;
    if (m.kind == _Kind.screenshot) {
      await _writeScreenshot(clean, m.dest);
      written = m.dest;
    } else {
      written = await _writeCover(clean, m.dest);
    }

    final after = File(written).lengthSync();
    final outW = _downscaleOnly(
      clean,
      m.kind == _Kind.screenshot ? 1170 : 1600,
    ).width;
    final ratio = before == 0 ? 0 : (after / before * 100);
    print('  wrote:  $written');
    print(
      '  after:  ${_fmt(after)} (${outW}w) '
      '${ratio.toStringAsFixed(0)}% of original',
    );
    ok++;
  }

  print('');
  print('Done: $ok imported, $fail failed.');
  if (fail > 0) exit(1);
}
