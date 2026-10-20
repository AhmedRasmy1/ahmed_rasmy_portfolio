import 'dart:math' as math;

import 'package:flutter/material.dart';

class TornPaperClipper extends CustomClipper<Path> {
  TornPaperClipper({this.seed = 3});

  final int seed;

  @override
  Path getClip(Size size) {
    final rng = math.Random(seed);
    final path = Path();
    const steps = 28;

    path.moveTo(0, rng.nextDouble() * 3);
    for (var i = 1; i <= steps; i++) {
      final x = size.width * (i / steps);
      final y = (rng.nextDouble() - 0.5) * 4;
      path.lineTo(x, y.abs());
    }
    for (var i = 1; i <= steps; i++) {
      final y = size.height * (i / steps);
      final x = size.width + (rng.nextDouble() - 0.5) * 4;
      path.lineTo(x.clamp(size.width - 3, size.width + 1), y);
    }
    for (var i = 1; i <= steps; i++) {
      final x = size.width * (1 - i / steps);
      final y = size.height + (rng.nextDouble() - 0.5) * 4;
      path.lineTo(x, y.clamp(size.height - 3, size.height + 1));
    }
    for (var i = 1; i <= steps; i++) {
      final y = size.height * (1 - i / steps);
      final x = (rng.nextDouble() - 0.5) * 4;
      path.lineTo(x.abs(), y);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant TornPaperClipper oldClipper) =>
      oldClipper.seed != seed;
}
