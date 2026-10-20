import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';

/// Manga-style radial speed lines + Ben-Day dots. Paths cached; no per-frame rebuild.
class ComicBurstPainter extends CustomPainter {
  ComicBurstPainter({
    required this.lightMode,
    this.rayCount = 48,
  })  : _rays = _buildRays(rayCount, lightMode),
        _dots = _buildDots(lightMode),
        _starbursts = _buildStarbursts();

  final bool lightMode;
  final int rayCount;

  final List<_RaySpec> _rays;
  final List<_DotSpec> _dots;
  final List<Path> _starbursts;

  static List<_RaySpec> _buildRays(int count, bool lightMode) {
    final rng = math.Random(42);
    final colors = lightMode
        ? [
            AppColors.navyInk.withValues(alpha: 0.22),
            AppColors.flutterLightBlue.withValues(alpha: 0.28),
            AppColors.flutterBlue.withValues(alpha: 0.2),
            Colors.white.withValues(alpha: 0.18),
          ]
        : [
            AppColors.flutterLightBlue.withValues(alpha: 0.45),
            AppColors.flutterBlue.withValues(alpha: 0.35),
            Colors.white.withValues(alpha: 0.28),
            AppColors.flutterLightBlue.withValues(alpha: 0.55),
          ];

    final rays = <_RaySpec>[];
    for (var i = 0; i < count; i++) {
      final a0 = (i / count) * math.pi * 2 + rng.nextDouble() * 0.04;
      final span = (0.018 + rng.nextDouble() * 0.035) * (rng.nextBool() ? 1.2 : 0.7);
      final len = 0.55 + rng.nextDouble() * 0.42;
      final color = colors[i % colors.length]
          .withValues(alpha: (0.25 + rng.nextDouble() * 0.35).clamp(0.15, 0.6));
      rays.add(_RaySpec(a0: a0, span: span, length: len, color: color));
    }
    return rays;
  }

  static List<_DotSpec> _buildDots(bool lightMode) {
    final rng = math.Random(99);
    final dots = <_DotSpec>[];
    final base = lightMode
        ? AppColors.flutterLightBlue.withValues(alpha: 0.14)
        : AppColors.flutterLightBlue.withValues(alpha: 0.2);
    for (var i = 0; i < 120; i++) {
      final a = rng.nextDouble() * math.pi * 2;
      final d = 0.25 + rng.nextDouble() * 0.7;
      final r = 0.004 + d * 0.018 * (0.6 + rng.nextDouble());
      dots.add(_DotSpec(angle: a, dist: d, radius: r, color: base));
    }
    return dots;
  }

  static List<Path> _buildStarbursts() {
    final rng = math.Random(7);
    final paths = <Path>[];
    for (var s = 0; s < 3; s++) {
      final cx = 0.35 + rng.nextDouble() * 0.3;
      final cy = 0.55 + rng.nextDouble() * 0.25;
      final path = Path();
      const spikes = 8;
      for (var i = 0; i < spikes; i++) {
        final a = (i / spikes) * math.pi * 2;
        final r = (i.isEven ? 0.04 : 0.02) * (0.8 + rng.nextDouble() * 0.4);
        final x = cx + math.cos(a) * r;
        final y = cy + math.sin(a) * r;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      paths.add(path);
    }
    return paths;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final maxR = size.shortestSide * 0.5;

    for (final ray in _rays) {
      final outer = maxR * ray.length;
      final path = Path()
        ..moveTo(c.dx, c.dy)
        ..lineTo(
          c.dx + math.cos(ray.a0) * outer,
          c.dy + math.sin(ray.a0) * outer,
        )
        ..lineTo(
          c.dx + math.cos(ray.a0 + ray.span) * outer * 0.92,
          c.dy + math.sin(ray.a0 + ray.span) * outer * 0.92,
        )
        ..close();

      final paint = Paint()
        ..shader = ui.Gradient.radial(
          c,
          outer,
          [
            ray.color,
            ray.color.withValues(alpha: 0),
          ],
          const [0.15, 1.0],
        );
      canvas.drawPath(path, paint);
    }

    final dotPaint = Paint();
    for (final d in _dots) {
      dotPaint.color = d.color;
      canvas.drawCircle(
        Offset(
          c.dx + math.cos(d.angle) * maxR * d.dist,
          c.dy + math.sin(d.angle) * maxR * d.dist,
        ),
        maxR * d.radius,
        dotPaint,
      );
    }

    final starPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = (lightMode ? AppColors.navyInk : AppColors.flutterLightBlue)
          .withValues(alpha: 0.35);
    final matrix = Matrix4.diagonal3Values(size.width, size.height, 1);
    for (final p in _starbursts) {
      canvas.drawPath(p.transform(matrix.storage), starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ComicBurstPainter oldDelegate) =>
      oldDelegate.lightMode != lightMode || oldDelegate.rayCount != rayCount;
}

class _RaySpec {
  const _RaySpec({
    required this.a0,
    required this.span,
    required this.length,
    required this.color,
  });
  final double a0;
  final double span;
  final double length;
  final Color color;
}

class _DotSpec {
  const _DotSpec({
    required this.angle,
    required this.dist,
    required this.radius,
    required this.color,
  });
  final double angle;
  final double dist;
  final double radius;
  final Color color;
}
