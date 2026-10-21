import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/utils/asset_checker.dart';

/// Renders [Image.asset] only when the path exists in the asset manifest.
/// Missing optional assets → [SizedBox.shrink] (debug blueprint optional).
class SafeAssetImage extends StatelessWidget {
  const SafeAssetImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.filterQuality = FilterQuality.high,
    this.cacheWidth,
    this.cacheHeight,
    this.width,
    this.height,
    this.repeat = ImageRepeat.noRepeat,
    this.debugLabel,
    this.showDebugPlaceholder = true,
    this.fallback,
  });

  final String assetPath;
  final BoxFit fit;
  final FilterQuality filterQuality;
  final int? cacheWidth;
  final int? cacheHeight;
  final double? width;
  final double? height;
  final ImageRepeat repeat;
  final String? debugLabel;
  final bool showDebugPlaceholder;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    if (!AssetChecker.has(assetPath)) {
      if (fallback != null) return fallback!;
      if (kDebugMode && showDebugPlaceholder) {
        return _DebugBlueprint(label: debugLabel ?? assetPath);
      }
      return const SizedBox.shrink();
    }

    return Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      repeat: repeat,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      errorBuilder: (_, _, _) {
        // Manifest said it exists but load failed — still don't spam retries.
        if (kDebugMode && showDebugPlaceholder) {
          return _DebugBlueprint(label: debugLabel ?? assetPath);
        }
        return fallback ?? const SizedBox.shrink();
      },
    );
  }
}

/// Builds a framed image only when the asset exists (no fetch otherwise).
class OptionalAssetFrame extends StatelessWidget {
  const OptionalAssetFrame({
    super.key,
    required this.assetPath,
    required this.builder,
    this.debugPlaceholder,
    this.cacheWidth,
    this.fit = BoxFit.cover,
    this.filterQuality = FilterQuality.high,
  });

  final String assetPath;
  final Widget Function(BuildContext context, Widget image) builder;
  final Widget? debugPlaceholder;
  final int? cacheWidth;
  final BoxFit fit;
  final FilterQuality filterQuality;

  @override
  Widget build(BuildContext context) {
    if (!AssetChecker.has(assetPath)) {
      if (kDebugMode && debugPlaceholder != null) {
        return builder(context, debugPlaceholder!);
      }
      return const SizedBox.shrink();
    }

    final image = Image.asset(
      assetPath,
      fit: fit,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      errorBuilder: (_, _, _) {
        if (kDebugMode && debugPlaceholder != null) return debugPlaceholder!;
        return const SizedBox.shrink();
      },
    );

    return builder(context, image);
  }
}

class _DebugBlueprint extends StatelessWidget {
  const _DebugBlueprint({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.navy,
      child: CustomPaint(
        painter: const _GridPainter(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
                color: AppColors.flutterLightBlue.withValues(alpha: 0.85),
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = AppColors.flutterLightBlue.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    const step = 14.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
