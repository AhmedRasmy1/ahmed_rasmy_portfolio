import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';

class HandDrawnUnderlinePainter extends CustomPainter {
  /// Only used under "WHO I AM" — must stay Flutter Light Blue (#13B9FD).
  HandDrawnUnderlinePainter({this.color = const Color(0xFF13B9FD)});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    final path = Path()..moveTo(0, size.height * 0.55);
    for (var i = 0; i <= 12; i++) {
      final t = i / 12;
      path.lineTo(
        size.width * t,
        size.height * (0.55 + math.sin(t * math.pi * 3) * 0.25),
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant HandDrawnUnderlinePainter oldDelegate) =>
      oldDelegate.color != color;
}

class CurvedArrowPainter extends CustomPainter {
  CurvedArrowPainter({this.color = AppColors.flutterLightBlue});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.05, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.05,
        size.width * 0.92,
        size.height * 0.45,
      );
    canvas.drawPath(path, paint);

    final tip = Offset(size.width * 0.92, size.height * 0.45);
    canvas.drawLine(tip, tip + const Offset(-10, -8), paint);
    canvas.drawLine(tip, tip + const Offset(-4, 12), paint);
  }

  @override
  bool shouldRepaint(covariant CurvedArrowPainter oldDelegate) =>
      oldDelegate.color != color;
}

class StarburstBadgePainter extends CustomPainter {
  StarburstBadgePainter({this.color = AppColors.flutterBlue});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final path = Path();
    const spikes = 14;
    for (var i = 0; i < spikes; i++) {
      final a = (i / spikes) * math.pi * 2 - math.pi / 2;
      final r = i.isEven ? size.shortestSide * 0.5 : size.shortestSide * 0.38;
      final x = cx + math.cos(a) * r;
      final y = cy + math.sin(a) * r;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant StarburstBadgePainter oldDelegate) =>
      oldDelegate.color != color;
}

class FourPointStarPainter extends CustomPainter {
  FourPointStarPainter({this.color = AppColors.flutterLightBlue});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final path = Path()
      ..moveTo(cx, 0)
      ..quadraticBezierTo(cx, cy, size.width, cy)
      ..quadraticBezierTo(cx, cy, cx, size.height)
      ..quadraticBezierTo(cx, cy, 0, cy)
      ..quadraticBezierTo(cx, cy, cx, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant FourPointStarPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Faint Flutter-logo diamond decoration.
class FlutterDiamondPainter extends CustomPainter {
  FlutterDiamondPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width * 0.5, size.height)
      ..lineTo(0, size.height * 0.5)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant FlutterDiamondPainter oldDelegate) =>
      oldDelegate.color != color;
}
