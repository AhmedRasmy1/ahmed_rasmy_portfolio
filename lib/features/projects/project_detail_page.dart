import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/settings_controls.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/site_scaffold.dart';
import 'package:ahmed_rasmy_portfolio/data/content/project_content.dart';
import 'package:ahmed_rasmy_portfolio/data/models/project.dart';

/// Loaded via deferred import from the router to keep the initial JS/Wasm lean.
class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SiteScaffold(
      title: l10n.projectDetailTitle,
      actions: const [SettingsControls()],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.go('/projects'),
      ),
      body: FutureBuilder<Project?>(
        future: loadProjectById(projectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: Text(l10n.loadingLabel));
          }
          final project = snapshot.data;
          if (project == null) {
            return Center(child: Text(l10n.projectDetailTitle));
          }
          return Padding(
            padding: const EdgeInsetsDirectional.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(project.summary),
              ],
            ),
          );
        },
      ),
    );
  }
}
