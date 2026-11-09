# Deploy — GitHub Pages + custom domain

Production site: **https://ahmedhishamrasmy.me/**  
Stack: Flutter Web → GitHub Actions → GitHub Pages (root of the apex domain).

Sources verified against current GitHub docs (custom domain DNS, Pages publishing source, domain verification). Do not invent alternate IP addresses.

---

## Exact build command

```bash
flutter build web --release
```

Default base href is `/` (site served from the custom-domain root). Keep `usePathUrlStrategy()` so routes stay clean (`/work/gatherup`, `/resume`).

Local deep-link check after build (SPA fallback):

```bash
# Copy the Pages trick locally (also done in deploy.yml)
cp build/web/index.html build/web/404.html

# Server that returns 404.html for unknown paths (mirrors GitHub Pages)
dart run tool/spa_server.dart 8080
# Open http://127.0.0.1:8080/work/gatherup and /resume directly and refresh.
```

Size report:

```bash
dart run tool/size_report.dart
```

---

## GitHub Pages setting (required)

1. Repo → **Settings** → **Pages**
2. Under **Build and deployment** → **Source**, select **GitHub Actions** (not “Deploy from a branch”).
3. Push to `main` (or run **Deploy to GitHub Pages** via `workflow_dispatch`).

Workflows:

| File | Purpose |
|------|---------|
| `.github/workflows/deploy.yml` | Push to `main` + manual dispatch → analyze, test, build, deploy |
| `.github/workflows/ci.yml` | Pull requests → analyze, test, build only |

Pinned Flutter: **3.44.8** (stable) via `subosito/flutter-action@v2` with caching. Action majors: `actions/checkout@v7`, `actions/configure-pages@v6`, `actions/upload-pages-artifact@v5`, `actions/deploy-pages@v5`.

---

## The `404.html` trick (and its limitation)

GitHub Pages has no generic SPA rewrite. After `flutter build web --release`, the workflow copies:

```text
build/web/index.html → build/web/404.html
```

When someone opens or refreshes `/work/gatherup`, Pages cannot find that file, serves `404.html` (the Flutter shell), and the app boots on the correct path via `usePathUrlStrategy()`.

**Limitation:** those deep links still return **HTTP 404** status even though the app renders. Fine for humans; some strict SEO/uptime checkers may flag 404. Users and client-side routing work.

---

## Custom domain

### 1. Set the domain in repo Settings (required for Actions publishing)

Per [Managing a custom domain for your GitHub Pages site](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site):

> If you are publishing from a custom GitHub Actions workflow, **no `CNAME` file is created, and any existing `CNAME` file is ignored and is not required.**

Also from [Configuring a publishing source](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site):

> A `CNAME` file in your repository file does **not** automatically add or remove a custom domain. Instead, you must configure the custom domain through your repository settings or through the API.

Therefore:

1. Keep `web/CNAME` containing exactly `ahmedhishamrasmy.me` (copied into `build/web` for convenience / branch-mode compatibility).
2. **You must still** open **Settings → Pages → Custom domain**, enter `ahmedhishamrasmy.me`, and **Save**.
3. When DNS is correct and the certificate is ready, enable **Enforce HTTPS**.

### 2. DNS records (apex + www) — from current GitHub docs

Apply these at your **registrar’s DNS panel**. Remove any conflicting default `A` / `AAAA` / `CNAME` records for `@` or `www` first (GitHub notes that automatic default records should be removed before continuing).

#### Apex (`ahmedhishamrasmy.me`) — `A` records

| Type | Name | Value |
|------|------|-------|
| `A` | `@` | `185.199.108.153` |
| `A` | `@` | `185.199.109.153` |
| `A` | `@` | `185.199.110.153` |
| `A` | `@` | `185.199.111.153` |

#### Apex — `AAAA` records (IPv6; recommended together with `A`)

| Type | Name | Value |
|------|------|-------|
| `AAAA` | `@` | `2606:50c0:8000::153` |
| `AAAA` | `@` | `2606:50c0:8001::153` |
| `AAAA` | `@` | `2606:50c0:8002::153` |
| `AAAA` | `@` | `2606:50c0:8003::153` |

#### `www` subdomain — `CNAME`

| Type | Name | Value |
|------|------|-------|
| `CNAME` | `www` | `USERNAME.github.io` |

Replace `USERNAME` with your GitHub username (for this portfolio: `AhmedRasmy1` → `AhmedRasmy1.github.io`). Point **directly** at `USERNAME.github.io` — **not** `USERNAME.github.io/repo` and **not** the `*.pages.github.io` hostname shown in Pages settings.

With the apex set as the custom domain and `www` configured, GitHub Pages redirects between apex and `www` automatically.

Do **not** use wildcard DNS (`*.ahmedhishamrasmy.me`) — GitHub warns this enables subdomain takeover risk even after verification.

### 3. Verify DNS

Propagation can take **up to 24 hours**.

```bash
# Apex A
dig ahmedhishamrasmy.me +noall +answer -t A

# Apex AAAA
dig ahmedhishamrasmy.me +noall +answer -t AAAA

# www
dig www.ahmedhishamrasmy.me +nostats +nocomments +nocmd
```

Windows (no `dig` by default):

```powershell
nslookup ahmedhishamrasmy.me
nslookup -type=AAAA ahmedhishamrasmy.me
nslookup www.ahmedhishamrasmy.me
# or: Resolve-DnsName ahmedhishamrasmy.me -Type A
```

Confirm apex answers match the four `A` / four `AAAA` addresses above.

### 4. Domain verification (recommended — prevents takeover)

Per [Verifying your custom domain for GitHub Pages](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/verifying-your-custom-domain-for-github-pages):

1. GitHub profile picture → **Settings** → **Pages** (account Pages settings, not the repo).
2. **Add a domain** → `ahmedhishamrasmy.me`.
3. Create the DNS **TXT** record GitHub shows (`_github-pages-challenge-USERNAME`).
4. Wait for DNS (up to 24h), then **Verify**. Keep the TXT record in place.

```bash
dig _github-pages-challenge-USERNAME.ahmedhishamrasmy.me +nostats +nocomments +nocmd TXT
```

---

## Open Graph image (you must add)

Add a **1200×630** PNG at:

```text
web/og-image.png
```

Referenced as `https://ahmedhishamrasmy.me/og-image.png` in `web/index.html`. It is **not** generated by this repo — create and commit it before relying on social previews.

---

## Enforce HTTPS

After the custom domain DNS check passes in Settings → Pages, enable **Enforce HTTPS**. GitHub may need up to ~24 hours after DNS is correct before the certificate / checkbox is available.

---

## Google Search Console

1. Open [Google Search Console](https://search.google.com/search-console) → **Add property** → choose the **Domain** property for `ahmedhishamrasmy.me` (covers apex + www + https).
2. Verify ownership with the DNS **TXT** record Google provides (at your registrar).
3. After verification, submit the sitemap: `https://ahmedhishamrasmy.me/sitemap.xml`.
4. Use **URL Inspection** on `https://ahmedhishamrasmy.me/` → Request indexing once live.

---

## Lighthouse check

After the first successful deploy:

1. Open https://ahmedhishamrasmy.me/ in Chrome.
2. DevTools → **Lighthouse** → Mobile + Desktop (Performance, Accessibility, Best Practices, SEO).
3. Confirm title/description/canonical, HTTPS, and that `/work/gatherup` / `/resume` load when opened directly.

---

## Rollback

1. Repo → **Actions** → **Deploy to GitHub Pages**.
2. Open a previous **successful** run.
3. **Re-run all jobs** (redeploys that artifact’s build).

Alternatively fix forward on `main` and push.

---

## Cupertino icon font note

`cupertino_icons` stays **out** of `pubspec.yaml` on purpose. There are **zero** `CupertinoIcons` references in this app’s Dart sources. `go_router` depends on `cupertino_ui`, not `cupertino_icons`.

Release builds may print:

> Expected to find fonts for (MaterialIcons, packages/cupertino_icons/CupertinoIcons), but found (MaterialIcons).

That comes from Flutter’s icon tree-shaker scanning framework / transitive `IconData` that *could* use the Cupertino font family. Those icons are shaken out; only a tiny MaterialIcons subset remains (~8 KB). The warning is **harmless** at runtime. Re-add `cupertino_icons` only if you start using `CupertinoIcons.*`.

---

## Pre-release checklist

- [ ] `flutter analyze --fatal-warnings` clean
- [ ] `flutter test` green
- [ ] `flutter build web --release` succeeds; `dart run tool/size_report.dart` reviewed
- [ ] Local SPA check: `/work/gatherup` and `/resume` load via `404.html` fallback
- [ ] Pages **Source** = **GitHub Actions**
- [ ] Custom domain set in **Settings → Pages** to `ahmedhishamrasmy.me` (CNAME file alone is ignored under Actions)
- [ ] Apex `A` + `AAAA` and `www` `CNAME` applied; conflicting defaults removed
- [ ] DNS verified with `dig` / `nslookup`; wait for propagation (≤ 24h)
- [ ] Account-level domain verification TXT (recommended)
- [ ] **Enforce HTTPS** enabled
- [ ] `web/og-image.png` (1200×630) committed
- [ ] Search Console domain property + sitemap submitted
- [ ] Lighthouse pass on home; deep links and refresh work on production
