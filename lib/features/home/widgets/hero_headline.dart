import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';

class HeroHeadline extends StatelessWidget {
  const HeroHeadline({super.key, this.compact = false, this.reduceMotion = false});

  final bool compact;
  final bool reduceMotion;

  static const _noDecor = TextStyle(decoration: TextDecoration.none);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final primarySize = compact ? 52.0 : 92.0;
    final scriptSize = compact ? 40.0 : 68.0;
    final nameSize = compact ? 28.0 : 40.0;

    final primaryStyle = (isAr
            ? GoogleFonts.reemKufi(
                fontSize: primarySize,
                height: 0.95,
                fontWeight: FontWeight.w700,
                color: zine.ink,
              )
            : GoogleFonts.bebasNeue(
                fontSize: primarySize,
                height: 0.9,
                letterSpacing: 2,
                color: zine.ink,
              ))
        .merge(_noDecor);

    final scriptStyle = (isAr
            ? GoogleFonts.reemKufi(
                fontSize: scriptSize,
                height: 1,
                fontWeight: FontWeight.w700,
                color: AppColors.flutterLightBlue,
              )
            : GoogleFonts.permanentMarker(
                fontSize: scriptSize,
                height: 1,
                color: AppColors.flutterLightBlue,
              ))
        .merge(_noDecor);

    Widget wrap(Widget child, {required int delayMs}) {
      if (reduceMotion) return child;
      return child
          .animate()
          .fadeIn(duration: 450.ms, delay: delayMs.ms)
          .slideY(
            begin: 0.3,
            end: 0,
            duration: 500.ms,
            delay: delayMs.ms,
            curve: Curves.easeOutCubic,
          );
    }

    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            wrap(Text(l10n.headlinePrimary, style: primaryStyle), delayMs: 80),
            const SizedBox(width: 8),
            wrap(
              Transform.rotate(
                angle: -0.07,
                child: Text(l10n.headlineScript, style: scriptStyle),
              ),
              delayMs: 220,
            ),
          ],
        ),
        const SizedBox(height: 8),
        wrap(
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: [
              Text(
                l10n.firstName,
                style: (isAr
                        ? GoogleFonts.reemKufi(
                            fontSize: nameSize,
                            fontWeight: FontWeight.w700,
                            color: zine.ink,
                          )
                        : GoogleFonts.bebasNeue(
                            fontSize: nameSize,
                            letterSpacing: 2,
                            color: zine.ink,
                          ))
                    .merge(_noDecor),
              ),
              Transform.rotate(
                angle: -0.05,
                child: Text(
                  l10n.lastName,
                  style: (isAr
                          ? GoogleFonts.reemKufi(
                              fontSize: nameSize * 0.9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.flutterLightBlue,
                            )
                          : GoogleFonts.permanentMarker(
                              fontSize: nameSize * 0.85,
                              color: AppColors.flutterLightBlue,
                            ))
                      .merge(_noDecor),
                ),
              ),
            ],
          ),
          delayMs: 360,
        ),
        const SizedBox(height: 10),
        wrap(
          Text(
            l10n.metaTagline,
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceMono(
              fontSize: compact ? 9 : 11,
              letterSpacing: 1.6,
              color: zine.inkMuted,
              decoration: TextDecoration.none,
            ),
          ),
          delayMs: 460,
        ),
        const SizedBox(height: 6),
        wrap(
          Text(
            l10n.redTagline,
            textAlign: TextAlign.center,
            style: (isAr
                    ? GoogleFonts.reemKufi(
                        fontSize: compact ? 18 : 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.flutterLightBlue,
                      )
                    : GoogleFonts.permanentMarker(
                        fontSize: compact ? 18 : 24,
                        color: AppColors.flutterLightBlue,
                      ))
                .merge(_noDecor),
          ),
          delayMs: 540,
        ),
      ],
    );
  }
}
