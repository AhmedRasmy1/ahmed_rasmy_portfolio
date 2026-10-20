import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/settings_controls.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/site_scaffold.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SiteScaffold(
      title: l10n.aboutTitle,
      actions: const [SettingsControls()],
      body: Center(
        child: Text(
          l10n.aboutTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
