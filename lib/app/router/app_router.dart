import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahmed_rasmy_portfolio/app/router/seo_route_observer.dart';
import 'package:ahmed_rasmy_portfolio/features/home/home_page.dart';

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
    ],
  );
});
