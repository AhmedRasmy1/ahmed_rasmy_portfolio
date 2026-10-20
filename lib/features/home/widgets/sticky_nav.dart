import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/navigation/home_sections.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/theme_locale_toggles.dart';

class StickyNav extends StatelessWidget {
  const StickyNav({
    super.key,
    required this.visible,
    required this.activeSection,
    required this.onNavigate,
    this.customCursor = false,
    this.mobile = false,
  });

  final ValueNotifier<bool> visible;
  final ValueNotifier<HomeSection?> activeSection;
  final ValueChanged<HomeSection> onNavigate;
  final bool customCursor;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final zine = context.zine;
    final l10n = AppLocalizations.of(context);

    return ValueListenableBuilder<bool>(
      valueListenable: visible,
      builder: (context, show, _) {
        return AnimatedSlide(
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeOutCubic,
          offset: show ? Offset.zero : const Offset(0, -1.1),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 280),
            opacity: show ? 1 : 0,
            child: IgnorePointer(
              ignoring: !show,
              child: Material(
                color: zine.canvas.withValues(alpha: 0.94),
                elevation: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: zine.divider, width: 1),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: mobile
                          ? _MobileNavBar(
                              activeSection: activeSection,
                              onNavigate: onNavigate,
                              customCursor: customCursor,
                            )
                          : _DesktopNavBar(
                              activeSection: activeSection,
                              onNavigate: onNavigate,
                              customCursor: customCursor,
                              l10n: l10n,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DesktopNavBar extends StatelessWidget {
  const _DesktopNavBar({
    required this.activeSection,
    required this.onNavigate,
    required this.customCursor,
    required this.l10n,
  });

  final ValueNotifier<HomeSection?> activeSection;
  final ValueChanged<HomeSection> onNavigate;
  final bool customCursor;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _LogoMark(),
        const SizedBox(width: 20),
        Expanded(
          child: ValueListenableBuilder<HomeSection?>(
            valueListenable: activeSection,
            builder: (context, active, _) {
              return Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: [
                  _NavLink(
                    label: l10n.navWork,
                    selected: active == HomeSection.work,
                    onTap: () => onNavigate(HomeSection.work),
                    customCursor: customCursor,
                  ),
                  _NavLink(
                    label: l10n.navAbout,
                    selected: active == HomeSection.about,
                    onTap: () => onNavigate(HomeSection.about),
                    customCursor: customCursor,
                  ),
                  _NavLink(
                    label: l10n.navExperience,
                    selected: active == HomeSection.experience,
                    onTap: () => onNavigate(HomeSection.experience),
                    customCursor: customCursor,
                  ),
                  _NavLink(
                    label: l10n.navSkills,
                    selected: active == HomeSection.skills,
                    onTap: () => onNavigate(HomeSection.skills),
                    customCursor: customCursor,
                  ),
                  _NavLink(
                    label: l10n.navResume,
                    selected: false,
                    onTap: () => context.go('/resume'),
                    customCursor: customCursor,
                  ),
                  _NavLink(
                    label: l10n.navContact,
                    selected: active == HomeSection.contact,
                    onTap: () => onNavigate(HomeSection.contact),
                    customCursor: customCursor,
                  ),
                ],
              );
            },
          ),
        ),
        const ThemeLocaleToggles(),
      ],
    );
  }
}

class _MobileNavBar extends StatefulWidget {
  const _MobileNavBar({
    required this.activeSection,
    required this.onNavigate,
    required this.customCursor,
  });

  final ValueNotifier<HomeSection?> activeSection;
  final ValueChanged<HomeSection> onNavigate;
  final bool customCursor;

  @override
  State<_MobileNavBar> createState() => _MobileNavBarState();
}

class _MobileNavBarState extends State<_MobileNavBar> {
  bool _open = false;

  void _toggle() => setState(() => _open = !_open);

  void _go(HomeSection section) {
    setState(() => _open = false);
    widget.onNavigate(section);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const _LogoMark(),
            const Spacer(),
            const ThemeLocaleToggles(),
            const SizedBox(width: 8),
            CursorTarget(
              enabled: widget.customCursor,
              child: IconButton(
                onPressed: _toggle,
                icon: Icon(_open ? Icons.close : Icons.menu, color: zine.ink),
              ),
            ),
          ],
        ),
        if (_open)
          _PaperMenu(
            activeSection: widget.activeSection,
            customCursor: widget.customCursor,
            onWork: () => _go(HomeSection.work),
            onAbout: () => _go(HomeSection.about),
            onExperience: () => _go(HomeSection.experience),
            onSkills: () => _go(HomeSection.skills),
            onContact: () => _go(HomeSection.contact),
            onResume: () {
              setState(() => _open = false);
              context.go('/resume');
            },
            l10n: l10n,
          ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.05, end: 0),
      ],
    );
  }
}

class _PaperMenu extends StatelessWidget {
  const _PaperMenu({
    required this.activeSection,
    required this.customCursor,
    required this.onWork,
    required this.onAbout,
    required this.onExperience,
    required this.onSkills,
    required this.onContact,
    required this.onResume,
    required this.l10n,
  });

  final ValueNotifier<HomeSection?> activeSection;
  final bool customCursor;
  final VoidCallback onWork;
  final VoidCallback onAbout;
  final VoidCallback onExperience;
  final VoidCallback onSkills;
  final VoidCallback onContact;
  final VoidCallback onResume;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final zine = context.zine;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      decoration: BoxDecoration(
        color: zine.paper,
        boxShadow: [
          BoxShadow(
            color: AppColors.navyInk.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ValueListenableBuilder<HomeSection?>(
        valueListenable: activeSection,
        builder: (context, active, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MenuItem(
                label: l10n.navWork,
                selected: active == HomeSection.work,
                onTap: onWork,
                customCursor: customCursor,
              ),
              _MenuItem(
                label: l10n.navAbout,
                selected: active == HomeSection.about,
                onTap: onAbout,
                customCursor: customCursor,
              ),
              _MenuItem(
                label: l10n.navExperience,
                selected: active == HomeSection.experience,
                onTap: onExperience,
                customCursor: customCursor,
              ),
              _MenuItem(
                label: l10n.navSkills,
                selected: active == HomeSection.skills,
                onTap: onSkills,
                customCursor: customCursor,
              ),
              _MenuItem(
                label: l10n.navResume,
                selected: false,
                onTap: onResume,
                customCursor: customCursor,
              ),
              _MenuItem(
                label: l10n.navContact,
                selected: active == HomeSection.contact,
                onTap: onContact,
                customCursor: customCursor,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.customCursor,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    return CursorTarget(
      enabled: customCursor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            label,
            style: GoogleFonts.bebasNeue(
              fontSize: 28,
              letterSpacing: 1.2,
              color: selected
                  ? AppColors.flutterBlue
                  : AppColors.navyInk,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return Text(
      'AR',
      style: GoogleFonts.permanentMarker(
        fontSize: 22,
        color: AppColors.flutterLightBlue,
        decoration: TextDecoration.none,
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.customCursor,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final zine = context.zine;
    return CursorTarget(
      enabled: customCursor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            label,
            style: GoogleFonts.spaceMono(
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.flutterLightBlue : zine.ink,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
