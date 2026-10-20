import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/portfolio_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/l10n/skill_copy.dart';
import 'package:ahmed_rasmy_portfolio/core/navigation/home_sections.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/paper_card.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/section_header.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({
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

    return KeyedSubtree(
      key: HomeSectionKeys.key(HomeSection.education),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 72),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              number: HomeSection.education.numberLabel,
              eyebrow: l10n.secEducationEyebrow,
              title: l10n.secEducationTitle,
              intro: l10n.secEducationIntro,
              scrollOffset: scrollOffset,
              reduceMotion: reduceMotion,
            ),
            const SizedBox(height: 32),
            _DiplomaCard(customCursor: customCursor),
            const SizedBox(height: 28),
            for (var i = 0; i < PortfolioData.courses.length; i++) ...[
              if (i > 0) const SizedBox(height: 14),
              _CertificateTicket(
                course: PortfolioData.courses[i],
                tilt: ((i % 2 == 0) ? -1 : 1) * 0.012,
                customCursor: customCursor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DiplomaCard extends StatelessWidget {
  const _DiplomaCard({required this.customCursor});

  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final edu = PortfolioData.education;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return CursorTarget(
      enabled: customCursor,
      child: PaperCard(
        tilt: -0.01,
        tapeColor: AppColors.flutterLightBlue.withValues(alpha: 0.85),
        padding: const EdgeInsets.fromLTRB(22, 36, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.eduSchool,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 32,
                      letterSpacing: 1.2,
                      color: AppColors.navyInk,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: -0.06,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.flutterBlue,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      l10n.eduCertificateStamp,
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.w700,
                        color: AppColors.flutterBlue,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              height: 2,
              width: 64,
              color: AppColors.flutterLightBlue.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.eduDegree,
              style: (isAr
                      ? GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navyInk,
                        )
                      : GoogleFonts.kalam(
                          fontSize: 18,
                          color: AppColors.navyInk,
                        ))
                  .copyWith(decoration: TextDecoration.none),
            ),
            const SizedBox(height: 18),
            _DiplomaRow(
              label: l10n.eduYearsLabel,
              value: '${edu.start} — ${edu.end}',
            ),
            const SizedBox(height: 10),
            _DiplomaRow(label: l10n.eduGradeLabel, value: l10n.eduGrade),
            const SizedBox(height: 10),
            _DiplomaRow(
              label: l10n.eduProjectLabel,
              value: l10n.eduProject,
            ),
          ],
        ),
      ),
    );
  }
}

class _DiplomaRow extends StatelessWidget {
  const _DiplomaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.spaceMono(
              fontSize: 10,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
              color: AppColors.flutterBlue,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.spaceMono(
              fontSize: 12,
              height: 1.4,
              color: AppColors.navyInk,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _CertificateTicket extends StatelessWidget {
  const _CertificateTicket({
    required this.course,
    required this.tilt,
    required this.customCursor,
  });

  final Course course;
  final double tilt;
  final bool customCursor;

  Future<void> _open(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = CourseCopy.title(l10n, course);
    final org = CourseCopy.org(l10n, course);
    final hasLink = !isTodo(course.url);

    return CursorTarget(
      enabled: customCursor,
      child: Transform.rotate(
        angle: tilt,
        child: CustomPaint(
          painter: const _TicketPainter(),
          child:             Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (org != null) ...[
                      Text(
                        org.toUpperCase(),
                        style: GoogleFonts.spaceMono(
                          fontSize: 11,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w700,
                          color: AppColors.flutterBlue,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const Spacer(),
                    ] else
                      const Spacer(),
                    Transform.rotate(
                      angle: -0.05,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                AppColors.flutterBlue.withValues(alpha: 0.7),
                          ),
                          color: AppColors.flutterLightBlue
                              .withValues(alpha: 0.1),
                        ),
                        child: Text(
                          l10n.eduCertificateStamp,
                          style: GoogleFonts.spaceMono(
                            fontSize: 9,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w700,
                            color: AppColors.flutterBlue,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: GoogleFonts.kalam(
                    fontSize: 15,
                    height: 1.35,
                    color: AppColors.navyInk,
                    decoration: TextDecoration.none,
                  ),
                ),
                if (hasLink) ...[
                  const SizedBox(height: 10),
                  CursorTarget(
                    enabled: customCursor,
                    child: GestureDetector(
                      onTap: () => _open(course.url!),
                      child: Text(
                        l10n.eduViewCert,
                        style: GoogleFonts.spaceMono(
                          fontSize: 11,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                          color: AppColors.flutterBlue,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TicketPainter extends CustomPainter {
  const _TicketPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = _ticketPath(size);
    canvas.drawPath(path, Paint()..color = AppColors.paper);
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.paperEdge
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Perforation dashes along the tear line.
    final dash = Paint()
      ..color = AppColors.flutterBlue.withValues(alpha: 0.4)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    for (var y = 12.0; y < size.height - 10; y += 10) {
      canvas.drawLine(Offset(14, y), Offset(14, y + 4), dash);
    }

    // Soft bottom shadow.
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.navyInk.withValues(alpha: 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Mini tape accent.
    canvas.save();
    canvas.translate(size.width - 40, 4);
    canvas.rotate(0.1);
    canvas.drawRect(
      const Rect.fromLTWH(-22, -5, 44, 11),
      Paint()..color = const Color(0xE6A8C8E0),
    );
    canvas.restore();
  }

  Path _ticketPath(Size size) {
    const stub = 16.0;
    const notchR = 5.0;
    final path = Path()..moveTo(stub, 0);
    path.lineTo(size.width - 3, 0);
    path.lineTo(size.width, 3);
    path.lineTo(size.width, size.height - 3);
    path.lineTo(size.width - 3, size.height);
    path.lineTo(stub, size.height);

    // Scalloped perforation (bottom → top).
    var y = size.height;
    while (y > notchR) {
      final next = (y - notchR * 2).clamp(0.0, size.height);
      path.arcToPoint(
        Offset(stub, next),
        radius: const Radius.circular(notchR),
        clockwise: false,
      );
      y = next;
    }
    path.lineTo(stub, 0);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
