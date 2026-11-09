import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_typography.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/host_venue_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/cursor_controller.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/diagrams/host_venue_diagrams.dart';
import 'package:ahmed_rasmy_portfolio/core/utils/asset_checker.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/paper_card.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/safe_asset_image.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_layout.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_study_nav.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/diagram_view.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/scroll_reveal.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/zine_background.dart';
import 'package:ahmed_rasmy_portfolio/features/host_venue/widgets/dart_code_viewer.dart';
import 'package:ahmed_rasmy_portfolio/features/host_venue/widgets/status_stamp.dart';

/// Deep-dive: `/work/gatherup/host-venue-mode`
class HostVenuePage extends StatefulWidget {
  const HostVenuePage({super.key});

  @override
  State<HostVenuePage> createState() => _HostVenuePageState();
}

class _HostVenuePageState extends State<HostVenuePage> {
  final _scroll = ScrollController();
  final _parallax = ValueNotifier<Offset>(Offset.zero);
  final _scrollOffset = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.hasClients) _scrollOffset.value = _scroll.offset;
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _parallax.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zine = context.zine;
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 700;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final customCursor = cursorController.enabled && !mobile;
    final pagePad = CaseLayout.pagePadding(width);
    final gap = width < CaseLayout.stackBreakpoint ? 36.0 : 56.0;
    final ar = AppTypography.isArabic(context);

    return Scaffold(
      backgroundColor: zine.canvas,
      body: ZineBackground(
        parallax: _parallax,
        child: Stack(
          children: [
            Column(
              children: [
                CaseStudyNav(
                  title: HostVenueData.heroTitle.t(ar),
                  customCursor: customCursor,
                  mobile: mobile,
                ),
                Expanded(
                  child: CustomScrollView(
                    controller: _scroll,
                    physics: const ClampingScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: pagePad,
                            child: ConstrainedBox(
                              constraints:
                                  const BoxConstraints(maxWidth: 1000),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _Hero(
                                    ar: ar,
                                    reduceMotion: reduceMotion,
                                    customCursor: customCursor,
                                  ),
                                  SizedBox(height: gap),
                                  _ReceiptsSection(
                                    ar: ar,
                                    scrollOffset: _scrollOffset,
                                    reduceMotion: reduceMotion,
                                    customCursor: customCursor,
                                  ),
                                  SizedBox(height: gap),
                                  _OverviewSection(
                                    ar: ar,
                                    scrollOffset: _scrollOffset,
                                    reduceMotion: reduceMotion,
                                    customCursor: customCursor,
                                  ),
                                  SizedBox(height: gap),
                                  _FlowsSection(
                                    ar: ar,
                                    scrollOffset: _scrollOffset,
                                    reduceMotion: reduceMotion,
                                    customCursor: customCursor,
                                  ),
                                  SizedBox(height: gap),
                                  _DecisionsSection(
                                    ar: ar,
                                    scrollOffset: _scrollOffset,
                                    reduceMotion: reduceMotion,
                                    customCursor: customCursor,
                                  ),
                                  SizedBox(height: gap),
                                  _IsolationSection(
                                    ar: ar,
                                    scrollOffset: _scrollOffset,
                                    reduceMotion: reduceMotion,
                                    customCursor: customCursor,
                                  ),
                                  SizedBox(height: gap),
                                  _ArchitectureSection(
                                    ar: ar,
                                    scrollOffset: _scrollOffset,
                                    reduceMotion: reduceMotion,
                                    customCursor: customCursor,
                                  ),
                                  SizedBox(height: gap),
                                  _CodeSection(
                                    ar: ar,
                                    scrollOffset: _scrollOffset,
                                    reduceMotion: reduceMotion,
                                    customCursor: customCursor,
                                  ),
                                  SizedBox(height: gap),
                                  _QualitySection(
                                    ar: ar,
                                    scrollOffset: _scrollOffset,
                                    reduceMotion: reduceMotion,
                                    customCursor: customCursor,
                                  ),
                                  if (HostVenueData.learnings.isNotEmpty) ...[
                                    SizedBox(height: gap),
                                    _LearningsSection(
                                      ar: ar,
                                      scrollOffset: _scrollOffset,
                                      reduceMotion: reduceMotion,
                                      customCursor: customCursor,
                                    ),
                                  ],
                                  SizedBox(height: gap),
                                  _GallerySection(
                                    ar: ar,
                                    scrollOffset: _scrollOffset,
                                    reduceMotion: reduceMotion,
                                    customCursor: customCursor,
                                  ),
                                  const SizedBox(height: 48),
                                  CursorTarget(
                                    enabled: customCursor,
                                    child: TextButton(
                                      onPressed: () =>
                                          context.go('/work/gatherup'),
                                      child: Text(
                                        ar
                                            ? '← العودة لدراسة GatherUp'
                                            : '← Back to GatherUp case study',
                                        style: AppTypography.label(
                                          context,
                                          fontSize: 12,
                                          color: AppColors.flutterLightBlue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Custom cursor overlay lives in PortfolioApp (_CursorShell).
          ],
        ),
      ),
    );
  }
}

// ── Hero ──────────────────────────────────────────────────────────────────────

class _Hero extends StatelessWidget {
  const _Hero({
    required this.ar,
    required this.reduceMotion,
    required this.customCursor,
  });

  final bool ar;
  final bool reduceMotion;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final zine = context.zine;
    final stickers = [
      ('Role', HostVenueData.metaRole.t(ar)),
      ('App', HostVenueData.metaApp.t(ar)),
      ('Stack', HostVenueData.metaStack.t(ar)),
      ('Period', HostVenueData.metaPeriod.t(ar)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                HostVenueData.heroLabel.t(ar),
                softWrap: true,
                style: AppTypography.label(
                  context,
                  fontSize: 11,
                  color: AppColors.flutterLightBlue,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerEnd,
                  child: const StatusStamp(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          HostVenueData.heroTitle.t(ar),
          softWrap: true,
          style: AppTypography.headline(context, fontSize: 48),
        ),
        const SizedBox(height: 8),
        Transform.rotate(
          angle: CaseLayout.tilt(-0.04, width: MediaQuery.sizeOf(context).width),
          child: Text(
            HostVenueData.heroBrush.t(ar),
            style: AppTypography.note(
              context,
              fontSize: 22,
              color: AppColors.flutterLightBlue,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          HostVenueData.heroTagline.t(ar),
          softWrap: true,
          style: AppTypography.body(context, fontSize: 16, color: zine.inkMuted),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < stickers.length; i++)
              Transform.rotate(
                angle: CaseLayout.tilt(
                  (i.isEven ? -1 : 1) * 0.03,
                  width: MediaQuery.sizeOf(context).width,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  color: zine.sticky,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${stickers[i].$1}: ',
                          style: AppTypography.label(
                            context,
                            fontSize: 10,
                            color: AppColors.navyInk,
                          ),
                        ),
                        TextSpan(
                          text: stickers[i].$2,
                          style: AppTypography.note(
                            context,
                            fontSize: 12,
                            color: AppColors.navyInk,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          HostVenueData.credit.t(ar),
          softWrap: true,
          style: AppTypography.note(
            context,
            fontSize: 13,
            color: zine.inkMuted,
          ),
        ),
      ],
    );
  }
}

// ── 01 Receipts ───────────────────────────────────────────────────────────────

class _ReceiptsSection extends StatefulWidget {
  const _ReceiptsSection({
    required this.ar,
    required this.scrollOffset,
    required this.reduceMotion,
    required this.customCursor,
  });

  final bool ar;
  final ValueNotifier<double> scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  State<_ReceiptsSection> createState() => _ReceiptsSectionState();
}

class _ReceiptsSectionState extends State<_ReceiptsSection> {
  bool _subOpen = false;

  @override
  Widget build(BuildContext context) {
    final ar = widget.ar;
    final narrow = MediaQuery.sizeOf(context).width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '01',
          eyebrow: ar ? 'الإيصالات' : 'THE RECEIPTS',
          title: HostVenueData.receiptsHeadline.t(ar),
          intro: HostVenueData.receiptsSub.t(ar),
          scrollOffset: widget.scrollOffset,
          reduceMotion: widget.reduceMotion,
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _CountSticker(
              target: HostVenueData.receiptCommits.toDouble(),
              suffix: '',
              label: HostVenueData.receiptStatCommits.t(ar),
              scrollOffset: widget.scrollOffset,
              reduceMotion: widget.reduceMotion,
              decimals: 0,
            ),
            _CountSticker(
              target: HostVenueData.receiptLines.toDouble(),
              suffix: '',
              prefix: '~',
              label: HostVenueData.receiptStatLines.t(ar),
              scrollOffset: widget.scrollOffset,
              reduceMotion: widget.reduceMotion,
              decimals: 0,
            ),
            _CountSticker(
              target: HostVenueData.receiptOwnershipPercent.toDouble(),
              suffix: '%',
              label: HostVenueData.receiptStatOwned.t(ar),
              scrollOffset: widget.scrollOffset,
              reduceMotion: widget.reduceMotion,
              decimals: 0,
            ),
            _StaticSticker(
              value: HostVenueData.receiptTimeline.t(ar),
              label: HostVenueData.receiptStatTimeline.t(ar),
            ),
          ],
        ),
        const SizedBox(height: 28),
        for (var i = 0; i < HostVenueData.ownershipAreas.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _OwnershipBar(
            area: HostVenueData.ownershipAreas[i],
            ar: ar,
            scrollOffset: widget.scrollOffset,
            reduceMotion: widget.reduceMotion,
          ),
        ],
        const SizedBox(height: 20),
        PaperCard(
          tilt: -0.02,
          tapeColor: AppColors.stickyYellow,
          child: Text(
            HostVenueData.ownershipFootnote.t(ar),
            softWrap: true,
            style: AppTypography.note(
              context,
              fontSize: 14,
              color: AppColors.navyInk,
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (narrow)
          CursorTarget(
            enabled: widget.customCursor,
            child: TextButton(
              onPressed: () => setState(() => _subOpen = !_subOpen),
              child: Text(
                _subOpen
                    ? (ar ? 'إخفاء التفصيل' : 'Hide sub-features')
                    : (ar ? 'تفصيل الالتزامات' : 'Sub-feature commits'),
                style: AppTypography.label(
                  context,
                  fontSize: 12,
                  color: AppColors.flutterLightBlue,
                ),
              ),
            ),
          ),
        if (!narrow || _subOpen) ...[
          const SizedBox(height: 8),
          _HeatStrip(
            ar: ar,
            reduceMotion: widget.reduceMotion,
            customCursor: widget.customCursor,
          ),
        ],
      ],
    );
  }
}

class _CountSticker extends StatefulWidget {
  const _CountSticker({
    required this.target,
    required this.label,
    required this.scrollOffset,
    required this.reduceMotion,
    this.suffix = '',
    this.prefix = '',
    this.decimals = 0,
  });

  final double target;
  final String label;
  final String suffix;
  final String prefix;
  final int decimals;
  final ValueNotifier<double> scrollOffset;
  final bool reduceMotion;

  @override
  State<_CountSticker> createState() => _CountStickerState();
}

class _CountStickerState extends State<_CountSticker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    widget.scrollOffset.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    widget.scrollOffset.removeListener(_check);
    _c.dispose();
    super.dispose();
  }

  void _check() {
    if (_started || !mounted) return;
    if (widget.reduceMotion) {
      _started = true;
      _c.value = 1;
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    if (top < MediaQuery.sizeOf(context).height * 0.85) {
      _started = true;
      _c.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = Curves.easeOutCubic.transform(_c.value);
        final v = widget.target * t;
        final text = widget.decimals == 0
            ? v.round().toString()
            : v.toStringAsFixed(widget.decimals);
        return _StaticSticker(
          value: '${widget.prefix}$text${widget.suffix}',
          label: widget.label,
        );
      },
    );
  }
}

class _StaticSticker extends StatelessWidget {
  const _StaticSticker({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.zine.paper,
        border: Border.all(
          color: AppColors.flutterBlue.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTypography.headline(
              context,
              fontSize: 28,
              color: AppColors.flutterLightBlue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            softWrap: true,
            style: AppTypography.label(
              context,
              fontSize: 10,
              color: context.zine.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnershipBar extends StatefulWidget {
  const _OwnershipBar({
    required this.area,
    required this.ar,
    required this.scrollOffset,
    required this.reduceMotion,
  });

  final OwnershipArea area;
  final bool ar;
  final ValueNotifier<double> scrollOffset;
  final bool reduceMotion;

  @override
  State<_OwnershipBar> createState() => _OwnershipBarState();
}

class _OwnershipBarState extends State<_OwnershipBar> {
  double _p = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollOffset.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    widget.scrollOffset.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    if (widget.reduceMotion) {
      if (_p != 1) setState(() => _p = 1);
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final h = MediaQuery.sizeOf(context).height;
    final next = ((h * 0.9 - top) / (h * 0.4)).clamp(0.0, 1.0);
    if ((next - _p).abs() > 0.02) setState(() => _p = next);
  }

  @override
  Widget build(BuildContext context) {
    final area = widget.area;
    final ar = widget.ar;
    final frac = (area.ahmedPercent / 100) * _p;
    final lineText = area.lines == null
        ? 'n/a'
        : (area.label.en.contains('Localization')
            ? '~${area.lines}'
            : '${area.lines}');
    final pctText = area.ahmedPercent == area.ahmedPercent.roundToDouble()
        ? '${area.ahmedPercent.round()}'
        : '${area.ahmedPercent}';
    final pctPrefix = area.lines == null ? '~' : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                area.label.t(ar),
                softWrap: true,
                style: AppTypography.label(context, fontSize: 11),
              ),
            ),
            Text(
              '$lineText · $pctPrefix$pctText%',
              style: AppTypography.label(
                context,
                fontSize: 10,
                color: AppColors.flutterLightBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, c) {
            return Stack(
              children: [
                Container(
                  height: 10,
                  width: c.maxWidth,
                  color: AppColors.navy.withValues(alpha: 0.35),
                ),
                Container(
                  height: 10,
                  width: c.maxWidth * frac,
                  color: AppColors.flutterLightBlue,
                ),
                if (frac < 0.99)
                  PositionedDirectional(
                    start: c.maxWidth * frac,
                    child: Container(
                      height: 10,
                      width: c.maxWidth * (1 - frac),
                      color: AppColors.offWhite.withValues(alpha: 0.12),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _HeatStrip extends StatelessWidget {
  const _HeatStrip({
    required this.ar,
    required this.reduceMotion,
    required this.customCursor,
  });

  final bool ar;
  final bool reduceMotion;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final maxC = HostVenueData.subFeatures
        .map((e) => e.commits)
        .fold<int>(1, (a, b) => a > b ? a : b);

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final f in HostVenueData.subFeatures)
          Tooltip(
            message: '${f.label.t(ar)} · ${f.commits}',
            child: CursorTarget(
              enabled: customCursor,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                color: AppColors.flutterBlue.withValues(
                  alpha: 0.15 + 0.55 * (f.commits / maxC),
                ),
                child: Text(
                  '${f.label.t(ar)} · ${f.commits}',
                  style: AppTypography.label(context, fontSize: 10),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── 02 Overview ───────────────────────────────────────────────────────────────

class _OverviewSection extends StatefulWidget {
  const _OverviewSection({
    required this.ar,
    required this.scrollOffset,
    required this.reduceMotion,
    required this.customCursor,
  });

  final bool ar;
  final ValueNotifier<double> scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  State<_OverviewSection> createState() => _OverviewSectionState();
}

class _OverviewSectionState extends State<_OverviewSection> {
  OperatorRole _role = OperatorRole.host;

  @override
  Widget build(BuildContext context) {
    final ar = widget.ar;
    final role = HostVenueData.roles.firstWhere((r) => r.role == _role);
    final hasShot = AssetChecker.has(role.screenshot);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '02',
          eyebrow: ar ? 'نظرة عامة' : 'OVERVIEW',
          title: HostVenueData.overviewHeadline.t(ar),
          intro: HostVenueData.overviewSummary.t(ar),
          scrollOffset: widget.scrollOffset,
          reduceMotion: widget.reduceMotion,
        ),
        const SizedBox(height: 16),
        PaperCard(
          tilt: 0.015,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                HostVenueData.overviewWhyLabel.t(ar),
                style: AppTypography.label(
                  context,
                  fontSize: 11,
                  color: AppColors.flutterBlue,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                HostVenueData.overviewWhy.t(ar),
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
        const SizedBox(height: 24),
        _RoleToggle(
          role: _role,
          ar: ar,
          customCursor: widget.customCursor,
          onChanged: (r) => setState(() => _role = r),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, c) {
            final stack = c.maxWidth < 700;
            final note = PaperCard(
              tilt: -0.02,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ar ? 'يمكن' : 'Can',
                    style: AppTypography.label(
                      context,
                      fontSize: 11,
                      color: AppColors.flutterBlue,
                    ),
                  ),
                  const SizedBox(height: 6),
                  for (final x in role.can)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '→ ${x.t(ar)}',
                        softWrap: true,
                        style: AppTypography.note(
                          context,
                          fontSize: 13,
                          color: AppColors.navyInk,
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    ar ? 'لا يمكن' : 'Cannot',
                    style: AppTypography.label(
                      context,
                      fontSize: 11,
                      color: AppColors.navyInk.withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 6),
                  for (final x in role.cannot)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '→ ${x.t(ar)}',
                        softWrap: true,
                        style: AppTypography.note(
                          context,
                          fontSize: 13,
                          color: AppColors.navyInk.withValues(alpha: 0.75),
                        ),
                      ),
                    ),
                ],
              ),
            );

            final phone = hasShot
                ? SizedBox(
                    width: stack ? 180 : 200,
                    child: AnimatedSwitcher(
                      duration: widget.reduceMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 320),
                      child: KeyedSubtree(
                        key: ValueKey(_role),
                        child: _PhoneShot(path: role.screenshot),
                      ),
                    ),
                  )
                : const SizedBox.shrink();

            if (stack) {
              return Column(
                children: [
                  if (hasShot) phone,
                  if (hasShot) const SizedBox(height: 16),
                  note,
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasShot) ...[phone, const SizedBox(width: 24)],
                Expanded(child: note),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _RoleToggle extends StatelessWidget {
  const _RoleToggle({
    required this.role,
    required this.ar,
    required this.customCursor,
    required this.onChanged,
  });

  final OperatorRole role;
  final bool ar;
  final bool customCursor;
  final ValueChanged<OperatorRole> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = [
      (OperatorRole.member, HostVenueData.roleMemberLabel.t(ar)),
      (OperatorRole.host, HostVenueData.roleHostLabel.t(ar)),
      (OperatorRole.venue, HostVenueData.roleVenueLabel.t(ar)),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.45),
        border: Border.all(
          color: AppColors.flutterLightBlue.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: CursorTarget(
                enabled: customCursor,
                child: Material(
                  color: role == item.$1
                      ? AppColors.flutterLightBlue
                      : Colors.transparent,
                  child: InkWell(
                    onTap: () => onChanged(item.$1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        item.$2,
                        textAlign: TextAlign.center,
                        style: AppTypography.label(
                          context,
                          fontSize: 11,
                          color: role == item.$1
                              ? AppColors.navyInk
                              : AppColors.offWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PhoneShot extends StatelessWidget {
  const _PhoneShot({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return OptionalAssetFrame(
      assetPath: path,
      builder: (context, image) {
        return AspectRatio(
          aspectRatio: 9 / 19,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.navyInk,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.flutterBlue, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 14, 8, 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: image,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── 03 Flows ──────────────────────────────────────────────────────────────────

class _FlowsSection extends StatefulWidget {
  const _FlowsSection({
    required this.ar,
    required this.scrollOffset,
    required this.reduceMotion,
    required this.customCursor,
  });

  final bool ar;
  final ValueNotifier<double> scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  State<_FlowsSection> createState() => _FlowsSectionState();
}

class _FlowsSectionState extends State<_FlowsSection> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final ar = widget.ar;
    final tabs = HostVenueDiagrams.flowTabs;
    final spec = tabs[_tab.clamp(0, tabs.length - 1)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '03',
          eyebrow: ar ? 'التدفقات' : 'FLOWS',
          title: HostVenueData.flowsHeadline.t(ar),
          intro: '',
          scrollOffset: widget.scrollOffset,
          reduceMotion: widget.reduceMotion,
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < tabs.length; i++)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: CursorTarget(
                    enabled: widget.customCursor,
                    child: ChoiceChip(
                      label: Text(
                        tabs[i].title(ar),
                        style: AppTypography.label(context, fontSize: 11),
                      ),
                      selected: _tab == i,
                      onSelected: (_) => setState(() => _tab = i),
                      selectedColor: AppColors.flutterLightBlue,
                      backgroundColor: AppColors.navy.withValues(alpha: 0.4),
                      side: BorderSide(
                        color: AppColors.flutterBlue.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: widget.reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 280),
          child: DiagramView(
            key: ValueKey(spec.id),
            spec: spec,
            scrollOffset: widget.scrollOffset,
            reduceMotion: widget.reduceMotion,
            height: MediaQuery.sizeOf(context).width < 600 ? 360 : 320,
          ),
        ),
      ],
    );
  }
}

// ── 04 Decisions ──────────────────────────────────────────────────────────────

class _DecisionsSection extends StatelessWidget {
  const _DecisionsSection({
    required this.ar,
    required this.scrollOffset,
    required this.reduceMotion,
    required this.customCursor,
  });

  final bool ar;
  final ValueNotifier<double> scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '04',
          eyebrow: ar ? 'قرارات' : 'DESIGN DECISIONS',
          title: HostVenueData.decisionsHeadline.t(ar),
          intro: '',
          scrollOffset: scrollOffset,
          reduceMotion: reduceMotion,
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < HostVenueData.decisions.length; i++) ...[
          if (i > 0) const SizedBox(height: 14),
          ScrollReveal(
            scrollOffset: scrollOffset,
            reduceMotion: reduceMotion,
            delayFraction: i * 0.05,
            child: PaperCard(
              tilt: CaseLayout.tilt(
                i.isEven ? 0.02 : -0.02,
                width: MediaQuery.sizeOf(context).width,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    HostVenueData.decisions[i].decision.t(ar),
                    softWrap: true,
                    style: AppTypography.headline(context, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${ar ? 'لماذا' : 'Why'}: ${HostVenueData.decisions[i].why.t(ar)}',
                    softWrap: true,
                    style: AppTypography.note(
                      context,
                      fontSize: 14,
                      color: AppColors.navyInk,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${ar ? 'مقايضة' : 'Trade-off'}: ${HostVenueData.decisions[i].tradeOff.t(ar)}',
                    softWrap: true,
                    style: AppTypography.note(
                      context,
                      fontSize: 13,
                      color: AppColors.navyInk.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ── 05 Isolation ──────────────────────────────────────────────────────────────

class _IsolationSection extends StatefulWidget {
  const _IsolationSection({
    required this.ar,
    required this.scrollOffset,
    required this.reduceMotion,
    required this.customCursor,
  });

  final bool ar;
  final ValueNotifier<double> scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  State<_IsolationSection> createState() => _IsolationSectionState();
}

class _IsolationSectionState extends State<_IsolationSection> {
  int _visible = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollOffset.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    widget.scrollOffset.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    if (widget.reduceMotion) {
      if (_visible != HostVenueData.isolationSteps.length) {
        setState(() => _visible = HostVenueData.isolationSteps.length);
      }
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final h = MediaQuery.sizeOf(context).height;
    final p = ((h * 0.85 - top) / (h * 0.55)).clamp(0.0, 1.0);
    final next = (p * HostVenueData.isolationSteps.length).ceil();
    if (next != _visible) setState(() => _visible = next);
  }

  @override
  Widget build(BuildContext context) {
    final ar = widget.ar;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '05',
          eyebrow: ar ? 'أصعب جزء' : 'THE HARDEST PART',
          title: HostVenueData.isolationHeadline.t(ar),
          intro: HostVenueData.isolationIntro.t(ar),
          scrollOffset: widget.scrollOffset,
          reduceMotion: widget.reduceMotion,
        ),
        const SizedBox(height: 8),
        Text(
          HostVenueData.isolationStackLabel.t(ar),
          style: AppTypography.label(
            context,
            fontSize: 11,
            color: AppColors.flutterLightBlue,
          ),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < HostVenueData.isolationSteps.length; i++)
          AnimatedOpacity(
            opacity: i < _visible ? 1 : 0.15,
            duration: const Duration(milliseconds: 280),
            child: AnimatedSlide(
              offset: i < _visible ? Offset.zero : const Offset(0.08, 0),
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: context.zine.paper,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${i + 1}. ${HostVenueData.isolationSteps[i].title.t(ar)}',
                        style: AppTypography.label(
                          context,
                          fontSize: 12,
                          color: AppColors.navyInk,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        HostVenueData.isolationSteps[i].body.t(ar),
                        softWrap: true,
                        style: AppTypography.note(
                          context,
                          fontSize: 13,
                          color: AppColors.navyInk.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(height: 20),
        for (var i = 0; i < HostVenueData.challenges.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          PaperCard(
            tilt: CaseLayout.tilt(
              i.isEven ? -0.015 : 0.015,
              width: MediaQuery.sizeOf(context).width,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${ar ? 'مشكلة' : 'Problem'}: ${HostVenueData.challenges[i].problem.t(ar)}',
                  softWrap: true,
                  style: AppTypography.headline(context, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  '${ar ? 'الحل' : 'How I solved it'}: ${HostVenueData.challenges[i].solution.t(ar)}',
                  softWrap: true,
                  style: AppTypography.note(
                    context,
                    fontSize: 14,
                    color: AppColors.navyInk,
                  ),
                ),
                if (HostVenueData.challenges[i].learned.t(ar).isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${ar ? 'تعلّمت' : 'Learned'}: ${HostVenueData.challenges[i].learned.t(ar)}',
                    softWrap: true,
                    style: AppTypography.note(
                      context,
                      fontSize: 13,
                      color: AppColors.navyInk.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        Text(
          HostVenueData.raceVisualLabel.t(ar),
          style: AppTypography.label(
            context,
            fontSize: 11,
            color: AppColors.flutterLightBlue,
          ),
        ),
        const SizedBox(height: 10),
        _RaceVisual(reduceMotion: widget.reduceMotion, ar: ar),
      ],
    );
  }
}

class _RaceVisual extends StatefulWidget {
  const _RaceVisual({required this.reduceMotion, required this.ar});

  final bool reduceMotion;
  final bool ar;

  @override
  State<_RaceVisual> createState() => _RaceVisualState();
}

class _RaceVisualState extends State<_RaceVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    if (!widget.reduceMotion) {
      _c.repeat();
    } else {
      _c.value = 1;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        final aProgress = (t * 0.55).clamp(0.0, 1.0);
        final bProgress = (t * 1.2).clamp(0.0, 1.0);
        final discard = t > 0.72;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.flutterBlue.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            children: [
              _RaceRow(
                label: widget.ar ? 'العلامة أ (بطيء)' : 'Brand A (slow)',
                progress: aProgress,
                discarded: discard && aProgress < 1,
                color: AppColors.offWhite.withValues(alpha: 0.45),
              ),
              const SizedBox(height: 12),
              _RaceRow(
                label: widget.ar ? 'العلامة ب (سريع)' : 'Brand B (fast)',
                progress: bProgress,
                discarded: false,
                color: AppColors.flutterLightBlue,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RaceRow extends StatelessWidget {
  const _RaceRow({
    required this.label,
    required this.progress,
    required this.discarded,
    required this.color,
  });

  final String label;
  final double progress;
  final bool discarded;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.label(context, fontSize: 10)),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, c) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 8,
                  width: c.maxWidth,
                  color: AppColors.navy.withValues(alpha: 0.35),
                ),
                Container(
                  height: 8,
                  width: c.maxWidth * progress,
                  color: color,
                ),
                if (discarded)
                  Positioned.fill(
                    child: CustomPaint(painter: _CrossOutPainter()),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CrossOutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFFE57373)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), p);
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── 06 Architecture ───────────────────────────────────────────────────────────

class _ArchitectureSection extends StatelessWidget {
  const _ArchitectureSection({
    required this.ar,
    required this.scrollOffset,
    required this.reduceMotion,
    required this.customCursor,
  });

  final bool ar;
  final ValueNotifier<double> scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '06',
          eyebrow: ar ? 'الهندسة' : 'ARCHITECTURE',
          title: ar ? 'الطبقات ونموذج البيانات' : 'Layers + data model',
          intro: '',
          scrollOffset: scrollOffset,
          reduceMotion: reduceMotion,
        ),
        const SizedBox(height: 12),
        DiagramView(
          spec: HostVenueDiagrams.architecture,
          scrollOffset: scrollOffset,
          reduceMotion: reduceMotion,
          height: 280,
        ),
        const SizedBox(height: 10),
        Text(
          HostVenueData.archNote.t(ar),
          softWrap: true,
          style: AppTypography.note(
            context,
            fontSize: 13,
            color: context.zine.inkMuted,
          ),
        ),
        const SizedBox(height: 24),
        DiagramView(
          spec: HostVenueDiagrams.erd,
          scrollOffset: scrollOffset,
          reduceMotion: reduceMotion,
          height: 300,
        ),
      ],
    );
  }
}

// ── 07 Code ───────────────────────────────────────────────────────────────────

class _CodeSection extends StatelessWidget {
  const _CodeSection({
    required this.ar,
    required this.scrollOffset,
    required this.reduceMotion,
    required this.customCursor,
  });

  final bool ar;
  final ValueNotifier<double> scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '07',
          eyebrow: ar ? 'الكود' : 'CODE',
          title: HostVenueData.codeHeadline.t(ar),
          intro: '',
          scrollOffset: scrollOffset,
          reduceMotion: reduceMotion,
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < HostVenueData.snippets.length; i++) ...[
          if (i > 0) const SizedBox(height: 20),
          ScrollReveal(
            scrollOffset: scrollOffset,
            reduceMotion: reduceMotion,
            delayFraction: i * 0.06,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  HostVenueData.snippets[i].title.t(ar),
                  style: AppTypography.headline(context, fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  HostVenueData.snippets[i].explanation.t(ar),
                  softWrap: true,
                  style: AppTypography.note(
                    context,
                    fontSize: 13,
                    color: context.zine.inkMuted,
                  ),
                ),
                const SizedBox(height: 10),
                DartCodeViewer(
                  code: HostVenueData.snippets[i].code,
                  customCursor: customCursor,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ── 08 Quality ────────────────────────────────────────────────────────────────

class _QualitySection extends StatelessWidget {
  const _QualitySection({
    required this.ar,
    required this.scrollOffset,
    required this.reduceMotion,
    required this.customCursor,
  });

  final bool ar;
  final ValueNotifier<double> scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '08',
          eyebrow: ar ? 'الجودة' : 'QUALITY',
          title: HostVenueData.qualityHeadline.t(ar),
          intro: '',
          scrollOffset: scrollOffset,
          reduceMotion: reduceMotion,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final f in HostVenueData.qualityFacts)
              Container(
                width: 220,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.zine.paper,
                  border: Border.all(
                    color: AppColors.flutterBlue.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      f.label.t(ar),
                      style: AppTypography.label(
                        context,
                        fontSize: 10,
                        color: AppColors.flutterBlue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      f.value.t(ar),
                      softWrap: true,
                      style: AppTypography.note(
                        context,
                        fontSize: 13,
                        color: AppColors.navyInk,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ── 09 Learnings ──────────────────────────────────────────────────────────────

class _LearningsSection extends StatelessWidget {
  const _LearningsSection({
    required this.ar,
    required this.scrollOffset,
    required this.reduceMotion,
    required this.customCursor,
  });

  final bool ar;
  final ValueNotifier<double> scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final notes = HostVenueData.learnings
        .where((l) => !l.en.startsWith('TODO_REPLACE'))
        .toList();
    if (notes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '09',
          eyebrow: ar ? 'ما تعلّمته' : 'WHAT I LEARNED',
          title: HostVenueData.learningsHeadline.t(ar),
          intro: '',
          scrollOffset: scrollOffset,
          reduceMotion: reduceMotion,
        ),
        const SizedBox(height: 14),
        for (var i = 0; i < notes.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          PaperCard(
            tilt: CaseLayout.tilt(
              i.isEven ? 0.02 : -0.02,
              width: MediaQuery.sizeOf(context).width,
            ),
            child: Text(
              notes[i].t(ar),
              softWrap: true,
              style: AppTypography.note(
                context,
                fontSize: 15,
                color: AppColors.navyInk,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ── 10 Gallery ────────────────────────────────────────────────────────────────

class _GallerySection extends StatelessWidget {
  const _GallerySection({
    required this.ar,
    required this.scrollOffset,
    required this.reduceMotion,
    required this.customCursor,
  });

  final bool ar;
  final ValueNotifier<double> scrollOffset;
  final bool reduceMotion;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final shots = HostVenueData.gallery
        .where((g) => AssetChecker.has(g.path))
        .toList();
    if (shots.isEmpty) return const SizedBox.shrink();

    final groups = {
      OperatorRole.member: shots
          .where((s) => s.mode == OperatorRole.member)
          .toList(),
      OperatorRole.host:
          shots.where((s) => s.mode == OperatorRole.host).toList(),
      OperatorRole.venue:
          shots.where((s) => s.mode == OperatorRole.venue).toList(),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          number: '10',
          eyebrow: ar ? 'المعرض' : 'GALLERY',
          title: HostVenueData.galleryHeadline.t(ar),
          intro: '',
          scrollOffset: scrollOffset,
          reduceMotion: reduceMotion,
        ),
        for (final entry in groups.entries)
          if (entry.value.isNotEmpty) ...[
            const SizedBox(height: 18),
            Text(
              switch (entry.key) {
                OperatorRole.member =>
                  ar ? 'العضو / التبديل' : 'Member / switch',
                OperatorRole.host => ar ? 'المضيف' : 'Host',
                OperatorRole.venue => ar ? 'المكان' : 'Venue',
              },
              style: AppTypography.label(
                context,
                fontSize: 12,
                color: AppColors.flutterLightBlue,
              ),
            ),
            const SizedBox(height: 10),
            CaseSnapGallery(
              height: 340,
              viewportFraction:
                  MediaQuery.sizeOf(context).width < 600 ? 0.55 : 0.32,
              itemCount: entry.value.length,
              itemBuilder: (context, i) {
                final shot = entry.value[i];
                return CursorTarget(
                  enabled: customCursor,
                  child: GestureDetector(
                    onTap: () => _openLightbox(context, shot.path),
                    child: Column(
                      children: [
                        Expanded(child: _PhoneShot(path: shot.path)),
                        const SizedBox(height: 8),
                        Text(
                          shot.caption.t(ar),
                          textAlign: TextAlign.center,
                          style: AppTypography.label(context, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
      ],
    );
  }

  void _openLightbox(BuildContext context, String path) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) {
        return GestureDetector(
          onTap: () => Navigator.of(ctx).pop(),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SafeAssetImage(
                assetPath: path,
                showDebugPlaceholder: false,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
