# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Four production-ready implementations of the same Al Saif Gallery investor relations (IR) page, used as a comparison/delivery package. Each version targets a different client deployment scenario.

| Folder | Stack | Best for |
|--------|-------|----------|
| `01-flutter-patched/` | Flutter Web (Dart) | Extending an existing Flutter app |
| `02-astro/` | Astro 6 static | Greenfield — best Lighthouse score |
| `03-nextjs/` | Next.js 15 (App Router, static export) | Clients with existing React infrastructure |
| `04-plain-html/` | Vanilla HTML/CSS/JS | WordPress/Drupal/CMS, no build tooling |

## Dev Commands

**V2 Astro** (inside `02-astro/source/`):
```bash
npm install
npm run dev      # http://localhost:4321
npm run build    # → dist/
npm run preview
```

**V3 Next.js** (inside `03-nextjs/source/`):
```bash
npm install
npm run dev      # http://localhost:3003
npm run build    # → out/
```

**V4 Plain HTML** (inside `04-plain-html/`):
```bash
python -m http.server 8004
# or: npx http-server . -p 8004
```

**V1 Flutter** (inside `01-flutter-patched/`):
```bash
bash build.sh    # flutter pub get + flutter build web --release --web-renderer html
flutter run -d chrome
```
Flutter SDK must be pinned to **3.24.5** — HTML renderer was removed in 3.29+.

**All four servers at once (Windows):** run `start-servers.bat` from repo root.

Local test URLs: `START-LOCAL-TESTING.md` lists all routes and the test matrix (5 viewport sizes, EN + AR).

## Architecture

### Shared IR Widget Contract
All four versions use the identical mechanism to embed third-party widgets from `irp.atnmo.com`:

1. Placeholder: `<div data-widget="<type>" class="widget__body"></div>`
2. `widgets.js` (4 KB vanilla JS) scans for those placeholders, lazy-mounts them via `IntersectionObserver` (500 px rootMargin), loads `widget-loader.js` once, then calls `window.loadWidget(type, UUID, lang, listingId, 'v3')`
3. Config constants (UUID, listingId) live in each version's `widgets.js` / `widgets.data` / `CONFIG` object

13 widget tabs: Overview, Announcements, Fact Sheet, Stock Activity, Corporate Actions, Financials, Share Price, Performance, Calculator, Share Series, Peer Group, Zakat, Subscribe.

### Page Sections (consistent across V2/V3/V4)
TopBar → NavigationBar → Hero → Intro → InvestmentCase (4-card grid) → StockTicker widget → WidgetTabs → Footer

### Bilingual (EN / AR)
No i18n library — duplicate pages/route groups with hardcoded copy dictionaries:
- V2: `src/pages/` has `en/` and `ar/` subdirs
- V3: App Router route groups `(en)` and `(ar)` each with their own `layout.jsx` + `page.jsx`
- V4: `index.html` (EN) and `ar.html` (AR)
- V1: `app_localizations.dart` key map

### Onboarding a New Client
1. Update UUID + listingId in `widgets.js` / config
2. Update copy in the version's data file (`src/data/widgets.js` for V2, `lib/widgets.js` for V3, inline for V4, `app_localizations.dart` for V1)
3. Replace logo SVG, hero image, and CSS custom properties (`--color-primary`, `--color-secondary`, etc.)
4. Build (V1/V2/V3) or ship folder as-is (V4)

### CSS
V2, V3, and V4 share the same CSS logic. Custom properties are defined at the top of each version's main stylesheet. Five responsive breakpoints: 600 px, 900 px, 1024 px, 1440 px. Mobile-first; hamburger nav activates below 900 px.

## Key Docs in Repo Root
- `README.md` — overview and ship instructions per version
- `BENCHMARK-COMPARISON.md` — Lighthouse scores and payload sizes head-to-head
- `FUTURE-STACK-RECOMMENDATION.md` — decision tree for picking a version per client
- `START-LOCAL-TESTING.md` — local URLs and manual test checklist
- Each version's `DEVELOPER_NOTES.md` — version-specific gotchas and extending guide
