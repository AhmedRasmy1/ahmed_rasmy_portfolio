import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';

/// Shared chrome for feature placeholders. Keep lean — not a design system yet.
class SiteScaffold extends StatelessWidget {
  const SiteScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.leading,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: leading,
        actions: actions,
      ),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexForPath(location),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
            case 1:
              context.go('/projects');
            case 2:
              context.go('/about');
            case 3:
              context.go('/contact');
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.homeTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.work_outline),
            selectedIcon: const Icon(Icons.work),
            label: l10n.projectsTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.aboutTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.mail_outline),
            selectedIcon: const Icon(Icons.mail),
            label: l10n.contactTitle,
          ),
        ],
      ),
    );
  }

  static int _indexForPath(String path) {
    if (path.startsWith('/projects')) return 1;
    if (path.startsWith('/about')) return 2;
    if (path.startsWith('/contact')) return 3;
    return 0;
  }
}
