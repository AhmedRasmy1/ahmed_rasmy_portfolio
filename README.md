# Ahmed Rasmy — Flutter Zine Portfolio

Single-page Flutter Web portfolio with a punk zine / scrapbook layout, themed entirely around **Flutter brand blues**, Dash the mascot, EN/AR + RTL, and dark-by-default theming.

Performance targets: steady **60 FPS** via a shared idle ticker, `RepaintBoundary`s, GPU-friendly transforms, precached fonts/images, and reduced-motion support.

## Run

```bash
flutter pub get
flutter run -d chrome
```

## Release builds (recommended)

Wasm (best when supported):

```bash
flutter build web --wasm --release
```

CanvasKit fallback:

```bash
flutter build web --web-renderer canvaskit --release
```

Serve `build/web` with SPA rewrites (`**` → `/index.html`).

## Assets

```text
assets/images/
  ahmed_rasmy_image.png   # portrait cutout
  dash.png                # Flutter Dash
  grain.png               # film grain tile
```

## Customize copy

Edit [`lib/app/l10n/app_en.arb`](lib/app/l10n/app_en.arb) and [`lib/app/l10n/app_ar.arb`](lib/app/l10n/app_ar.arb), then:

```bash
flutter gen-l10n
```

Colors live in [`lib/app/theme/app_colors.dart`](lib/app/theme/app_colors.dart) (`AppColors` + `ZineColors` ThemeExtension).

## Stack

- Riverpod (theme / locale / shared idle ticker)
- go_router
- google_fonts (Bebas Neue, Permanent Marker, Space Mono, Kalam, Cairo, Reem Kufi)
- flutter_animate (intro only; idle uses one shared `Ticker`)
