import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/cursor_controller.dart';

/// Top-layer custom cursor. [IgnorePointer] so it never steals hits.
class CustomCursorOverlay extends StatelessWidget {
  const CustomCursorOverlay({super.key, required this.controller});

  final CursorController controller;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            controller.rawPosition,
            controller.ringPosition,
            controller.hotspot,
            controller.label,
            controller.pressed,
            controller.visible,
          ]),
          builder: (context, _) {
            if (!controller.enabled || !controller.visible.value) {
              return const SizedBox.shrink();
            }
            final dot = controller.rawPosition.value;
            final ring = controller.ringPosition.value;
            final hot = controller.hotspot.value;
            final label = controller.label.value;
            final pressed = controller.pressed.value;

            final interactive = hot == CursorHotspot.interactive;
            final portrait = hot == CursorHotspot.portrait;
            final ringSize = interactive ? 56.0 : (portrait ? 40.0 : 32.0);
            final dotSize = interactive ? 7.0 : 10.0;

            return Stack(
              children: [
                Positioned(
                  left: ring.dx - ringSize / 2,
                  top: ring.dy - ringSize / 2,
                  child: Transform.scale(
                    scale: pressed ? 1.1 : 1.0,
                    child: portrait
                        ? CustomPaint(
                            size: Size(ringSize, ringSize),
                            painter: const _SparklePainter(),
                          )
                        : Container(
                            width: ringSize,
                            height: ringSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: interactive
                                  ? AppColors.flutterLightBlue
                                      .withValues(alpha: 0.15)
                                  : Colors.transparent,
                              border: Border.all(
                                color: AppColors.flutterLightBlue
                                    .withValues(alpha: 0.85),
                                width: 1.5,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: label == null
                                ? null
                                : Text(
                                    label,
                                    style: GoogleFonts.spaceMono(
                                      fontSize: 8,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.offWhite,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                          ),
                  ),
                ),
                Positioned(
                  left: dot.dx - dotSize / 2,
                  top: dot.dy - dotSize / 2,
                  child: Transform.scale(
                    scale: pressed ? 0.85 : 1.0,
                    child: Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.flutterLightBlue,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  const _SparklePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.flutterLightBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final path = Path()
      ..moveTo(cx, 0)
      ..quadraticBezierTo(cx, cy, size.width, cy)
      ..quadraticBezierTo(cx, cy, cx, size.height)
      ..quadraticBezierTo(cx, cy, 0, cy)
      ..quadraticBezierTo(cx, cy, cx, 0);
    canvas.drawPath(path, paint);
    canvas.drawCircle(
      Offset(cx, cy),
      2.2,
      Paint()..color = AppColors.flutterLightBlue,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Reports hover / press to [cursorController]. Hides native cursor when custom is on.
class CursorTarget extends StatelessWidget {
  const CursorTarget({
    super.key,
    required this.child,
    this.hotspot = CursorHotspot.interactive,
    this.label,
    this.enabled = true,
  });

  final Widget child;
  final CursorHotspot hotspot;
  final String? label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (_) => cursorController.setHotspot(hotspot, label: label),
      onExit: (_) => cursorController.setHotspot(CursorHotspot.none),
      child: Listener(
        onPointerDown: (_) => cursorController.setPressed(true),
        onPointerUp: (_) => cursorController.setPressed(false),
        onPointerCancel: (_) => cursorController.setPressed(false),
        child: child,
      ),
    );
  }
}
