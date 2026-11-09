# Project Status — Ahmed Rasmy Flutter Web Portfolio

**Audit date:** 2026-11-08  
**Scope:** Read-only audit of the current tree. **No application code was modified** (this doc only).  
**Workspace:** `d:\ahmed_rasmy_portfolio`

---

## 1. Environment

| Item | Result | Evidence |
|------|--------|----------|
| Flutter | **3.44.8** (stable), framework `058e0af2c2` | `flutter --version` |
| Dart | **3.12.2** | `flutter --version` / `dart --version` |
| SDK constraint | `sdk: ^3.12.2` | `pubspec.yaml` |
| Free disk (C:) | **~9.48 GB** free / ~227.7 GB used | `Get-PSDrive C` before clean |
| Pre-clean build dir | ~103.8 MB (removed via `flutter clean`) | shell measure |
| `flutter pub get` | OK | after clean |
| `flutter analyze` | **No issues found** (0 errors, 0 warnings, 0 infos), exit 0 | `analyze_out.txt`, ~39.1s |
| `flutter build web --release` | **Succeeded**, exit 0 | `build_out.txt`, compile ~76.9s |

### Release build size (`build/web`)

| Path / artifact | Size |
|-----------------|------|
| **Total `build/web`** | **~44.61 MB** (69 files) |
| `main.dart.js` | ~2.99 MB |
| `canvaskit/` (engine) | ~36.69 MB |
| App `assets/` in build | ~4.87 MB |
| Wasm dry-run note | Printed; build used default CanvasKit path (not `--wasm`) |

Notes:
- Build printed: *“Wasm dry run succeeded. Consider … `--wasm`”* (see also `docs/PERF.md`).
- CupertinoIcons + MaterialIcons were tree-shaken during build.

---

## 2. Routes and sections that actually exist

### Routes (`lib/app/router/app_router.dart`)

| Path | Name | Widget | Status |
|------|------|--------|--------|
| `/` | `home` | `HomePage` | Present |
| `/work/gatherup/host-venue-mode` | `host-venue-mode` | `HostVenuePage` | Present (registered **before** `/work/:slug`) |
| `/work/:slug` | `case-study` | `CaseStudyPage(slug:)` | Present; only `gatherup` has `CaseStudy` data |
| `/resume` | `resume` | `ResumePage` | Present |

SEO observer: `SeoRouteObserver` attached.

> `docs/ARCHITECTURE.md` / `docs/PERF.md` still mention deferred `/projects` routes — **outdated** vs current router (no `deferred as`, paths are `/work/...`).

### Home (`/`) — hero + nav + 01–06

Evidence: `lib/features/home/home_page.dart`, `lib/core/navigation/home_sections.dart`.

| Piece | Status | File evidence |
|-------|--------|---------------|
| Hero (masthead, headline, portrait, notes, chips, marquee) | **Implemented** | `home_page.dart`, `masthead_bar.dart`, `hero_headline.dart`, `portrait_sticker.dart`, … |
| Sticky nav | **Implemented** | `sticky_nav.dart`; appears after scroll > 200 |
| **01 Work** | **Implemented** | `WorkSection` + `HomeSection.work` |
| **02 About** | **Implemented** | `AboutSection` |
| **03 Experience** | **Implemented** | `ExperienceSection` |
| **04 Skills** | **Implemented** | `SkillsSection` |
| **05 Education** | **Implemented** | `EducationSection` |
| **06 Contact** | **Implemented** | `ContactSection` |
| Footer | **Implemented** | `SiteFooter` |

`SectionPlaceholder` (`lib/features/home/sections/section_placeholder.dart`) is **dead code** (no imports).

### `/resume`

Implemented printable/download resume UI; PDF download via `AssetPaths.resumePdf` (`lib/features/resume/resume_page.dart`).

### `/work/gatherup` — case study 7A–7D

Shell comment: *“7A–7D shell through Closing”* (`case_study_page.dart`).  
Section IDs + data comments in `portfolio_data.dart` (`// ── 7B ──` … `7D`).

| Sub-step | What it covers | Widget(s) | Data / UI status |
|----------|----------------|-----------|------------------|
| **7A** | Hero shell, nav, progress rail/bar, meta stickers | `_CaseStudyHero`, `CaseStudyNav`, `CaseStudyProgress*` | **Implemented**. Hero image gated by `AssetChecker` (`gatherup/hero.png` **exists**). |
| **7B** | Problem + compare + story strip; Product loop; Thinking Q&A | `CaseProblemSection`, `CaseLoopSection`, `CaseThinkingSection`, `CaseStoryStrip` | **Structure implemented**. Story JPG paths referenced but **folder empty**. Thinking **answers** are `TODO_REPLACE` → answer panel stays empty when selected. Loop titles/details present in ARB. |
| **7C** | Experience videos; Design system; Motion; Design→code | `CaseExperienceSection`, `CaseSystemSection`, `CaseMotionSection`, `CaseCodeSection` | **Structure implemented**. All referenced **videos/posters missing**. Many role/challenge copy keys still `TODO_REPLACE`. `codeClosing` is `TODO_REPLACE` (hidden). `respectsReduceMotion: true` in data. |
| **7D** | Iteration; Coming next; Results; Closing | `CaseIterationSection`, `CaseComingNextSection`, `CaseResultsSection`, `CaseClosingSection` | **Partial.** Iteration bodies all `TODO_REPLACE` → **section hides**. Coming next: Host & Venue **full** card + deep-dive route; feat2/feat3 `hidden`. Results: all `CaseStudyStat.value` **null** + empty bars → **section hides** (no fake 100K+). Closing note/icon wired. |

Non-GatherUp slugs → “coming soon” empty state (`case_study_page.dart`).

### `/work/gatherup/host-venue-mode`

**Implemented** large deep-dive (`host_venue_page.dart` + `host_venue_data.dart`): Hero, Receipts/ownership, Overview + roles, Flows, Decisions, Isolation, Architecture diagrams, Code, Quality, Learnings (filtered), Gallery (assets missing → empty gracefully via `AssetChecker`).

---

## 3. Content

### Where data lives

| Layer | Location | Role |
|-------|----------|------|
| Structure / facts / IDs | `lib/core/constants/portfolio_data.dart` | Projects, experience dates, skills lists, case-study graph, `TODO_*` markers |
| Host & Venue | `lib/core/constants/host_venue_data.dart` | **Bilingual `LocalizedText` hard-coded** (not ARB) |
| Host diagrams | `lib/core/diagrams/host_venue_diagrams.dart` | Diagram models |
| Asset path constants | `lib/core/constants/asset_paths.dart` | Portrait, dash, grain, resume PDF |
| EN/AR UI copy | `lib/app/l10n/app_en.arb`, `app_ar.arb` → generated under `lib/app/l10n/generated/` | gen-l10n |
| Key resolvers | `lib/core/l10n/{project,experience,skill,case_study}_copy.dart` | Map keys → `AppLocalizations` |
| Dead JSON path | `assets/content/projects.json` + `lib/data/content/project_content.dart` + `lib/data/models/project.dart` | **Unused** by UI; JSON is generic fake samples (“E-Commerce App”, etc.) |

Architecture doc says *“Edit `assets/content/*.json`”* — **not true for the live UI**, which uses `PortfolioData` + ARB.

### Placeholders / suspicious values

| Kind | Examples | Evidence |
|------|----------|----------|
| `TODO_REPLACE` (ARB) | Thinking answers A1–A6; iteration 1–3; feat2/3; code closing; many role/challenge/learn strings | `app_en.arb` / `app_ar.arb` (~45–46 matches each) |
| `TODO_NAMES` | Credit / system credit strings | ARB |
| `TODO_URL` | LinkedIn, GitHub socials; Awwaab Play Store; all course URLs | `portfolio_data.dart` |
| `TODO_REPLACE` tech | ServiceX `tech: [kTodoReplace]` | `portfolio_data.dart` |
| Host Venue `TODO_REPLACE` | Challenge `learned` lines | `host_venue_data.dart` |
| Conflicting EST years | Masthead `estYear` = **EST. 2026**; Who-I-Am badge `estBadge` = **EST. 2024 · FLUTTER** | `app_en.arb` |
| Fake metrics in results | **Avoided** — stats have `value: null`; UI hides section | `portfolio_data.dart` + `case_results_section.dart` |
| Dead JSON fakes | Unrelated sample projects | `assets/content/projects.json` |
| Host Venue commit counts | Specific integers (8, 15, 18, …) — appear intentional ownership receipts, not “100K+” vanity | `host_venue_data.dart` |

UI generally uses `isTodo(...)` to **hide** TODO blocks (good). Visible TODOs that still leak: strings containing `TODO_NAMES` inside otherwise-real credit sentences.

### Hard-coded text in widgets / data (not ARB)

- **Entire Host & Venue copy** in `host_venue_data.dart` (`LocalizedText('…','…')`).
- **Skill / tech labels** as English string literals in `PortfolioData.skillGroups` / project `tech` lists (icons mapped in `skill_copy.dart`).
- **Case hero tags** e.g. `'Product', 'Flutter', …` in `portfolio_data.dart`.
- **Contact / identity facts:** `PortfolioData.fullName`, email, phone, location used directly (e.g. resume page).
- Occasional English fallbacks in widgets (e.g. `'Preview'` in `case_coming_next_section.dart`).
- Many widgets still call `GoogleFonts.*` directly instead of only `AppTypography` (Latin-only styles can show on Arabic locale for those call sites).

---

## 4. Assets

### `pubspec.yaml` registered folders

```
assets/content/
assets/images/ (+ about, experience, logos)
assets/images/projects/gatherup/ (+ story, screens, posters, host-venue)
assets/images/projects/{awwaab,elmohandes,flowery,servicex}/
assets/videos/gatherup/
assets/icons/
assets/resume/
```

### Referenced by code vs files on disk

**Present (real files):**

| Path | Used as |
|------|---------|
| `assets/images/ahmed_rasmy_image.png` (+ `.jpg` fallback) | Portrait |
| `assets/images/dash.png` | Dash peek |
| `assets/images/grain.png` (+ unused sibling `.jpg`) | Zine grain |
| `assets/images/portrait.jpg` | Orphan? not in `AssetPaths` |
| `assets/images/logos/{gatherup,centerly,elevate}.png` | Experience / closing |
| `assets/images/projects/gatherup/hero.png` | Work + case hero |
| `assets/resume/Ahmed_Hisham_Rasmy_Resume.pdf` | Resume download |
| `assets/content/projects.json` | Only dead `loadProjects()` |

**Referenced but missing** (dirs empty / `.gitkeep` only) — relying on `AssetChecker` / `SafeAssetImage` to hide:

- Experience photos `assets/images/experience/*_0{1,2,3}.jpg`
- About strip `assets/images/about/about_0{1..4}.jpg`
- Project heroes/covers for awwaab, elmohandes, flowery, servicex
- GatherUp story `story/01.jpg`–`04.jpg`
- All GatherUp posters + videos under `posters/` and `assets/videos/gatherup/`
- Host-venue gallery shots under `host-venue/`
- Skill icons `assets/icons/*.png` (mapping exists; folder empty)

### `AssetChecker` / `SafeAssetImage` usage

| Pattern | Status |
|---------|--------|
| `AssetChecker.init()` in `main.dart` | Yes |
| Image UI via `SafeAssetImage` | Home portrait/grain/about/experience/skills/work hero; case story/closing; host-venue gallery; lazy video posters |
| Direct `Image.asset` | Only inside `SafeAssetImage` implementation |
| Precache `AssetImage(...)` | `main.dart` after `AssetChecker.has` |
| Video | `VideoPlayerController.asset` after `AssetChecker.has` (`lazy_hover_video.dart`) |
| Gaps | SVG not used; no raw `Image.asset` outside the safe wrapper found |

---

## 5. Known bug checklist

| Item | Status | Evidence / notes |
|------|--------|------------------|
| **IntrinsicHeight + LayoutBuilder** | **Not present** | Grep: only comments saying *never* / *no IntrinsicHeight*; many `LayoutBuilder`s alone |
| **Console exceptions on load / scroll** | **Not runtime-verified this audit** | Analyze clean; no browser console capture run. Risk: post-frame measure/`setState` in loop + contact arrow while scrolling |
| **Overflow @ 320 / 390 / 768 / 1024 / 1440** | **Not runtime-verified** | Breakpoints: home `600`/`1024` (`breakpoints.dart`); case `600`/`700`/`900` (`case_layout.dart`). **Highest static risk:** hero absolute stack + notes at ≤390; EST badge `Positioned(left: -18, bottom: -26)` (`who_i_am_note.dart`); dense sticky nav / case rail |
| **RTL issues** | **Partially handled, not fully verified** | Loop + contact arrow take `Directionality`; `AppTypography.displayCase` skips Arabic uppercase. Risk: raw `GoogleFonts.bebasNeue` / `spaceMono` on AR locale (resume, case hero English fonts when `isAr` branches miss a call site); Host Venue mostly uses `AppTypography` |
| **Arabic font setup** | **Present** | `AppTypography.preload()` loads Lalezar, Reem Kufi, Marhey, Rakkas, Playpen Sans, Tajawal, IBM Plex Sans Arabic, Cairo (`app_typography.dart`). Runtime download via `google_fonts` (network/cache) |
| **Cursor on touch** | **Disabled by design** | `_CursorShell` in `app.dart`: custom cursor only if `kIsWeb && !touch && !reduceMotion && !mobile`. Touch heuristic: shortestSide &lt; 600 or iOS/Android |
| **Loop connector** | **Implemented; fragile** | `case_loop_section.dart`: measures node centers post-frame into `setState`; CustomPaint path with RTL/mobile. Missing media doesn’t break it; empty centers early-return |
| **Contact arrow** | **Implemented; may no-op** | `contact_section.dart`: paints only if progress & distance thresholds met; skipped when `narrow && dist < 36` |
| **EST badge overlap** | **Likely residual risk** | Starburst badge overhangs torn note (`who_i_am_note.dart`); year conflict 2024 vs 2026 amplifies “wrong” feel even if layout OK |
| **Double cursor overlay** | **Bug/smell** | `CustomCursorOverlay` in `app.dart` **and again** in `case_study_page.dart` / `host_venue_page.dart` → possible double ring on detail routes |

---

## 6. Features vs spec

| Feature | Present? | Evidence |
|---------|----------|----------|
| Comic burst | **Yes** | `ComicBurst` on home portrait + case hero |
| Custom cursor | **Yes (desktop web)** | `CursorController` + `CustomCursorOverlay` + `CursorTarget`; disabled mobile/touch/reduced-motion |
| Scroll hint | **Yes** | `ScrollHint` → Work section |
| Theme toggle | **Yes** | `ThemeLocaleToggles` (dark/light; system coerced to dark in `app.dart`) |
| EN/AR toggle | **Yes** | Same widget; `shared_preferences` persistence |
| Animations | **Yes** | `flutter_animate`, idle ticker floats/twinkles, scroll reveals, count-ups |
| Parallax | **Yes** | Home / zine background mouse parallax; disabled mobile + reduced motion |
| Reduced-motion | **Yes** | `MediaQuery.disableAnimationsOf`; idle ticker, parallax, cursor, many section flags |
| Lazy hover video | **Yes (code)** | `lazy_hover_video.dart` — inert until assets exist |
| Architecture diagrams (Host Venue) | **Yes** | `diagram_view.dart` (explicitly avoids IntrinsicHeight) |
| Resume PDF download | **Yes** | Web download util + asset PDF |

---

## 7. Dependencies (`pubspec.yaml`)

| Package | Role | Used? |
|---------|------|-------|
| `flutter` / `flutter_web_plugins` | App + URL strategy | Yes |
| `flutter_riverpod` | Settings + router providers | Yes |
| `go_router` | Routes | Yes |
| `shared_preferences` | Persist theme/locale | Yes |
| `flutter_localizations` + `intl` | l10n | Yes (intl mainly via generated l10n) |
| `web` | SEO DOM + file download | Yes (`seo_document_web.dart`, `download_file_web.dart`) |
| `google_fonts` | Typography | Yes (heavy) |
| `flutter_animate` | Entrance / micro motion | Yes |
| `url_launcher` | Mailto / external links | Yes |
| `video_player` | Case-study hover videos | Yes (code path) |
| **`cupertino_icons`** | Icon font | **Unused in Dart** (no `CupertinoIcons` refs; tree-shaken nearly empty) |
| **`flutter_svg`** | SVG rendering | **Unused** (no `package:flutter_svg` / `SvgPicture` imports) |

**Also unused in-tree (not packages):** `lib/data/content/project_content.dart`, `lib/data/models/project.dart`, `section_placeholder.dart`, `assets/content/projects.json` (for live UI).

---

## 8. Top 10 issues (priority order)

1. **Missing media inventory** — Vast majority of referenced experience/about/project/story/poster/video/host-venue/icon assets are absent; case study 7C/7D media and Host Venue gallery are hollow. *First pass: drop or stub only what’s needed for GatherUp hero + Host Venue screenshots; keep `AssetChecker`.*
2. **Case-study copy still `TODO_REPLACE` / `TODO_NAMES`** — Thinking answers, iterations (whole section hidden), credits, code closing, role blurbs. *First pass: replace credits + thinking answers + iteration #1 so 7B/7D aren’t empty shells.*
3. **Social / store / course URLs are `TODO_URL`** — LinkedIn, GitHub, Play Store, course links never open. *First pass: real LinkedIn + GitHub + Awwaab store URL.*
4. **EST year inconsistency (2024 vs 2026)** — Confusing brand fact on the first viewport. *First pass: one canonical year in ARB.*
5. **Dead content pipeline** — `projects.json` / `lib/data/*` unused and misleading vs `PortfolioData`. *First pass: delete or wire one source of truth; update `ARCHITECTURE.md`.*
6. **Unused dependencies** — `flutter_svg`, `cupertino_icons`. *First pass: remove from `pubspec.yaml`.*
7. **Double `CustomCursorOverlay`** on case/host routes. *First pass: keep app-level overlay only.*
8. **Host Venue bilingual hard-coding** outside ARB — diverges from rest of l10n, harder to maintain. *Cleanup later; not blocking launch if copy is final.*
9. **Hero / EST badge / contact-arrow layout risk at narrow widths** — No automated overflow run this audit. *First pass: manual Chrome DevTools pass at 320/390/768 + fix clipping; verify contact arrow draws on desktop RTL.*
10. **Docs drift + font budget** — `PERF.md` promises deferred routes / lean fonts; router isn’t deferred; many Google Fonts families loaded. *First pass: fix docs; optionally trim Arabic/Latin font set to families actually used on first paint.*

### Recommended first cleanup pass (concrete)

1. Fix ARB facts: EST year, LinkedIn/GitHub URLs, `TODO_NAMES` credits.  
2. Remove unused packages + dead `lib/data` + placeholder JSON (or document why kept).  
3. Deduplicate cursor overlay.  
4. Add the **minimum** GatherUp/Host Venue images that the narrative needs; leave the rest missing (safe).  
5. Fill enough case-study copy so Thinking + one Iteration + Closing feel finished.  
6. Manual responsive/RTL smoke at 320 · 390 · 768 · 1024 · 1440 (EN + AR).  
7. Re-run `flutter analyze` + `flutter build web --release` (or `--wasm` per PERF) and record sizes.

---

## Audit limitations

- No interactive browser console capture (load/scroll exceptions unverified).  
- No pixel overflow screenshots at the five widths (static risk only).  
- Disk was tight (~9.5 GB free); artifacts were cleaned before rebuild; current `build/web` ≈ 44.6 MB remains on disk after this audit.
