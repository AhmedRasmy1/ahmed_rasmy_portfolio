# Architecture

Feature-first Flutter Web portfolio.

```text
lib/
  main.dart                 # Prefs hydrate → ProviderScope → PortfolioApp
  app/
    app.dart                # MaterialApp.router (theme + locale + cursor shell)
    router/                 # go_router + SEO observer
    theme/
    settings/               # Riverpod ThemeMode + Locale
    l10n/                   # ARB + generated localizations (en / ar)
  core/                     # Shared constants, utils, cursor, typography helpers
  features/                 # home, case_study, host_venue, resume
```

## Stack

- **State:** `flutter_riverpod` (`settingsProvider`)
- **Routing:** `go_router` path URLs:
  - `/` — home (hero + sections 01–06)
  - `/work/:slug` — case study (GatherUp today)
  - `/work/gatherup/host-venue-mode` — Host & Venue deep-dive
  - `/resume` — resume page + PDF download
- **Persistence:** `shared_preferences` (theme + locale override)
- **L10n:** official gen-l10n (`en` + `ar`, RTL-ready)
- **SEO Phase 1:** `web/index.html` meta + JSON-LD, `robots.txt`, `sitemap.xml`, in-app title updates

## Content (single source of truth)

| Kind | Where |
|------|--------|
| Structure, IDs, dates, tech lists, case-study graph | `lib/core/constants/portfolio_data.dart` |
| External URLs (LinkedIn, GitHub, Play Store) | `lib/core/constants/social_links.dart` |
| Host & Venue deep-dive copy + receipts | `lib/core/constants/host_venue_data.dart` |
| UI strings (EN / AR) | `lib/app/l10n/app_en.arb`, `app_ar.arb` |
| Key → l10n resolvers | `lib/core/l10n/*_copy.dart` (+ `TodoSafeCopy` hides `TODO_*`) |

Do **not** hardcode user-facing prose in widgets when an ARB key (or HostVenue `LocalizedText`) already exists.
