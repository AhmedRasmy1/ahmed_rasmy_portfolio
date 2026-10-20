import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahmed_rasmy_portfolio/app/l10n/generated/app_localizations.dart';
import 'package:ahmed_rasmy_portfolio/app/router/seo_route_observer.dart';
import 'package:ahmed_rasmy_portfolio/features/about/about_page.dart';
import 'package:ahmed_rasmy_portfolio/features/contact/contact_page.dart';
import 'package:ahmed_rasmy_portfolio/features/home/home_page.dart';
import 'package:ahmed_rasmy_portfolio/features/projects/projects_page.dart';
import 'package:ahmed_rasmy_portfolio/features/projects/project_detail_page.dart'
    deferred as project_detail;

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    observers: [SeoRouteObserver()],
    routes: [
      GoRoute(
        path: '/',
        name: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/projects',
        name: '/projects',
        builder: (context, state) => const ProjectsPage(),
        routes: [
          GoRoute(
            path: ':id',
            name: '/projects/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return _DeferredProjectDetail(projectId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/about',
        name: '/about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: '/contact',
        name: '/contact',
        builder: (context, state) => const ContactPage(),
      ),
    ],
  );
});

/// Loads [project_detail] via deferred import to shrink the initial bundle.
class _DeferredProjectDetail extends StatefulWidget {
  const _DeferredProjectDetail({required this.projectId});

  final String projectId;

  @override
  State<_DeferredProjectDetail> createState() => _DeferredProjectDetailState();
}

class _DeferredProjectDetailState extends State<_DeferredProjectDetail> {
  late final Future<void> _library = project_detail.loadLibrary();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<void>(
      future: _library,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            body: Center(child: Text(l10n.loadingLabel)),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('${snapshot.error}')),
          );
        }
        return project_detail.ProjectDetailPage(projectId: widget.projectId);
      },
    );
  }
}
