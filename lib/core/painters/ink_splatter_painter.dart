import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';

class InkSplatterPainter extends CustomPainter {
  InkSplatterPainter({this.color = AppColors.flutterLightBlue})
      : _blot = _buildBlot(),
        _dots = _buildDots();

  final Color color;
  final Path _blot;
  final List<(Offset, double)> _dots;

  static Path _buildBlot() {
    final rng = math.Random(7);
    const cx = 0.42;
    const cy = 0.48;
    final blot = Path();
    for (var i = 0; i < 18; i++) {
      final a = (i / 18) * math.pi * 2;
      final r = 0.28 + rng.nextDouble() * 0.22 + (i.isEven ? 0.08 : 0);
      final x = cx + math.cos(a) * r;
      final y = cy + math.sin(a) * r * 0.85;
      if (i == 0) {
        blot.moveTo(x, y);
      } else {
        blot.lineTo(x, y);
      }
    }
    blot.close();
    return blot;
  }

  static List<(Offset, double)> _buildDots() {
    final rng = math.Random(7);
    return List.generate(40, (_) {
      final a = rng.nextDouble() * math.pi * 2;
      final d = 0.35 + rng.nextDouble() * 0.45;
      final r = 1.0 + rng.nextDouble() * 3.5;
      return (
        Offset(0.42 + math.cos(a) * d, 0.48 + math.sin(a) * d * 0.9),
        r,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final matrix = Matrix4.diagonal3Values(size.width, size.height, 1);
    canvas.drawPath(_blot.transform(matrix.storage), paint);

    final shortest = size.shortestSide;
    final dotPaint = Paint()..color = color.withValues(alpha: 0.85);
    for (final (n, r) in _dots) {
      canvas.drawCircle(
        Offset(n.dx * size.width, n.dy * size.height),
        r * (shortest / 180),
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant InkSplatterPainter oldDelegate) =>
      oldDelegate.color != color;
}
