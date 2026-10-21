import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/utils/asset_checker.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/safe_asset_image.dart';

/// Featured project hero: phone-framed screenshot or transparent mockup + glow/float.
class FeaturedHeroVisual extends StatefulWidget {
  const FeaturedHeroVisual({
    super.key,
    required this.assetPath,
    required this.isMockup,
    this.reduceMotion = false,
    this.maxWidth = 180,
  });

  final String assetPath;
  final bool isMockup;
  final bool reduceMotion;
  final double maxWidth;

  @override
  State<FeaturedHeroVisual> createState() => _FeaturedHeroVisualState();
}

class _FeaturedHeroVisualState extends State<FeaturedHeroVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );
    if (!widget.reduceMotion) {
      _float.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant FeaturedHeroVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reduceMotion != oldWidget.reduceMotion) {
      if (widget.reduceMotion) {
        _float.stop();
        _float.value = 0;
      } else {
        _float.repeat();
      }
    }
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AssetChecker.has(widget.assetPath)) return const SizedBox.shrink();

    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cacheW = (widget.maxWidth * dpr * 2).round().clamp(360, 1200);

    final image = SafeAssetImage(
      assetPath: widget.assetPath,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      cacheWidth: cacheW,
      showDebugPlaceholder: false,
    );

    Widget visual = widget.isMockup
        ? AspectRatio(aspectRatio: 9 / 16, child: image)
        : _PhoneFrame(child: image);

    visual = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.maxWidth),
      child: visual,
    );

    visual = DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.flutterLightBlue.withValues(alpha: 0.35),
            blurRadius: 28,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: visual,
    );

    if (widget.reduceMotion) {
      return RepaintBoundary(child: visual);
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _float,
        builder: (context, child) {
          final dy = 4 * math.sin(_float.value * math.pi * 2);
          return Transform.translate(offset: Offset(0, dy), child: child);
        },
        child: visual,
      ),
    );
  }
}

class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 19,
      child: CustomPaint(
        painter: const _PhoneBezelPainter(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 14, 8, 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              fit: StackFit.expand,
              children: [
                child,
                const Positioned(
                  top: 6,
                  left: 0,
                  right: 0,
                  child: Center(child: _DynamicIsland()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DynamicIsland extends StatelessWidget {
  const _DynamicIsland();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 14,
      decoration: BoxDecoration(
        color: AppColors.navyInk,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _PhoneBezelPainter extends CustomPainter {
  const _PhoneBezelPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final r = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(28),
    );
    canvas.drawRRect(r, Paint()..color = AppColors.navyInk);
    canvas.drawRRect(
      r.deflate(1),
      Paint()
        ..color = AppColors.navy.withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
