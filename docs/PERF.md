# Flutter Web performance baseline

Guidelines for this portfolio. Measure before optimizing further.

## Build targets

Prefer **Wasm (skwasm)** for modern browsers when targeting capable clients:

```bash
flutter build web --wasm --release
```

CanvasKit remains the default / fallback path:

```bash
flutter build web --release
```

Ship **release** builds for any public demo or Lighthouse run. Profile on throttled 4G.

## Loading strategy (current)

- Routes are registered eagerly in `lib/app/router/app_router.dart` (`/`, `/work/...`, `/resume`).
- **Deferred library loading is not wired yet.** When adding heavy modules (extra case-study media packs, large animation sets), prefer `deferred as` imports so home stays lean.
- Keep `main.dart` → `PortfolioApp` → home route free of large optional asset graphs; missing assets already hide via `AssetChecker` / `SafeAssetImage`.

## Asset & font budget

| Budget | Rule |
|--------|------|
| Hero / first viewport images | Prefer compressed formats; explicit cacheWidth where helpful; no 4K PNG |
| Fonts | Prefer `AppTypography` families; avoid loading unused Google Fonts on first paint |
| Icons | Prefer tree-shaken Material subset; do not add unused icon font packages |
| Video | Not on first viewport; only on case-study / deep-dive routes that need them |

## Runtime

- Watch `settingsProvider` only at `MaterialApp.router` (already done in `lib/app/app.dart`).
- Features read `Theme.of` / `AppLocalizations.of`, not settings, unless changing settings.
- Custom cursor overlay is **app-level only** (`_CursorShell` in `app.dart`); detail pages use `CursorTarget` without a second overlay.
- Add `RepaintBoundary` only after DevTools paint profiling shows thrash.
- Dispose continuous `AnimationController`s; idle ticker respects reduced motion.

## Hosting cache

| Resource | Cache |
|----------|--------|
| `index.html` | short / no-cache |
| Hashed JS / Wasm / canvaskit / fonts | long immutable (`max-age=31536000, immutable`) |
| `robots.txt`, `sitemap.xml` | moderate |

SPA hosts must rewrite all paths to `index.html` so path-based `go_router` URLs work.

### Firebase Hosting example

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [{ "source": "**", "destination": "/index.html" }],
    "headers": [
      {
        "source": "/index.html",
        "headers": [{ "key": "Cache-Control", "value": "no-cache" }]
      },
      {
        "source": "**/*.@(js|wasm|woff2)",
        "headers": [{ "key": "Cache-Control", "value": "public, max-age=31536000, immutable" }]
      }
    ]
  }
}
```

## Honest target

Compete on interaction craft. Expect static Astro/Next sites to win raw LCP; keep Flutter competitive with Wasm (when enabled), lean assets, and a bounded font budget.
