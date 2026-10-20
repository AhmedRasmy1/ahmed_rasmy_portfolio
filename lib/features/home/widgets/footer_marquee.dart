import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';

class FooterMarquee extends StatefulWidget {
  const FooterMarquee({super.key, this.reduceMotion = false});

  final bool reduceMotion;

  @override
  State<FooterMarquee> createState() => _FooterMarqueeState();
}

class _FooterMarqueeState extends State<FooterMarquee>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    if (!widget.reduceMotion) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant FooterMarquee oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reduceMotion) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final narrow = MediaQuery.sizeOf(context).width < 800;
    final style = GoogleFonts.spaceMono(
      fontSize: 11,
      letterSpacing: 1.8,
      fontWeight: FontWeight.w700,
      color: zine.ink.withValues(alpha: 0.85),
      decoration: TextDecoration.none,
    );
    final text = '◆  ${l10n.footerMarquee}  ◆  ';

    return Column(
      children: [
        Divider(color: zine.divider, thickness: 1),
        const SizedBox(height: 12),
        if (!narrow || widget.reduceMotion)
          Text(l10n.footerMarquee, textAlign: TextAlign.center, style: style)
        else
          SizedBox(
            height: 28,
            child: ClipRect(
              child: AnimatedBuilder(
                animation: _controller,
                child: Text(text + text, style: style),
                builder: (context, child) {
                  return OverflowBox(
                    maxWidth: double.infinity,
                    alignment: AlignmentDirectional.centerStart,
                    child: Transform.translate(
                      offset: Offset(-_controller.value * 640, 0),
                      child: child,
                    ),
                  );
                },
              ),
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}
