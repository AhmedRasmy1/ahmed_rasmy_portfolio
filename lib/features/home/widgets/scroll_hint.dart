import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';

class ScrollHint extends StatefulWidget {
  const ScrollHint({
    super.key,
    required this.scrollOffset,
    required this.onTap,
    this.mobile = false,
    this.customCursor = false,
  });

  final ValueNotifier<double> scrollOffset;
  final VoidCallback onTap;
  final bool mobile;
  final bool customCursor;

  @override
  State<ScrollHint> createState() => _ScrollHintState();
}

class _ScrollHintState extends State<ScrollHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loop;

  @override
  void initState() {
    super.initState();
    _loop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final label = widget.mobile ? l10n.scrollHintMobile : l10n.scrollHint;

    return ValueListenableBuilder<double>(
      valueListenable: widget.scrollOffset,
      child: CursorTarget(
        enabled: widget.customCursor,
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.spaceMono(
                  fontSize: 10,
                  letterSpacing: 2.4,
                  fontWeight: FontWeight.w700,
                  color: zine.ink.withValues(alpha: 0.7),
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: _loop,
                builder: (context, _) {
                  final t = Curves.easeInOut.transform(_loop.value);
                  return SizedBox(
                    width: 18,
                    height: 28,
                    child: CustomPaint(
                      painter: _MouseIconPainter(
                        progress: t,
                        color: zine.ink.withValues(alpha: 0.7),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      builder: (context, offset, child) {
        final visible = offset < 80;
        return AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: const Duration(milliseconds: 280),
          child: IgnorePointer(ignoring: !visible, child: child),
        );
      },
    );
  }
}

class _MouseIconPainter extends CustomPainter {
  _MouseIconPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
      const Radius.circular(8),
    );
    canvas.drawRRect(r, stroke);

    final dy = 6 + progress * 10;
    final opacity = (1 - progress * 0.7).clamp(0.2, 1.0);
    canvas.drawCircle(
      Offset(size.width / 2, dy),
      2.2,
      Paint()..color = color.withValues(alpha: opacity),
    );
  }

  @override
  bool shouldRepaint(covariant _MouseIconPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
