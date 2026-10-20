import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/animation/idle_ticker.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/breakpoints.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/cursor_controller.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/navigation/home_sections.dart';
import 'package:ahmed_rasmy_portfolio/core/painters/ink_splatter_painter.dart';
import 'package:ahmed_rasmy_portfolio/features/home/sections/about_section.dart';
import 'package:ahmed_rasmy_portfolio/features/home/sections/contact_section.dart';
import 'package:ahmed_rasmy_portfolio/features/home/sections/education_section.dart';
import 'package:ahmed_rasmy_portfolio/features/home/sections/experience_section.dart';
import 'package:ahmed_rasmy_portfolio/features/home/sections/skills_section.dart';
import 'package:ahmed_rasmy_portfolio/features/home/sections/work_section.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/site_footer.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/footer_marquee.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/hero_headline.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/masthead_bar.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/portrait_sticker.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/project_chips.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/scroll_hint.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/sticky_nav.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/sticky_notes_stack.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/who_i_am_note.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/zine_background.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ValueNotifier<Offset> _parallax = ValueNotifier(Offset.zero);
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);
  final ValueNotifier<bool> _navVisible = ValueNotifier(false);
  final ValueNotifier<HomeSection?> _activeSection = ValueNotifier(null);
  final ScrollController _scrollController = ScrollController();
  Offset _parallaxTarget = Offset.zero;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final o = _scrollController.offset;
    _scrollOffset.value = o;
    _navVisible.value = o > 200;
    if (!mounted) return;
    final next = HomeSectionKeys.activeFromScroll(context);
    if (next != _activeSection.value) {
      _activeSection.value = next;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _parallax.dispose();
    _scrollOffset.dispose();
    _navVisible.dispose();
    _activeSection.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent event, Size size, {required bool enabled}) {
    if (!enabled) return;
    final nx = (event.localPosition.dx / size.width) * 2 - 1;
    final ny = (event.localPosition.dy / size.height) * 2 - 1;
    _parallaxTarget = Offset(nx * 10, ny * 6);
    final cur = _parallax.value;
    _parallax.value = Offset(
      cur.dx + (_parallaxTarget.dx - cur.dx) * 0.16,
      cur.dy + (_parallaxTarget.dy - cur.dy) * 0.16,
    );
  }

  Future<void> _scrollToSection(HomeSection section) =>
      HomeSectionKeys.scrollTo(section);

  Future<void> _scrollToTop() async {
    if (!_scrollController.hasClients) return;
    await _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final idle = ref.watch(idleTickerProvider);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    idle.setReducedMotion(reduceMotion);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final viewH = MediaQuery.sizeOf(context).height;
        final mobile = Breakpoints.isMobile(width);
        final tablet = Breakpoints.isTablet(width);
        final shortViewport = viewH < 720;
        final parallaxOn = !mobile && !reduceMotion;
        final customCursor = cursorController.enabled && !mobile;

        final portraitH = mobile
            ? (viewH * 0.40).clamp(220.0, 360.0)
            : tablet
                ? (viewH * 0.48).clamp(320.0, 480.0)
                : (viewH * 0.62).clamp(520.0, 620.0);
        final stageH = mobile
            ? portraitH + 420
            : tablet
                ? portraitH + 380
                : portraitH + 320;

        final scrollHint = ScrollHint(
          scrollOffset: _scrollOffset,
          onTap: () => _scrollToSection(HomeSection.work),
          mobile: mobile,
          customCursor: customCursor,
        );

        return MouseRegion(
          cursor: customCursor
              ? SystemMouseCursors.none
              : SystemMouseCursors.basic,
          onHover: (e) => _onHover(
            e,
            Size(width, constraints.maxHeight),
            enabled: parallaxOn,
          ),
          onExit: (_) {
            _parallaxTarget = Offset.zero;
            _parallax.value = Offset.zero;
          },
          child: ZineBackground(
            parallax: _parallax,
            child: Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(
                      child: SafeArea(
                        child: Column(
                          children: [
                            CursorTarget(
                              enabled: customCursor,
                              child: const MastheadBar(),
                            ).animate().fadeIn(duration: 350.ms),
                            SizedBox(
                              height: stageH,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    top: mobile ? 8 : 20,
                                    left: mobile ? 8 : 40,
                                    child: ValueListenableBuilder<Offset>(
                                      valueListenable: _parallax,
                                      child: RepaintBoundary(
                                        child: CustomPaint(
                                          size: Size(
                                            mobile ? 110 : 170,
                                            mobile ? 110 : 170,
                                          ),
                                          painter: InkSplatterPainter(
                                            color: AppColors.flutterLightBlue
                                                .withValues(alpha: 0.9),
                                          ),
                                        ),
                                      ),
                                      builder: (context, offset, child) {
                                        Widget splatter = Transform.translate(
                                          offset: offset * 0.3,
                                          child: child,
                                        );
                                        if (!reduceMotion) {
                                          splatter = splatter
                                              .animate()
                                              .scale(
                                                begin: Offset.zero,
                                                end: const Offset(1, 1),
                                                duration: 520.ms,
                                                curve: Curves.easeOutBack,
                                              )
                                              .fadeIn(duration: 280.ms);
                                        }
                                        return splatter;
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: mobile ? 100 : 70,
                                    right: mobile ? 24 : width * 0.2,
                                    child: TwinklingStar(
                                      size: 20,
                                      idle: idle,
                                      reduceMotion: reduceMotion,
                                    ),
                                  ),
                                  Positioned(
                                    top: mobile ? 200 : 190,
                                    right: mobile ? 36 : width * 0.16,
                                    child: TwinklingStar(
                                      size: 14,
                                      idle: idle,
                                      reduceMotion: reduceMotion,
                                      phase: 0.4,
                                    ),
                                  ),
                                  Positioned(
                                    top: mobile ? 36 : 20,
                                    left: 16,
                                    right: 16,
                                    child: HeroHeadline(
                                      compact: mobile,
                                      reduceMotion: reduceMotion,
                                    ),
                                  ),
                                  Positioned(
                                    top: mobile ? 220 : (tablet ? 160 : 140),
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: ValueListenableBuilder<Offset>(
                                        valueListenable: _parallax,
                                        child: PortraitSticker(
                                          height: portraitH,
                                          enableParallax: parallaxOn,
                                          reduceMotion: reduceMotion,
                                          idle: idle,
                                          mobile: mobile,
                                          customCursor: customCursor,
                                        ),
                                        builder: (context, offset, child) {
                                          return Transform.translate(
                                            offset: offset * 0.18,
                                            child: child,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  if (!mobile)
                                    Positioned(
                                      top: tablet ? 350 : 290,
                                      left: tablet ? 12 : 48,
                                      child: ValueListenableBuilder<Offset>(
                                        valueListenable: _parallax,
                                        child: CursorTarget(
                                          enabled: customCursor,
                                          child: WhoIAmNote(
                                            compact: tablet,
                                            reduceMotion: reduceMotion,
                                            idle: idle,
                                          ),
                                        ),
                                        builder: (context, offset, child) {
                                          return Transform.translate(
                                            offset: offset * 0.35,
                                            child: child,
                                          );
                                        },
                                      ),
                                    ),
                                  if (!mobile)
                                    Positioned(
                                      top: tablet ? 330 : 270,
                                      right: tablet ? 8 : 36,
                                      child: ValueListenableBuilder<Offset>(
                                        valueListenable: _parallax,
                                        child: CursorTarget(
                                          enabled: customCursor,
                                          child: StickyNotesStack(
                                            compact: tablet,
                                            reduceMotion: reduceMotion,
                                            idle: idle,
                                          ),
                                        ),
                                        builder: (context, offset, child) {
                                          return Transform.translate(
                                            offset: offset * -0.28,
                                            child: child,
                                          );
                                        },
                                      ),
                                    ),
                                  if (!shortViewport)
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 12,
                                      child: Center(child: scrollHint),
                                    ),
                                ],
                              ),
                            ),
                            if (mobile) ...[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: CursorTarget(
                                  enabled: customCursor,
                                  child: WhoIAmNote(
                                    compact: true,
                                    expand: true,
                                    reduceMotion: reduceMotion,
                                    idle: idle,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              CursorTarget(
                                enabled: customCursor,
                                child: StickyNotesStack(
                                  compact: true,
                                  reduceMotion: reduceMotion,
                                  idle: idle,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ProjectChips(
                                reduceMotion: reduceMotion,
                                customCursor: customCursor,
                              ),
                            ),
                            if (shortViewport) ...[
                              const SizedBox(height: 16),
                              scrollHint,
                            ],
                            const SizedBox(height: 28),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: FooterMarquee(reduceMotion: reduceMotion),
                            ),
                            WorkSection(
                              scrollOffset: _scrollOffset,
                              reduceMotion: reduceMotion,
                              customCursor: customCursor,
                            ),
                            AboutSection(
                              scrollOffset: _scrollOffset,
                              reduceMotion: reduceMotion,
                              customCursor: customCursor,
                            ),
                            ExperienceSection(
                              scrollOffset: _scrollOffset,
                              reduceMotion: reduceMotion,
                              customCursor: customCursor,
                            ),
                            SkillsSection(
                              scrollOffset: _scrollOffset,
                              reduceMotion: reduceMotion,
                              customCursor: customCursor,
                            ),
                            EducationSection(
                              scrollOffset: _scrollOffset,
                              reduceMotion: reduceMotion,
                              customCursor: customCursor,
                            ),
                            ContactSection(
                              scrollOffset: _scrollOffset,
                              reduceMotion: reduceMotion,
                              customCursor: customCursor,
                            ),
                            SiteFooter(
                              onBackToTop: _scrollToTop,
                              reduceMotion: reduceMotion,
                              customCursor: customCursor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                StickyNav(
                  visible: _navVisible,
                  activeSection: _activeSection,
                  onNavigate: _scrollToSection,
                  customCursor: customCursor,
                  mobile: mobile,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
