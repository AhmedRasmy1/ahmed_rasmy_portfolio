import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/safe_asset_image.dart';

/// Project image with graceful missing-asset handling (hide in release;
/// optional blueprint in debug).
class ProjectImageSlot extends StatelessWidget {
  const ProjectImageSlot({
    super.key,
    required this.assetPath,
    required this.label,
    this.aspectRatio = 16 / 10,
    this.phoneFrame = false,
  });

  final String assetPath;
  final String label;
  final double aspectRatio;
  final bool phoneFrame;

  @override
  Widget build(BuildContext context) {
    final placeholder = kDebugMode
        ? _BlueprintPlaceholder(label: label)
        : null;

    return OptionalAssetFrame(
      assetPath: assetPath,
      debugPlaceholder: placeholder,
      builder: (context, image) {
        if (!phoneFrame) {
          return AspectRatio(
            aspectRatio: aspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: image,
            ),
          );
        }

        return AspectRatio(
          aspectRatio: 9 / 16,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.navyInk,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: AppColors.navy.withValues(alpha: 0.8),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.flutterLightBlue.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: image,
            ),
          ),
        );
      },
    );
  }
}

class _BlueprintPlaceholder extends StatelessWidget {
  const _BlueprintPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _BlueprintPainter(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            softWrap: true,
            style: GoogleFonts.spaceMono(
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
              color: AppColors.flutterLightBlue.withValues(alpha: 0.85),
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _BlueprintPainter extends CustomPainter {
  const _BlueprintPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0A1628);
    canvas.drawRect(Offset.zero & size, bg);

    final grid = Paint()
      ..color = AppColors.flutterLightBlue.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    const step = 16.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final accent = Paint()
      ..color = AppColors.flutterLightBlue.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRect(
      Rect.fromLTWH(12, 12, size.width - 24, size.height - 24),
      accent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
