import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/painters/tape_painter.dart';

/// Mono `0N / TITLE` + condensed headline + short intro + tape strip.
class SectionHeader extends StatefulWidget {
  const SectionHeader({
    super.key,
    required this.number,
    required this.eyebrow,
    required this.title,
    required this.intro,
    this.reduceMotion = false,
    this.scrollOffset,
  });

  final String number;
  final String eyebrow;
  final String title;
  final String intro;
  final bool reduceMotion;
  final ValueNotifier<double>? scrollOffset;

  @override
  State<SectionHeader> createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<SectionHeader> {
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    widget.scrollOffset?.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    widget.scrollOffset?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_revealed || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final dy = box.localToGlobal(Offset.zero).dy;
    final h = MediaQuery.sizeOf(context).height;
    if (dy < h * 0.88) {
      setState(() => _revealed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final zine = context.zine;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TapeStrip(color: zine.tape, width: 56, height: 14, angle: -0.08),
            const SizedBox(width: 12),
            Text(
              '${widget.number} / ${widget.eyebrow}',
              style: GoogleFonts.spaceMono(
                fontSize: 11,
                letterSpacing: 2.2,
                fontWeight: FontWeight.w700,
                color: AppColors.flutterLightBlue,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          widget.title,
          style: (isAr
                  ? GoogleFonts.reemKufi(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: zine.ink,
                    )
                  : GoogleFonts.bebasNeue(
                      fontSize: 48,
                      letterSpacing: 1.5,
                      color: zine.ink,
                    ))
              .copyWith(decoration: TextDecoration.none),
        ),
        if (widget.intro.trim().isNotEmpty) ...[
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(
              widget.intro,
              style: (isAr
                      ? GoogleFonts.cairo(
                          fontSize: 15,
                          height: 1.45,
                          color: zine.inkMuted,
                        )
                      : GoogleFonts.kalam(
                          fontSize: 16,
                          height: 1.4,
                          color: zine.inkMuted,
                        ))
                  .copyWith(decoration: TextDecoration.none),
            ),
          ),
        ],
      ],
    );

    if (widget.reduceMotion || _revealed == false && widget.scrollOffset == null) {
      // First paint without scroll notifier: show immediately.
      if (widget.scrollOffset == null) return content;
    }

    if (widget.reduceMotion) return content;

    return content
        .animate(target: _revealed ? 1 : 0)
        .fadeIn(duration: 450.ms, curve: Curves.easeOutCubic)
        .slideY(begin: 0.12, end: 0, duration: 500.ms, curve: Curves.easeOutCubic);
  }
}
