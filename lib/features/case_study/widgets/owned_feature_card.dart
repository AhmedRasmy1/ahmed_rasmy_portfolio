import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_typography.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/host_venue_data.dart';
import 'package:ahmed_rasmy_portfolio/core/cursor/custom_cursor_overlay.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/paper_card.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/widgets/case_layout.dart';
import 'package:ahmed_rasmy_portfolio/features/host_venue/widgets/status_stamp.dart';

/// GatherUp case study — Features I owned card linking to the deep-dive.
class HostVenueOwnedFeatureCard extends StatelessWidget {
  const HostVenueOwnedFeatureCard({
    super.key,
    this.customCursor = false,
  });

  final bool customCursor;

  @override
  Widget build(BuildContext context) {
    final ar = AppTypography.isArabic(context);
    final width = MediaQuery.sizeOf(context).width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ar ? 'ميزات تملّكتها' : 'Features I owned',
          style: AppTypography.label(
            context,
            fontSize: 11,
            color: AppColors.flutterLightBlue,
          ),
        ),
        const SizedBox(height: 12),
        CursorTarget(
          enabled: customCursor,
          child: PaperCard(
            tilt: CaseLayout.tilt(0.02, width: width),
            onTap: () => context.go(kHostVenueRoute),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      HostVenueData.ownedFeatureTitle.t(ar),
                      softWrap: true,
                      style: AppTypography.headline(context, fontSize: 26),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      HostVenueData.ownedFeatureSummary.t(ar),
                      softWrap: true,
                      style: AppTypography.note(
                        context,
                        fontSize: 14,
                        color: AppColors.navyInk,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ar ? 'افتح التعميق ←' : 'Open deep-dive →',
                      style: AppTypography.label(
                        context,
                        fontSize: 11,
                        color: AppColors.flutterBlue,
                      ),
                    ),
                  ],
                ),
                const PositionedDirectional(
                  top: -8,
                  end: -4,
                  child: StatusStamp(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
