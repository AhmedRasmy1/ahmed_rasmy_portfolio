# Typography audit (pre-change)

Audit only — no code changes in this document’s snapshot. Goal: unify styles through `AppTypography`, fix Arabic shaping issues, bundle fonts locally.

---

## 1. Families & weights by locale

### English (current)

| Role | Family | Weights observed | Typical use |
|------|--------|------------------|-------------|
| Headline / display | **Bebas Neue** | w700 (family is effectively single-weight display) | Hero lines, section titles, skill stamps, sticky notes titles, case-study numbers |
| Brush / accent | **Permanent Marker** | w700 / default | Accent words (“Ship”), sticky-nav brand brush, Who I Am title (EN), problem quotes |
| Handwritten / note | **Kalam** | default, w700 | Body-ish cards, intros, sticky note body, work blurbs |
| Body (also via theme) | **Kalam** | default | `AppTypography.body`, theme `bodyLarge` / `titleMedium` |
| Mono / labels | **Space Mono** | w700 + letterSpacing 0.6–2.2 | Nav, chips, labels, captions, code chrome, footer |

Theme (`AppTheme._textTheme` EN): Bebas Neue (display*), Permanent Marker (headline*), Kalam (title/bodyLarge), Space Mono (bodyMedium/labelSmall).

### Arabic (current)

| Role | Intended family | Fallbacks in `AppTypography` | Weights | Issues |
|------|-----------------|------------------------------|---------|--------|
| Headline | **Lalezar** | Reem Kufi (catch / many widgets use Reem Kufi **directly**) | w700 (Lalezar ships ~400 only → **faux bold**) | Widgets bypass with Reem Kufi; letterSpacing sometimes non-zero in EN-first styles |
| Brush / accent | **Marhey** | Rakkas (catch only) | w700 | Theme uses Marhey; hero/who-i-am often use **Reem Kufi** instead |
| Handwritten note | **Playpen Sans** (`GoogleFonts.playpenSans`) | Tajawal (catch) | default | Not the dedicated **Playpen Sans Arabic** family; Latin Playpen may lack full Arabic quality |
| Body / labels | **IBM Plex Sans Arabic** | **Cairo** (widely used in widgets) | default / w600 / w700 | Cairo used as AR body/intro outside AppTypography |
| Mono-style labels | IBM Plex Sans Arabic (in AppTypography) | Cairo | w700, letterSpacing forced 0 in AppTypography | Many widgets still call Space Mono with letterSpacing even in AR |

### Preload list today (`AppTypography.preload`)

Runtime-fetched via `google_fonts` (all locales before first frame):

Bebas Neue, Permanent Marker, Space Mono, Kalam, Lalezar, Reem Kufi, Marhey, Playpen Sans, IBM Plex Sans Arabic, Cairo.

Not preloaded but still referenced in catch blocks: Rakkas, Tajawal.

---

## 2. Bypasses of `AppTypography`

### 2a. Direct `GoogleFonts.*` (outside `app_typography.dart` / counted in theme too)

**Theme (should go through AppTypography roles):**

| File | Lines (approx) | Families |
|------|----------------|----------|
| `lib/app/theme/app_theme.dart` | 18–135 | Lalezar, Marhey, IBM Plex Sans Arabic, Bebas Neue, Permanent Marker, Kalam, Space Mono |

**Widgets / features (must route through AppTypography):**

| File | Lines | Families |
|------|-------|----------|
| `lib/features/home/widgets/hero_headline.dart` | 26–152 | Reem Kufi, Bebas Neue, Permanent Marker, Space Mono |
| `lib/features/home/widgets/who_i_am_note.dart` | 84–185 | Reem Kufi, Permanent Marker, Cairo, Kalam, Space Mono |
| `lib/features/home/widgets/sticky_nav.dart` | 351–409 | Bebas Neue, Permanent Marker, Space Mono |
| `lib/features/home/widgets/sticky_notes_stack.dart` | 54–383 | Space Mono, Bebas Neue, Kalam |
| `lib/features/home/widgets/project_chips.dart` | 115 | Space Mono |
| `lib/features/home/widgets/project_image_slot.dart` | 90 | Space Mono |
| `lib/features/home/widgets/masthead_bar.dart` | 15 | Space Mono |
| `lib/features/home/widgets/footer_marquee.dart` | 51 | Space Mono |
| `lib/features/home/widgets/scroll_hint.dart` | 63 | Space Mono |
| `lib/features/home/widgets/theme_locale_toggles.dart` | 84 | Space Mono |
| `lib/features/home/widgets/site_footer.dart` | 50, 91, 167 | Space Mono |
| `lib/features/home/sections/skills_section.dart` | 183, 278 | Bebas Neue, Space Mono |
| `lib/features/home/sections/education_section.dart` | 88–300 | Bebas Neue, Space Mono, Cairo, Kalam |
| `lib/features/home/sections/work_section.dart` | 111–545 | Space Mono, Bebas Neue, Kalam |
| `lib/core/widgets/section_header.dart` | 74–113 | Space Mono, Reem Kufi, Bebas Neue, Cairo, Kalam |
| `lib/core/widgets/safe_asset_image.dart` | 130 | Space Mono |
| `lib/core/cursor/custom_cursor_overlay.dart` | 73 | Space Mono |
| `lib/features/resume/resume_page.dart` | 33–269 | Space Mono, Bebas Neue, Cairo, Kalam |
| `lib/features/case_study/case_study_page.dart` | 130–583 | Kalam, Reem Kufi, Bebas Neue, Permanent Marker, Space Mono |
| `lib/features/case_study/widgets/case_study_nav.dart` | 66–200 | Space Mono, Bebas Neue |
| `lib/features/case_study/widgets/case_story_strip.dart` | 192 | Kalam |
| `lib/features/case_study/widgets/case_problem_section.dart` | 141–247 | Permanent Marker, Bebas Neue, Space Mono, Kalam |
| `lib/features/case_study/widgets/case_thinking_section.dart` | 137, 188 | Space Mono, Kalam |
| `lib/features/case_study/widgets/case_system_section.dart` | 63–367 | Space Mono, Bebas Neue, Kalam, Reem Kufi |
| `lib/features/case_study/widgets/case_code_section.dart` | 159–200 | Kalam, Bebas Neue |
| `lib/features/case_study/widgets/case_results_section.dart` | 238–410 | Bebas Neue, Kalam, Space Mono |
| `lib/features/case_study/widgets/case_iteration_section.dart` | 130–348 | Bebas Neue, Space Mono, Kalam |
| `lib/features/case_study/widgets/case_motion_section.dart` | 147–225 | Space Mono, Bebas Neue, Kalam |
| `lib/features/case_study/widgets/case_coming_next_section.dart` | 131–527 | Kalam, Bebas Neue, Space Mono (+ italic) |
| `lib/features/case_study/widgets/case_closing_section.dart` | 70–228 | Kalam, Space Mono, Bebas Neue |
| `lib/features/case_study/widgets/lazy_hover_video.dart` | 218–333 | Space Mono |
| `lib/features/case_study/widgets/architecture_diagram.dart` | 30, 94 | Space Mono |
| `lib/features/host_venue/widgets/dart_code_viewer.dart` | 71, 82 | Space Mono |

**Already using AppTypography (good):** contact postcard labels (`displayCase` + `label`/`headline`), experience chips (`displayCase`), case loop (`displayCase`), dart code viewer Copy button (`displayCase`).

### 2b. `TextStyle(fontFamily: …)`

None found in `lib/`.

### 2c. `DefaultTextStyle` overrides

| File | Line | Notes |
|------|------|-------|
| `lib/app/app.dart` | 81–82 | `DefaultTextStyle.merge(style: TextStyle(decoration: TextDecoration.none))` — decoration only, OK |
| `lib/features/home/widgets/hero_headline.dart` | 14 | `_noDecor` decoration-only constant |

### 2d. `toUpperCase()` on user-visible text (unsafe for AR)

| File | Line | Text |
|------|------|------|
| `lib/app/theme/app_typography.dart` | 214 | Inside `displayCase` (already gated for AR) |
| `lib/features/home/widgets/project_chips.dart` | 27 | `slug.toUpperCase()` fallback label |
| `lib/features/home/widgets/project_image_slot.dart` | 87 | `label.toUpperCase()` |
| `lib/features/home/sections/education_section.dart` | 175, 239 | `label` / `org` |
| `lib/features/case_study/case_study_page.dart` | 570 | `label` |
| `lib/features/case_study/widgets/case_iteration_section.dart` | 184 | `label` |
| `lib/features/case_study/widgets/case_closing_section.dart` | 106 | `l10n.caseNextLabel` |
| `lib/features/case_study/widgets/case_motion_section.dart` | 203 | timing title |
| `lib/features/case_study/widgets/case_coming_next_section.dart` | 415 | `status` |
| `lib/features/case_study/widgets/case_system_section.dart` | 346 | `label` |
| `lib/features/case_study/widgets/lazy_hover_video.dart` | 330 | `label` |
| `lib/features/resume/resume_page.dart` | 268 | helper uppercases text |

### 2e. `letterSpacing` on text that can be Arabic

- EN Space Mono / Bebas Neue styles applied without locale gate in almost every widget listed above (chips, nav, labels, section numbers).
- Partial gates already exist in `diagram_view.dart` (329, 384, 447: `arabic ? 0 : …`).
- `AppTypography` AR paths already force `letterSpacing: 0`.

### 2f. Italic / synthetic bold risks for Arabic

| File | Line | Issue |
|------|------|-------|
| `case_coming_next_section.dart` | 507 | `fontStyle: FontStyle.italic` on Kalam (can hit AR) |
| Widespread | — | `FontWeight.w700` on Lalezar / single-weight display faces → faux bold |

---

## 3. Font payload & loading today

### How fonts load

1. `main.dart` → `_BootstrapApp._prepare` → `AppTheme.preloadFonts()` → `AppTypography.preload()`.
2. Each `GoogleFonts.*()` call registers a runtime HTTP fetch; `GoogleFonts.pendingFonts()` waits before first portfolio frame (HTML boot shell / `BrandedLoader` stay up).
3. **Nothing is bundled** under `assets/fonts/` for text families. Release `build/web` FontManifest contains only **MaterialIcons** (~8.7 KB shaken).
4. On web, `google_fonts` downloads TTFs from fonts.gstatic.com into a browser cache / asset cache — **runtime network**, FOUT risk if preload fails, and **both** EN+AR families are fetched before first paint (over-fetch for unused locale).

### Current payload estimate

| Item | Size |
|------|------|
| Bundled text fonts in `build/web` | **0** (MaterialIcons only: ~8.7 KB) |
| Runtime fetch (preload list, rough gstatic sizes) | ~1.5–3+ MB depending on cache / which faces resolve — **not in build artifact** |
| `tool/size_report.dart` total `build/web` | ~43.7 MB (mostly CanvasKit / `main.dart.js` / images — fonts not included in that total) |

Exact per-family byte counts for runtime fetches are not present in `build/web`; after bundling, measure `assets/fonts/**` and re-run size report.

---

## 4. Target roles (for the hardening pass)

| Role | EN (keep look) | AR (required) |
|------|----------------|---------------|
| Display / headline | Bebas Neue | **Lalezar** (real weight only) |
| Brush / accent | Permanent Marker | **Marhey** |
| Note / handwritten | Kalam | **Playpen Sans Arabic** (`ofl/playpensansarabic`) |
| Body | Kalam | **IBM Plex Sans Arabic** |
| Mono-label | Space Mono | **IBM Plex Sans Arabic** |

Drop as primary AR faces: Reem Kufi, Cairo (widget bypasses), Latin-only Playpen Sans for AR notes, Rakkas/Tajawal catch paths once bundling is solid.

Latin fallbacks on AR styles: match weight with Bebas Neue / Permanent Marker / Kalam / Space Mono / IBM Plex Sans (Latin) as appropriate via `fontFamilyFallback`.
