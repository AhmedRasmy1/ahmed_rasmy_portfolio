import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahmed_rasmy_portfolio/app/router/seo_route_observer.dart';
import 'package:ahmed_rasmy_portfolio/features/case_study/case_study_page.dart';
import 'package:ahmed_rasmy_portfolio/features/home/home_page.dart';
import 'package:ahmed_rasmy_portfolio/features/resume/resume_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    observers: [SeoRouteObserver()],
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/work/:slug',
        name: 'case-study',
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          return CaseStudyPage(slug: slug);
        },
      ),
      GoRoute(
        path: '/resume',
        name: 'resume',
        builder: (context, state) => const ResumePage(),
      ),
    ],
  );
});
