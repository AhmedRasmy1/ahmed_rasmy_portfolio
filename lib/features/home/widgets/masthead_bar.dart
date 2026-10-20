import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/features/home/widgets/theme_locale_toggles.dart';

class MastheadBar extends StatelessWidget {
  const MastheadBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final style = GoogleFonts.spaceMono(
      fontSize: 10,
      letterSpacing: 2,
      fontWeight: FontWeight.w700,
      color: zine.ink.withValues(alpha: 0.85),
      decoration: TextDecoration.none,
    );
    final narrow = MediaQuery.sizeOf(context).width < 720;

    return Column(
      children: [
        if (!narrow)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
            child: Row(
              children: [
                Text(l10n.issueNo, style: style),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CustomPaint(
                        painter: FourPointStarPainter(),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(l10n.personalEdition, style: style),
                  ],
                ),
                const Spacer(),
                Text(l10n.locationMeta, style: style),
                const Spacer(),
                Text(l10n.estYear, style: style),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
            child: Text(
              '${l10n.issueNo}  ·  ${l10n.personalEdition}  ·  ${l10n.locationMeta}',
              style: style,
              textAlign: TextAlign.center,
            ),
          ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Divider(color: zine.divider, thickness: 1, height: 28),
              ),
              const SizedBox(width: 12),
              const ThemeLocaleToggles(),
            ],
          ),
        ),
      ],
    );
  }
}

// const painter needs const ctor
class FourPointStarPainter extends CustomPainter {
  const FourPointStarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.flutterLightBlue;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final path = Path()
      ..moveTo(cx, 0)
      ..quadraticBezierTo(cx, cy, size.width, cy)
      ..quadraticBezierTo(cx, cy, cx, size.height)
      ..quadraticBezierTo(cx, cy, 0, cy)
      ..quadraticBezierTo(cx, cy, cx, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
