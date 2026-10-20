import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';

/// Placeholder resume route — content filled in a later step.
class ResumePage extends StatelessWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zine = context.zine;

    return Scaffold(
      backgroundColor: zine.canvas,
      appBar: AppBar(
        backgroundColor: zine.canvas,
        foregroundColor: zine.ink,
        title: Text(
          l10n.navResume,
          style: GoogleFonts.spaceMono(
            fontSize: 13,
            letterSpacing: 1.2,
            decoration: TextDecoration.none,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.sectionPlaceholder,
            textAlign: TextAlign.center,
            style: GoogleFonts.kalam(
              fontSize: 18,
              color: zine.inkMuted,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
