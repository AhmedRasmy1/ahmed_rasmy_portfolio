# Architecture

Feature-first Flutter Web portfolio. See the architecture plan for rationale.

```text
lib/
  main.dart                 # Prefs hydrate → ProviderScope → PortfolioApp
  app/
    app.dart                # MaterialApp.router (theme + locale)
    router/                 # go_router + SEO observer + deferred detail
    theme/
    settings/               # Riverpod ThemeMode + Locale
    l10n/                   # ARB + generated localizations
  core/                     # Thin shared constants, utils, chrome widgets
  features/                 # home, projects, about, contact
  data/                     # models + JSON content
```

## Stack

- **State:** `flutter_riverpod` (`settingsProvider`)
- **Routing:** `go_router` path URLs (`/`, `/projects`, `/projects/:id`, …)
- **Persistence:** `shared_preferences` (theme + locale override)
- **L10n:** official gen-l10n (`en` + `ar`, RTL-ready)
- **SEO Phase 1:** `web/index.html` meta + JSON-LD, `robots.txt`, `sitemap.xml`, in-app title updates

## Content

Edit `assets/content/*.json` rather than hardcoding copy in widgets.
