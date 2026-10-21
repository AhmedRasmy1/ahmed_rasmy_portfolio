import 'package:flutter/material.dart';

/// Fades/slides in when the widget enters the viewport (scroll-driven).
class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    required this.child,
    this.scrollOffset,
    this.reduceMotion = false,
    this.delayFraction = 0,
  });

  final Widget child;
  final ValueNotifier<double>? scrollOffset;
  final bool reduceMotion;
  final double delayFraction;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.scrollOffset?.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void didUpdateWidget(covariant ScrollReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollOffset != widget.scrollOffset) {
      oldWidget.scrollOffset?.removeListener(_check);
      widget.scrollOffset?.addListener(_check);
    }
  }

  @override
  void dispose() {
    widget.scrollOffset?.removeListener(_check);
    super.dispose();
  }

  void _check() {
    if (!mounted || _visible) return;
    if (widget.reduceMotion) {
      setState(() => _visible = true);
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final dy = box.localToGlobal(Offset.zero).dy;
    final h = MediaQuery.sizeOf(context).height;
    final threshold = h * (0.88 - widget.delayFraction * 0.08);
    if (dy < threshold) setState(() => _visible = true);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reduceMotion) return widget.child;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      opacity: _visible ? 1 : 0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 480),
        curve: Curves.easeOutCubic,
        offset: _visible ? Offset.zero : const Offset(0, 0.12),
        child: widget.child,
      ),
    );
  }
}
