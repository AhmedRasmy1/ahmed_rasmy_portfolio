import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_typography.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';

/// Lightweight Dart snippet viewer — line numbers, copy, own horizontal scroll.
class DartCodeViewer extends StatelessWidget {
  const DartCodeViewer({
    super.key,
    required this.code,
    this.customCursor = false,
  });

  final String code;
  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final lines = code.replaceAll('\t', '  ').split('\n');
    final lineNoWidth = '${lines.length}'.length;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.navyInk,
        border: Border.all(
          color: AppColors.flutterBlue.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: CursorTarget(
              enabled: customCursor,
              child: TextButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: code));
                },
                child: Text(
                  AppTypography.displayCase(context, 'Copy'),
                  style: AppTypography.label(
                    context,
                    fontSize: 10,
                    color: AppColors.flutterLightBlue,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 280),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < lines.length; i++)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 12.0 + lineNoWidth * 8,
                          child: Text(
                            '${i + 1}'.padLeft(lineNoWidth),
                            style: GoogleFonts.spaceMono(
                              fontSize: 11,
                              height: 1.45,
                              color: AppColors.offWhite.withValues(alpha: 0.35),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          lines[i].isEmpty ? ' ' : lines[i],
                          style: GoogleFonts.spaceMono(
                            fontSize: 12,
                            height: 1.45,
                            color: AppColors.offWhite.withValues(alpha: 0.92),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
