# Ahmed Rasmy Portfolio

Flutter Web personal portfolio — feature-first architecture with Riverpod, go_router, gen-l10n, and a Phase 1 SEO HTML shell.

## Docs

- [Architecture](docs/ARCHITECTURE.md)
- [Performance baseline](docs/PERF.md)

## Run

```bash
flutter pub get
flutter run -d chrome
```

## Release (Wasm preferred)

```bash
flutter build web --wasm --release
```

Serve `build/web` behind SPA rewrites (all routes → `index.html`). Update `https://ahmedrasmy.dev` in `web/index.html`, `web/robots.txt`, `web/sitemap.xml`, and `lib/core/constants/app_constants.dart` when the production domain is final.
