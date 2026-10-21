import 'package:flutter/material.dart';

/// Shared breakpoints and tilt helpers for case-study mobile layout.
abstract final class CaseLayout {
  static const double stackBreakpoint = 600;
  static const double progressRailBreakpoint = 900;
  static const double mobileBreakpoint = 700;

  /// ~1° in radians.
  static const double narrowTilt = 0.0175;

  static bool isNarrow(double width) => width < stackBreakpoint;

  static bool showProgressRail(double width) =>
      width >= progressRailBreakpoint;

  static double tilt(double desired, {required double width}) {
    if (width >= stackBreakpoint) return desired;
    if (desired == 0) return 0;
    final sign = desired.isNegative ? -1.0 : 1.0;
    final mag = desired.abs().clamp(0.0, narrowTilt);
    return sign * mag;
  }

  static EdgeInsets pagePadding(double width) {
    final h = width < stackBreakpoint
        ? 16.0
        : width < mobileBreakpoint
            ? 20.0
            : 24.0;
    final end = showProgressRail(width) ? 88.0 : h;
    return EdgeInsets.fromLTRB(h, width < stackBreakpoint ? 20 : 28, end, 48);
  }

  static EdgeInsets sectionGap(double width) => EdgeInsets.only(
        bottom: width < stackBreakpoint ? 36 : 56,
      );
}

/// Horizontal snap gallery with edge padding for story / screen strips.
class CaseSnapGallery extends StatelessWidget {
  const CaseSnapGallery({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.height = 320,
    this.viewportFraction = 0.72,
    this.padEnds = true,
  });

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final double height;
  final double viewportFraction;
  final bool padEnds;

  @override
  Widget build(BuildContext context) {
    if (itemCount <= 0) return const SizedBox.shrink();

    return SizedBox(
      height: height,
      child: PageView.builder(
        controller: PageController(viewportFraction: viewportFraction),
        padEnds: padEnds,
        physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final child = itemBuilder(context, index);
          if (child == null) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: child,
          );
        },
      ),
    );
  }
}
