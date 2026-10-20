import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/settings_controls.dart';
import 'package:ahmed_rasmy_portfolio/core/widgets/site_scaffold.dart';
import 'package:ahmed_rasmy_portfolio/data/content/project_content.dart';
import 'package:ahmed_rasmy_portfolio/data/models/project.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SiteScaffold(
      title: l10n.projectsTitle,
      actions: const [SettingsControls()],
      body: FutureBuilder<List<Project>>(
        future: loadProjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: Text(l10n.loadingLabel));
          }
          final projects = snapshot.data ?? const <Project>[];
          return ListView.separated(
            padding: const EdgeInsetsDirectional.all(24),
            itemCount: projects.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final project = projects[index];
              return ListTile(
                title: Text(project.title),
                subtitle: Text(project.summary),
                onTap: () => context.go('/projects/${project.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
