import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/app/theme/app_colors.dart';
import 'package:ahmed_rasmy_portfolio/app/theme/app_typography.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/host_venue_data.dart';

class StatusStamp extends StatelessWidget {
  const StatusStamp({
    super.key,
    this.status = kHostVenueStatus,
  });

  final FeatureStatus status;

  @override
  Widget build(BuildContext context) {
    final ar = AppTypography.isArabic(context);
    return Transform.rotate(
      angle: 0.06,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        color: AppColors.flutterLightBlue,
        child: Text(
          featureStatusStamp(status, ar: ar),
          style: AppTypography.label(
            context,
            fontSize: 10,
            color: AppColors.navyInk,
          ),
        ),
      ),
    );
  }
}
