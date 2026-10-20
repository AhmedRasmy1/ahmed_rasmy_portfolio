import 'package:flutter/material.dart';

class TapePainter extends CustomPainter {
  TapePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, size.height * 0.15)
      ..lineTo(size.width * 0.08, 0)
      ..lineTo(size.width, size.height * 0.2)
      ..lineTo(size.width * 0.94, size.height)
      ..lineTo(size.width * 0.05, size.height * 0.92)
      ..close();
    canvas.drawPath(path, paint);

    // Slight translucency stripes
    final stripe = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 6) {
      canvas.drawLine(Offset(x, 0), Offset(x + 4, size.height), stripe);
    }
  }

  @override
  bool shouldRepaint(covariant TapePainter oldDelegate) =>
      oldDelegate.color != color;
}

class TapeStrip extends StatelessWidget {
  const TapeStrip({
    super.key,
    required this.color,
    this.width = 88,
    this.height = 22,
    this.angle = 0.04,
  });

  final Color color;
  final double width;
  final double height;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: CustomPaint(
        size: Size(width, height),
        painter: TapePainter(color: color),
      ),
    );
  }
}
