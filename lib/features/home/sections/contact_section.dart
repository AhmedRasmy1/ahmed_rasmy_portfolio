import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_typography.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/navigation/home_sections.dart';
import 'package:ahmed_rasmy_portfolio/core/painters/tape_painter.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/paper_card.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({
    super.key,
    this.scrollOffset,
    this.reduceMotion = false,
    this.customCursor = false,
  });

  final ValueNotifier<double>? scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final narrow = width < 800;

    return KeyedSubtree(
      key: HomeSectionKeys.key(HomeSection.contact),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 72),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              number: HomeSection.contact.numberLabel,
              eyebrow: l10n.secContactEyebrow,
              title: l10n.secContactTitle,
              intro: l10n.secContactIntro,
              scrollOffset: scrollOffset,
              reduceMotion: reduceMotion,
            ),
            const SizedBox(height: 36),
            _ContactLayout(
              narrow: narrow,
              customCursor: customCursor,
              reduceMotion: reduceMotion,
              scrollOffset: scrollOffset,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactLayout extends StatefulWidget {
  const _ContactLayout({
    required this.narrow,
    required this.customCursor,
    required this.reduceMotion,
    this.scrollOffset,
  });

  final bool narrow;
  final bool customCursor;
  final bool reduceMotion;
  final ValueNotifier<double>? scrollOffset;

  @override
  State<_ContactLayout> createState() => _ContactLayoutState();
}

class _ContactLayoutState extends State<_ContactLayout> {
  final _stackKey = GlobalKey();
  final _stickyKey = GlobalKey();
  final _emailKey = GlobalKey();
  double _drawProgress = 0;
  Offset? _start;
  Offset? _end;

  @override
  void initState() {
    super.initState();
    widget.scrollOffset?.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measure();
      _onScroll();
    });
  }

  @override
  void dispose() {
    widget.scrollOffset?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    if (widget.reduceMotion) {
      if (_drawProgress != 1) setState(() => _drawProgress = 1);
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final viewH = MediaQuery.sizeOf(context).height;
    final p = ((viewH * 0.9 - top) / (viewH * 0.45)).clamp(0.0, 1.0);
    if ((p - _drawProgress).abs() > 0.02) {
      setState(() => _drawProgress = p);
    }
  }

  void _measure() {
    final stack =
        _stackKey.currentContext?.findRenderObject() as RenderBox?;
    final sticky =
        _stickyKey.currentContext?.findRenderObject() as RenderBox?;
    final email = _emailKey.currentContext?.findRenderObject() as RenderBox?;
    if (stack == null || sticky == null || email == null) return;
    if (!stack.hasSize || !sticky.hasSize || !email.hasSize) return;

    final stickyCenter = sticky.localToGlobal(
      Offset(sticky.size.width, sticky.size.height * 0.55),
    );
    final emailCenter = email.localToGlobal(
      Offset(0, email.size.height * 0.45),
    );
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final startGlobal = rtl
        ? sticky.localToGlobal(Offset(0, sticky.size.height * 0.55))
        : stickyCenter;
    final endGlobal = rtl
        ? email.localToGlobal(
            Offset(email.size.width, email.size.height * 0.45),
          )
        : emailCenter;

    final start = stack.globalToLocal(startGlobal);
    var end = stack.globalToLocal(endGlobal);
    final delta = end - start;
    final dist = delta.distance;
    if (dist > 1) {
      end = end - (delta / dist) * 10; // gap before button
    }

    if (_start != start || _end != end) {
      setState(() {
        _start = start;
        _end = end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _measure();
    });

    final sticky = KeyedSubtree(
      key: _stickyKey,
      child: _SayHiSticky(customCursor: widget.customCursor),
    );
    final postcard = _Postcard(
      emailKey: _emailKey,
      customCursor: widget.customCursor,
    );

    final content = widget.narrow
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sticky,
              const SizedBox(height: 28),
              postcard,
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: sticky),
              const SizedBox(width: 28),
              Expanded(flex: 5, child: postcard),
            ],
          );

    return Stack(
      key: _stackKey,
      clipBehavior: Clip.none,
      children: [
        content,
        if (_start != null && _end != null)
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _ContactArrowPainter(
                    start: _start!,
                    end: _end!,
                    progress: _drawProgress,
                    narrow: widget.narrow,
                    rtl: Directionality.of(context) == TextDirection.rtl,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SayHiSticky extends StatelessWidget {
  const _SayHiSticky({required this.customCursor});

  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CursorTarget(
      enabled: customCursor,
      child: Transform.rotate(
        angle: -0.08,
        child: Container(
          width: 120,
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 14),
          decoration: BoxDecoration(
            color: AppColors.stickyYellow,
            boxShadow: [
              BoxShadow(
                color: AppColors.navyInk.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(2, 6),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -22,
                left: 28,
                child: TapeStrip(
                  color: AppColors.flutterBlue.withValues(alpha: 0.55),
                  width: 48,
                  height: 14,
                ),
              ),
              Text(
                l10n.contactSayHi,
                textAlign: TextAlign.center,
                style: AppTypography.note(
                  context,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navyInk,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactArrowPainter extends CustomPainter {
  _ContactArrowPainter({
    required this.start,
    required this.end,
    required this.progress,
    required this.narrow,
    required this.rtl,
  });

  final Offset start;
  final Offset end;
  final double progress;
  final bool narrow;
  final bool rtl;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final dist = (end - start).distance;
    if (dist < 28) return;
    if (narrow && dist < 36) return;

    final mid = Offset(
      (start.dx + end.dx) / 2 + (narrow ? (rtl ? 16 : -16) : (rtl ? 28 : -28)),
      (start.dy + end.dy) / 2 - (narrow ? 12 : 40),
    );

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(mid.dx, mid.dy, end.dx, end.dy);

    final paint = Paint()
      ..color = AppColors.flutterLightBlue.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;

    for (final metric in path.computeMetrics()) {
      final extract = metric.extractPath(0, metric.length * progress);
      canvas.drawPath(extract, paint);
      if (progress > 0.75) {
        final t = metric.getTangentForOffset(metric.length * progress);
        if (t != null) {
          final tip = t.position;
          final v = t.vector;
          final len = v.distance;
          if (len > 0.001) {
            final d = v / len;
            canvas.drawLine(
              tip,
              tip + Offset(-d.dx * 10 + d.dy * 6, -d.dy * 10 - d.dx * 6),
              paint,
            );
            canvas.drawLine(
              tip,
              tip + Offset(-d.dx * 10 - d.dy * 6, -d.dy * 10 + d.dx * 6),
              paint,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ContactArrowPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.start != start ||
      oldDelegate.end != end ||
      oldDelegate.narrow != narrow ||
      oldDelegate.rtl != rtl;
}

class _Postcard extends StatefulWidget {
  const _Postcard({
    required this.emailKey,
    required this.customCursor,
  });

  final GlobalKey emailKey;
  final bool customCursor;

  @override
  State<_Postcard> createState() => _PostcardState();
}

class _PostcardState extends State<_Postcard> {
  bool _copied = false;

  Future<void> _copyEmail() async {
    await Clipboard.setData(
      const ClipboardData(text: PortfolioData.email),
    );
    if (!mounted) return;
    setState(() => _copied = true);
    Future<void>.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  Future<void> _open(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final linkedIn = PortfolioData.socials
        .where((s) => s.id == 'linkedin' && !isTodo(s.url))
        .firstOrNull;
    final github = PortfolioData.socials
        .where((s) => s.id == 'github' && !isTodo(s.url))
        .firstOrNull;

    return CursorTarget(
      enabled: widget.customCursor,
      child: PaperCard(
        tilt: 0.012,
        tapeColor: AppColors.flutterLightBlue.withValues(alpha: 0.85),
        padding: const EdgeInsets.fromLTRB(22, 34, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppTypography.displayCase(context, l10n.contactPostcardFrom),
              style: AppTypography.label(
                context,
                fontSize: 10,
                color: AppColors.flutterBlue,
              ),
            ),
            Text(
              AppTypography.displayCase(context, PortfolioData.fullName),
              style: AppTypography.headline(
                context,
                fontSize: 28,
                color: AppColors.navyInk,
              ),
            ),
            const SizedBox(height: 6),
            Container(height: 1, color: AppColors.paperEdge),
            const SizedBox(height: 18),
            Text(
              '${l10n.contactPostcardTo}:',
              style: AppTypography.label(
                context,
                fontSize: 10,
                color: zine.inkMuted,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                KeyedSubtree(
                  key: widget.emailKey,
                  child: _ContactAction(
                    label: l10n.contactEmail,
                    value: PortfolioData.email,
                    customCursor: widget.customCursor,
                    trailing: _copied ? l10n.contactCopied : null,
                    onTap: _copyEmail,
                  ),
                ),
                _ContactAction(
                  label: l10n.contactPhone,
                  value: PortfolioData.phone,
                  customCursor: widget.customCursor,
                  onTap: () => _open('tel:${PortfolioData.phone}'),
                ),
                if (linkedIn != null)
                  _ContactAction(
                    label: l10n.linkLinkedIn,
                    value: linkedIn.url,
                    shortValue: l10n.linkLinkedIn,
                    customCursor: widget.customCursor,
                    onTap: () => _open(linkedIn.url),
                  ),
                if (github != null)
                  _ContactAction(
                    label: l10n.linkGitHub,
                    value: github.url,
                    shortValue: l10n.linkGitHub,
                    customCursor: widget.customCursor,
                    onTap: () => _open(github.url),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactAction extends StatelessWidget {
  const _ContactAction({
    required this.label,
    required this.value,
    required this.customCursor,
    required this.onTap,
    this.shortValue,
    this.trailing,
  });

  final String label;
  final String value;
  final String? shortValue;
  final String? trailing;
  final bool customCursor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CursorTarget(
      enabled: customCursor,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          mouseCursor: SystemMouseCursors.none,
          child: Container(
            constraints: const BoxConstraints(minWidth: 160),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.flutterBlue.withValues(alpha: 0.35),
              ),
              color: AppColors.flutterLightBlue.withValues(alpha: 0.06),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      AppTypography.displayCase(context, label),
                      style: AppTypography.label(
                        context,
                        fontSize: 10,
                        color: AppColors.flutterBlue,
                      ),
                    ),
                    if (trailing != null)
                      Text(
                        trailing!,
                        style: AppTypography.label(
                          context,
                          fontSize: 10,
                          color: AppColors.flutterLightBlue,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  shortValue ?? value,
                  softWrap: true,
                  style: AppTypography.note(
                    context,
                    fontSize: 15,
                    color: AppColors.navyInk,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
