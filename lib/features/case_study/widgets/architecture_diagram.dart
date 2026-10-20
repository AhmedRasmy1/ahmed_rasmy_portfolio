import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';

/// Clean Architecture layers — draws in as [progress] goes 0→1.
class ArchitectureDiagram extends StatelessWidget {
  const ArchitectureDiagram({
    super.key,
    required this.progress,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AspectRatio(
      aspectRatio: 1.35,
      child: CustomPaint(
        painter: _ArchPainter(progress: progress.clamp(0.0, 1.0)),
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final h = c.maxHeight;
            Widget label(String t, {double size = 11}) => Text(
                  t,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceMono(
                    fontSize: size,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
                    color: AppColors.offWhite,
                    decoration: TextDecoration.none,
                  ),
                );

            return Stack(
              children: [
                if (progress > 0.15)
                  Positioned(
                    left: w * 0.12,
                    right: w * 0.12,
                    top: h * 0.08,
                    height: h * 0.18,
                    child: Center(
                      child: label(l10n.caseArchPresentation, size: 12),
                    ),
                  ),
                if (progress > 0.35)
                  Positioned(
                    left: w * 0.18,
                    right: w * 0.18,
                    top: h * 0.36,
                    height: h * 0.16,
                    child: Center(child: label(l10n.caseArchDomain)),
                  ),
                if (progress > 0.55)
                  Positioned(
                    left: w * 0.12,
                    right: w * 0.12,
                    top: h * 0.62,
                    height: h * 0.28,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        label(l10n.caseArchData, size: 12),
                        const SizedBox(height: 8),
                        Opacity(
                          opacity: ((progress - 0.55) / 0.35).clamp(0.0, 1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              label(l10n.caseArchRemote, size: 9),
                              label(l10n.caseArchRepo, size: 9),
                              label(l10n.caseArchLocal, size: 9),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (progress > 0.7)
                  Positioned(
                    right: w * 0.02,
                    top: h * 0.12,
                    child: Opacity(
                      opacity: ((progress - 0.7) / 0.3).clamp(0.0, 1.0),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          l10n.caseArchProvider,
                          style: GoogleFonts.spaceMono(
                            fontSize: 9,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w700,
                            color: AppColors.flutterLightBlue,
                            decoration: TextDecoration.none,
                          ),
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

class _ArchPainter extends CustomPainter {
  _ArchPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = AppColors.flutterLightBlue.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final fill = Paint()
      ..color = AppColors.navy.withValues(alpha: 0.55);

    RRect box(double l, double t, double r, double b) =>
        RRect.fromRectAndRadius(
          Rect.fromLTRB(l, t, r, b),
          const Radius.circular(6),
        );

    void drawLayer(RRect r, double appearAt) {
      final local = ((progress - appearAt) / 0.2).clamp(0.0, 1.0);
      if (local <= 0) return;
      final path = Path()..addRRect(r);
      final metrics = path.computeMetrics().first;
      final extract = metrics.extractPath(0, metrics.length * local);
      canvas.drawRRect(r, fill..color = fill.color.withValues(alpha: 0.35 * local));
      canvas.drawPath(extract, stroke);
    }

    final pres = box(size.width * 0.1, size.height * 0.06, size.width * 0.9,
        size.height * 0.28);
    final domain = box(size.width * 0.16, size.height * 0.34, size.width * 0.84,
        size.height * 0.54);
    final data = box(size.width * 0.1, size.height * 0.6, size.width * 0.9,
        size.height * 0.92);

    drawLayer(pres, 0.05);
    drawLayer(domain, 0.25);
    drawLayer(data, 0.45);

    // Arrows between layers
    final arrow = Paint()
      ..color = AppColors.flutterLightBlue.withValues(alpha: 0.7)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    void downArrow(double y0, double y1, double at) {
      final local = ((progress - at) / 0.15).clamp(0.0, 1.0);
      if (local <= 0) return;
      final midX = size.width / 2;
      final y = y0 + (y1 - y0) * local;
      canvas.drawLine(Offset(midX, y0), Offset(midX, y), arrow);
      if (local > 0.85) {
        canvas.drawLine(Offset(midX, y1), Offset(midX - 6, y1 - 8), arrow);
        canvas.drawLine(Offset(midX, y1), Offset(midX + 6, y1 - 8), arrow);
      }
    }

    downArrow(size.height * 0.28, size.height * 0.34, 0.22);
    downArrow(size.height * 0.54, size.height * 0.6, 0.42);

    // Inner data split lines
    if (progress > 0.6) {
      final a = ((progress - 0.6) / 0.25).clamp(0.0, 1.0);
      final x1 = size.width * 0.37;
      final x2 = size.width * 0.63;
      final top = size.height * 0.72;
      final bot = size.height * 0.88;
      canvas.drawLine(
        Offset(x1, top),
        Offset(x1, top + (bot - top) * a),
        arrow,
      );
      canvas.drawLine(
        Offset(x2, top),
        Offset(x2, top + (bot - top) * a),
        arrow,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ArchPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
