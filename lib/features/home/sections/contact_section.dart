import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/navigation/home_sections.dart';
import 'package:ahmed_rasmy_portfolio/core/painters/hand_drawn_painter.dart';
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
            if (narrow) ...[
              _SayHiCluster(customCursor: customCursor),
              const SizedBox(height: 20),
              _Postcard(customCursor: customCursor),
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _SayHiCluster(customCursor: customCursor),
                  ),
                  const SizedBox(width: 28),
                  Expanded(
                    flex: 5,
                    child: _Postcard(customCursor: customCursor),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _SayHiCluster extends StatelessWidget {
  const _SayHiCluster({required this.customCursor});

  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 180,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 8,
            top: 20,
            child: CustomPaint(
              size: const Size(100, 80),
              painter: CurvedArrowPainter(
                color: AppColors.flutterLightBlue.withValues(alpha: 0.9),
              ),
            ),
          ),
          Positioned(
            left: 70,
            top: 70,
            child: CursorTarget(
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
                        style: GoogleFonts.kalam(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navyInk,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
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

class _Postcard extends StatefulWidget {
  const _Postcard({required this.customCursor});

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
              l10n.contactPostcardFrom,
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                letterSpacing: 1.6,
                fontWeight: FontWeight.w700,
                color: AppColors.flutterBlue,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              PortfolioData.fullName.toUpperCase(),
              style: GoogleFonts.bebasNeue(
                fontSize: 28,
                letterSpacing: 1.2,
                color: AppColors.navyInk,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 1,
              color: AppColors.paperEdge,
            ),
            const SizedBox(height: 18),
            Text(
              '${l10n.contactPostcardTo}:',
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                letterSpacing: 1.4,
                color: zine.inkMuted,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _ContactAction(
                  label: l10n.contactEmail,
                  value: PortfolioData.email,
                  customCursor: widget.customCursor,
                  trailing: _copied ? l10n.contactCopied : null,
                  onTap: _copyEmail,
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
            constraints: const BoxConstraints(minWidth: 180),
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.w700,
                        color: AppColors.flutterBlue,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: 8),
                      AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          trailing!,
                          style: GoogleFonts.spaceMono(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.flutterLightBlue,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  shortValue ?? value,
                  style: GoogleFonts.kalam(
                    fontSize: 15,
                    color: AppColors.navyInk,
                    decoration: TextDecoration.none,
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
