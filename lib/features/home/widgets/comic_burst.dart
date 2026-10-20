import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:ahmed_rasmy_portfolio/core/painters/comic_burst_painter.dart';

/// Radial manga burst behind the portrait. Slow spin after intro pop.
class ComicBurst extends StatefulWidget {
  const ComicBurst({
    super.key,
    required this.size,
    this.reduceMotion = false,
    this.mobile = false,
  });

  final double size;
  final bool reduceMotion;
  final bool mobile;

  @override
  State<ComicBurst> createState() => _ComicBurstState();
}

class _ComicBurstState extends State<ComicBurst>
    with SingleTickerProviderStateMixin {
  AnimationController? _spin;

  @override
  void initState() {
    super.initState();
    if (!widget.reduceMotion && !widget.mobile) {
      _spin = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 60),
      )..repeat();
    }
  }

  @override
  void didUpdateWidget(covariant ComicBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reduceMotion || widget.mobile) {
      _spin?.stop();
    } else if (_spin != null && !_spin!.isAnimating) {
      _spin!.repeat();
    }
  }

  @override
  void dispose() {
    _spin?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final rays = widget.mobile ? 24 : 48;

    Widget burst = RepaintBoundary(
      child: CustomPaint(
        size: Size.square(widget.size),
        painter: ComicBurstPainter(lightMode: light, rayCount: rays),
      ),
    );

    if (!widget.reduceMotion) {
      burst = burst
          .animate()
          .fadeIn(duration: 450.ms, delay: 200.ms)
          .scale(
            begin: const Offset(0.6, 0.6),
            end: const Offset(1, 1),
            duration: 700.ms,
            delay: 200.ms,
            curve: Curves.easeOutBack,
          );
    }

    if (_spin == null) return burst;

    return AnimatedBuilder(
      animation: _spin!,
      child: burst,
      builder: (context, child) {
        return Transform.rotate(
          angle: _spin!.value * 6.283185307179586,
          child: child,
        );
      },
    );
  }
}
