import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';

/// Tiny Flutter-diamond spinner shown while fonts/images preload.
class BrandedLoader extends StatefulWidget {
  const BrandedLoader({super.key});

  @override
  State<BrandedLoader> createState() => _BrandedLoaderState();
}

class _BrandedLoaderState extends State<BrandedLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.deepNavy,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          child: const CustomPaint(
            size: Size(36, 36),
            painter: _FlutterDiamondPainter(),
          ),
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * math.pi * 2,
              child: child,
            );
          },
        ),
      ),
    );
  }
}

class _FlutterDiamondPainter extends CustomPainter {
  const _FlutterDiamondPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.flutterLightBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final path = Path()
      ..moveTo(size.width / 2, 2)
      ..lineTo(size.width - 2, size.height / 2)
      ..lineTo(size.width / 2, size.height - 2)
      ..lineTo(2, size.height / 2)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(
      path,
      Paint()..color = AppColors.flutterLightBlue.withValues(alpha: 0.25),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
