import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/painters/tape_painter.dart';

/// Shared scrapbook paper card — tape, tilt, hover lift.
class PaperCard extends StatefulWidget {
  const PaperCard({
    super.key,
    required this.child,
    this.tilt = 0,
    this.maxTilt,
    this.tapeColor,
    this.padding = const EdgeInsets.fromLTRB(16, 28, 16, 18),
    this.onTap,
    this.enableHover = true,
  });

  final Widget child;
  final double tilt;

  /// When set, clamps [|tilt|] to this value (e.g. ~0.017 ≈ 1° on narrow).
  final double? maxTilt;
  final Color? tapeColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool enableHover;

  @override
  State<PaperCard> createState() => _PaperCardState();
}

class _PaperCardState extends State<PaperCard> {
  bool _hover = false;

  double get _effectiveTilt {
    final t = widget.tilt;
    final max = widget.maxTilt;
    if (max == null) return t;
    if (t == 0) return 0;
    final sign = t.isNegative ? -1.0 : 1.0;
    return sign * t.abs().clamp(0.0, max);
  }

  @override
  Widget build(BuildContext context) {
    final zine = context.zine;
    final tape = widget.tapeColor ?? zine.tape;
    final angle = (_hover && widget.enableHover) ? 0.0 : _effectiveTilt;

    Widget card = MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: widget.enableHover ? (_) => setState(() => _hover = true) : null,
      onExit: widget.enableHover ? (_) => setState(() => _hover = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        transformAlignment: Alignment.center,
        transform: Matrix4.rotationZ(angle)
          ..setTranslationRaw(0, _hover ? -8.0 : 0, 0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: widget.padding,
              decoration: BoxDecoration(
                color: zine.paper,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.navyInk
                        .withValues(alpha: _hover ? 0.28 : 0.16),
                    blurRadius: _hover ? 18 : 12,
                    offset: Offset(0, _hover ? 12 : 6),
                  ),
                ],
              ),
              child: widget.child,
            ),
            Positioned(
              top: -10,
              left: 0,
              right: 0,
              child: Center(
                child: TapeStrip(color: tape, width: 88, height: 20),
              ),
            ),
          ],
        ),
      ),
    );

    if (widget.onTap != null) {
      card = GestureDetector(onTap: widget.onTap, child: card);
    }
    return RepaintBoundary(child: card);
  }
}
