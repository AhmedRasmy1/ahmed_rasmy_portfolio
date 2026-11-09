import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ahmed_rasmy_portfolio/core/constants/app_constants.dart';
import 'package:ahmed_rasmy_portfolio/core/constants/site_config.dart';
import 'package:ahmed_rasmy_portfolio/core/utils/seo_document.dart';

/// Syncs document title / description / canonical when routes change.
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
    final path = _locationOf(route);
    final meta = _metaForPath(path);
    updateDocumentTitle(meta.title);
    updateMetaDescription(meta.description);
    updateCanonicalUrl(_canonicalFor(path));
  }

  static String _locationOf(Route<dynamic> route) {
    final navigator = route.navigator;
    if (navigator != null && navigator.context.mounted) {
      final router = GoRouter.maybeOf(navigator.context);
      if (router != null) {
        final path = router.routerDelegate.currentConfiguration.uri.path;
        if (path.isEmpty) return '/';
        return path;
      }
    }
    return _pathFromRouteName(route.settings.name);
  }

  static String _pathFromRouteName(String? name) {
    if (name == null || name == 'home' || name == '/') return '/';
    if (name == 'resume') return '/resume';
    if (name == 'host-venue-mode') {
      return '/work/gatherup/host-venue-mode';
    }
    if (name == 'case-study') return '/work/gatherup';
    if (name.startsWith('/')) return name;
    return '/';
  }

  static String _canonicalFor(String path) {
    if (path.isEmpty || path == '/') {
      return '${SiteConfig.baseUrl}/';
    }
    return '${SiteConfig.baseUrl}$path';
  }

  static ({String title, String description}) _metaForPath(String path) {
    if (path == '/resume') {
      return (
        title: '${AppConstants.siteName} — Resume',
        description:
            'Resume of Ahmed Hisham Rasmy, Flutter developer in Cairo.',
      );
    }
    if (path == '/work/gatherup/host-venue-mode' ||
        path.endsWith('/host-venue-mode')) {
      return (
        title: '${AppConstants.siteName} — Host & Venue Mode',
        description:
            'Feature deep-dive: Host Mode and Venue Mode operator shells in GatherUp.',
      );
    }
    if (path.startsWith('/work/')) {
      final slug = path.split('/').where((s) => s.isNotEmpty).skip(1).firstOrNull;
      final label = switch (slug) {
        'gatherup' => 'GatherUp',
        _ => 'Case study',
      };
      return (
        title: '${AppConstants.siteName} — $label',
        description:
            'Case study: $label — Flutter product work by Ahmed Hisham Rasmy.',
      );
    }
    return (
      title: '${AppConstants.siteName} — Flutter Developer',
      description: AppConstants.siteDescription,
    );
  }
}
