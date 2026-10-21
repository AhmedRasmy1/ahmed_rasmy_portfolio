import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/animation/idle_ticker.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/asset_paths.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/cursor_controller.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/utils/asset_checker.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/safe_asset_image.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/comic_burst.dart';

class PortraitSticker extends StatefulWidget {
  const PortraitSticker({
    super.key,
    required this.height,
    this.enableParallax = true,
    this.reduceMotion = false,
    this.idle,
    this.mobile = false,
    this.customCursor = false,
  });

  final double height;
  final bool enableParallax;
  final bool reduceMotion;
  final IdleTicker? idle;
  final bool mobile;
  final bool customCursor;

  @override
  State<PortraitSticker> createState() => _PortraitStickerState();
}

class _PortraitStickerState extends State<PortraitSticker> {
  final ValueNotifier<Offset> _tilt = ValueNotifier(Offset.zero);
  Offset _target = Offset.zero;

  @override
  void dispose() {
    _tilt.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent event, Size size) {
    final nx =
        ((event.localPosition.dx / size.width) * 2 - 1).clamp(-1.0, 1.0);
    final ny =
        ((event.localPosition.dy / size.height) * 2 - 1).clamp(-1.0, 1.0);
    _target = Offset(nx, ny);
    final cur = _tilt.value;
    _tilt.value = Offset(
      cur.dx + (_target.dx - cur.dx) * 0.18,
      cur.dy + (_target.dy - cur.dy) * 0.18,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cacheW = (widget.height * 0.9 * dpr * 2).round().clamp(1000, 2800);

    Widget sticker = ValueListenableBuilder<Offset>(
      valueListenable: _tilt,
      child: RepaintBoundary(
        child: SizedBox(
          height: widget.height,
          width: widget.height * 0.9,
          child: _StickerCutout(
            asset: AssetPaths.portrait,
            fallback: 'assets/images/ahmed_rasmy_image.jpg',
            cacheWidth: cacheW,
            outlineWidth: 6,
            grayscale: true,
          ),
        ),
      ),
      builder: (context, tilt, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(-tilt.dy * 0.2)
            ..rotateY(tilt.dx * 0.2),
          child: child,
        );
      },
    );

    if (!widget.reduceMotion) {
      sticker = sticker
          .animate()
          .fadeIn(delay: 450.ms, duration: 550.ms)
          .scale(
            begin: const Offset(0.88, 0.88),
            curve: Curves.easeOutBack,
            duration: 650.ms,
          );
    }

    final burstSize = widget.height * 1.4;
    final withBurst = Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        ComicBurst(
          size: burstSize,
          reduceMotion: widget.reduceMotion,
          mobile: widget.mobile,
        ),
        sticker,
        Positioned(
          right: -4,
          bottom: 32,
          child: Transform.rotate(
            angle: 0.14,
            child: _DashPeek(
              reduceMotion: widget.reduceMotion,
              idle: widget.idle,
            ),
          ),
        ),
      ],
    );

    Widget result = withBurst;
    if (widget.enableParallax && !widget.reduceMotion) {
      result = MouseRegion(
        cursor: widget.customCursor
            ? SystemMouseCursors.none
            : SystemMouseCursors.basic,
        onHover: (e) {
          final box = context.findRenderObject() as RenderBox?;
          if (box == null) return;
          _onHover(e, box.size);
        },
        onExit: (_) {
          _target = Offset.zero;
          _tilt.value = Offset.zero;
        },
        child: withBurst,
      );
    }

    return CursorTarget(
      enabled: widget.customCursor,
      hotspot: CursorHotspot.portrait,
      child: result,
    );
  }
}

/// Die-cut sticker: no rectangular frame — outline via offset white silhouettes.
class _StickerCutout extends StatelessWidget {
  const _StickerCutout({
    required this.asset,
    required this.fallback,
    required this.cacheWidth,
    required this.outlineWidth,
    this.grayscale = false,
  });

  final String asset;
  final String fallback;
  final int cacheWidth;
  final double outlineWidth;
  final bool grayscale;

  Widget _raw() {
    if (AssetChecker.has(asset)) {
      return SafeAssetImage(
        assetPath: asset,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        cacheWidth: cacheWidth,
        showDebugPlaceholder: false,
        fallback: AssetChecker.has(fallback)
            ? SafeAssetImage(
                assetPath: fallback,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                cacheWidth: cacheWidth,
                showDebugPlaceholder: false,
              )
            : const SizedBox.shrink(),
      );
    }
    if (AssetChecker.has(fallback)) {
      return SafeAssetImage(
        assetPath: fallback,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        cacheWidth: cacheWidth,
        showDebugPlaceholder: false,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final o = outlineWidth;
    final offsets = <Offset>[
      Offset(-o, 0),
      Offset(o, 0),
      Offset(0, -o),
      Offset(0, o),
      Offset(-o * 0.75, -o * 0.75),
      Offset(o * 0.75, -o * 0.75),
      Offset(-o * 0.75, o * 0.75),
      Offset(o * 0.75, o * 0.75),
    ];

    final face = grayscale
        ? ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0, 0, 0, 1, 0,
            ]),
            child: _raw(),
          )
        : _raw();

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Soft blue glow (scaled silhouette tint — no BackdropFilter).
        Opacity(
          opacity: 0.32,
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(
              AppColors.flutterLightBlue,
              BlendMode.srcIn,
            ),
            child: Transform.scale(scale: 1.05, child: _raw()),
          ),
        ),
        for (final off in offsets)
          Transform.translate(
            offset: off,
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              child: _raw(),
            ),
          ),
        face,
      ],
    );
  }
}

class _DashPeek extends StatelessWidget {
  const _DashPeek({required this.reduceMotion, this.idle});

  final bool reduceMotion;
  final IdleTicker? idle;

  @override
  Widget build(BuildContext context) {
    const size = 92.0;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cacheW = (size * dpr * 2).round().clamp(160, 512);

    Widget dash = SizedBox(
      width: size,
      height: size,
      child: _StickerCutout(
        asset: AssetPaths.dash,
        fallback: AssetPaths.dash,
        cacheWidth: cacheW,
        outlineWidth: 3.5,
      ),
    );

    if (!reduceMotion) {
      dash = dash
          .animate()
          .fadeIn(delay: 900.ms)
          .scale(
            begin: const Offset(0.5, 0.5),
            curve: Curves.easeOutBack,
            duration: 500.ms,
          );
    }

    if (idle == null || reduceMotion) return RepaintBoundary(child: dash);

    return RepaintBoundary(
      child: IdleFloat(
        ticker: idle!,
        amplitude: 3,
        rotationAmp: 0.04,
        period: const Duration(milliseconds: 2800),
        phase: 0.3,
        child: dash,
      ),
    );
  }
}

class TwinklingStar extends StatelessWidget {
  const TwinklingStar({
    super.key,
    this.size = 18,
    this.idle,
    this.reduceMotion = false,
    this.phase = 0,
  });

  final double size;
  final IdleTicker? idle;
  final bool reduceMotion;
  final double phase;

  @override
  Widget build(BuildContext context) {
    final star = SizedBox(
      width: size,
      height: size,
      child: const CustomPaint(painter: _StarPainter()),
    );

    if (idle == null || reduceMotion) return RepaintBoundary(child: star);

    return RepaintBoundary(
      child: ListenableBuilder(
        listenable: idle!,
        child: star,
        builder: (context, child) {
          final w = idle!.wave(const Duration(milliseconds: 2200));
          final c = idle!.cycle(const Duration(milliseconds: 2400));
          return Opacity(
            opacity: 0.55 + 0.45 * ((w + 1) / 2),
            child: Transform.rotate(
              angle: (c + phase) * 0.4,
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  const _StarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.flutterLightBlue;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final path = Path()
      ..moveTo(cx, 0)
      ..quadraticBezierTo(cx, cy, size.width, cy)
      ..quadraticBezierTo(cx, cy, cx, size.height)
      ..quadraticBezierTo(cx, cy, 0, cy)
      ..quadraticBezierTo(cx, cy, cx, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
