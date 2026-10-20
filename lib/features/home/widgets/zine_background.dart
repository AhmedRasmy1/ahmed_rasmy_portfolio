import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/asset_paths.dart';
import 'package:ahmed_rasmy_portfolio/core/painters/hand_drawn_painter.dart';

class ZineBackground extends StatelessWidget {
  const ZineBackground({
    super.key,
    required this.parallax,
    required this.child,
  });

  final ValueNotifier<Offset> parallax;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final zine = context.zine;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [zine.canvasDeep, zine.canvas, zine.canvasDeep],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ValueListenableBuilder<Offset>(
            valueListenable: parallax,
            child: const SizedBox.expand(),
            builder: (context, offset, _) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.55 + offset.dy * 0.002),
                    radius: 0.75,
                    colors: [zine.glow, Colors.transparent],
                  ),
                ),
              );
            },
          ),
          RepaintBoundary(
            child: CustomPaint(
              painter: _HalftonePainter(
                color: zine.ink.withValues(alpha: 0.035),
              ),
            ),
          ),
          // Faint Flutter diamonds
          Positioned(
            right: 48,
            top: 160,
            child: Opacity(
              opacity: 0.08,
              child: CustomPaint(
                size: const Size(64, 64),
                painter: FlutterDiamondPainter(color: AppColors.flutterLightBlue),
              ),
            ),
          ),
          Positioned(
            left: 80,
            bottom: 120,
            child: Opacity(
              opacity: 0.06,
              child: CustomPaint(
                size: const Size(48, 48),
                painter: FlutterDiamondPainter(color: AppColors.flutterBlue),
              ),
            ),
          ),
          Opacity(
            opacity: 0.14,
            child: Image.asset(
              AssetPaths.grain,
              repeat: ImageRepeat.repeat,
              fit: BoxFit.none,
              filterQuality: FilterQuality.low,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _HalftonePainter extends CustomPainter {
  _HalftonePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const step = 14.0;
    for (var y = 0.0; y < size.height; y += step) {
      for (var x = 0.0; x < size.width; x += step) {
        canvas.drawCircle(Offset(x, y), 0.65, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HalftonePainter oldDelegate) =>
      oldDelegate.color != color;
}
