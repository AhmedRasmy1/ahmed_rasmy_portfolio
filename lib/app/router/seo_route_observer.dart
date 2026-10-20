import 'package:flutter/material.dart';

import 'package:ahmed_rasmy_portfolio/core/constants/app_constants.dart';
import 'package:ahmed_rasmy_portfolio/core/utils/seo_document.dart';

/// Syncs document title / description when routes change (Phase 1 SEO).
class SeoRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _apply(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) _apply(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) _apply(previousRoute);
  }

  void _apply(Route<dynamic> route) {
    final name = route.settings.name;
    final meta = _metaForRoute(name);
    updateDocumentTitle(meta.title);
    updateMetaDescription(meta.description);
  }

  static ({String title, String description}) _metaForRoute(String? name) {
    final path = name ?? '/';
    if (path.startsWith('/projects/')) {
      return (
        title: '${AppConstants.siteName} — Project',
        description: AppConstants.siteDescription,
      );
    }
    return switch (path) {
      '/projects' => (
          title: '${AppConstants.siteName} — Projects',
          description: 'Selected Flutter and mobile projects by Ahmed Rasmy.',
        ),
      '/about' => (
          title: '${AppConstants.siteName} — About',
          description: 'About Ahmed Rasmy, Flutter developer.',
        ),
      '/contact' => (
          title: '${AppConstants.siteName} — Contact',
          description: 'Contact Ahmed Rasmy.',
        ),
      _ => (
          title: '${AppConstants.siteName} — Portfolio',
          description: AppConstants.siteDescription,
        ),
    };
  }
}
