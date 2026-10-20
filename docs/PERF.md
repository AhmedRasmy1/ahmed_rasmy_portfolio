# Flutter Web performance baseline

Guidelines locked for this portfolio. Measure before optimizing further.

## Build targets

Prefer **Wasm (skwasm)** for modern browsers:

```bash
flutter build web --wasm --release
```

CanvasKit remains the fallback path when Wasm is unavailable:

```bash
flutter build web --release
```

Ship **release** builds for any public demo or Lighthouse run. Profile on throttled 4G.

## Deferred loading

- Project detail UI is loaded via `deferred as` in `lib/app/router/app_router.dart`.
- Add new heavy modules (case-study media, complex animation packs) the same way.
- Keep `main.dart` → `PortfolioApp` → home route free of large asset graphs.

## Asset & font budget

| Budget | Rule |
|--------|------|
| Hero / first viewport images | WebP or AVIF; explicit width/height; no 4K PNG |
| Fonts | Max 1–2 families; subset weights actually used |
| Icons | Prefer tree-shaken Material subset or SVG; avoid shipping unused icon fonts |
| Lottie / video | Not on first viewport; defer with the route that needs them |

Declare fonts in `pubspec.yaml` only when real faces are added. Until then, use the platform/Material defaults to keep download size down.

## Runtime

- Watch `settingsProvider` only at `MaterialApp.router` (already done in `lib/app/app.dart`).
- Features read `Theme.of` / `AppLocalizations.of`, not settings, unless changing settings.
- Add `RepaintBoundary` only after DevTools paint profiling shows thrash.
- Dispose continuous `AnimationController`s; do not leave tickers running on background tabs.

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

Compete on interaction craft. Expect static Astro/Next sites to win raw LCP; keep Flutter competitive with Wasm, deferred routes, and a lean asset/font budget.
