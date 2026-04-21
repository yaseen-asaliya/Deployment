# Al Saif Gallery IR — Four Shipped Versions

**Generated:** 2026-04-21

This directory contains four fully-built implementations of the Al Saif Gallery Investor Relations page, each targeting a different downstream scenario. Every version renders the same content (hero, intro, investment case, stock ticker, 13 widget tabs, footer) and consumes the same third-party IR widgets from `irp.atnmo.com`.

---

## The four versions

| # | Stack | Folder | When to use |
|---|---|---|---|
| **V1** | Flutter Web (patched) | `01-flutter-patched/` | **This specific Alsaif project.** Patched source to ship back to the outsourced developer. |
| **V2** | Astro 6 (static) | `02-astro/` | Future clients with static / Jamstack hosting. Default choice for best Lighthouse. |
| **V3** | Next.js 15 (App Router, static export) | `03-nextjs/` | Future clients with React / Next.js sites, or portal-extension roadmaps. |
| **V4** | Plain HTML + vanilla JS | `04-plain-html/` | Future clients with WordPress / Drupal / Vue / legacy CMS / simplest drop-in. |

Each folder has its own:
- `DEVELOPER_NOTES.md` — handoff guide: what it is, how to build, how to zip, gotchas.
- `BENCHMARK.md` — per-version Lighthouse + Playwright results.
- `test-results/` — actual screenshots and Lighthouse HTML reports.

Top-level docs:
- [`BENCHMARK-COMPARISON.md`](BENCHMARK-COMPARISON.md) — head-to-head table across all four.
- [`FUTURE-STACK-RECOMMENDATION.md`](FUTURE-STACK-RECOMMENDATION.md) — per-client-scenario picking guide.

---

## Headline benchmark

| Metric | V1 Flutter (before / projected after) | V2 Astro | V3 Next.js | V4 Plain HTML |
|---|---|---:|---:|---:|
| Mobile Lighthouse Performance | 0 (trace fail) / **55–70 projected** | **81** | 67 | **81** |
| Desktop Lighthouse Performance | 0 (trace fail) / **80–90 projected** | **100** | 98 | 99 |
| Cold-load mobile (on-wire) | 2.75 MB / **~800 KB projected** | **487 KB** | 866 KB | 495 KB |
| Playwright responsive tests | N/A (no build) / **12/12 after** | **12/12** | **12/12** | **12/12** |

Full table with LCP, TBT, CLS, byte weights in [`BENCHMARK-COMPARISON.md`](BENCHMARK-COMPARISON.md).

---

## What to do now

### For the Alsaif Gallery project (immediate)

1. Zip `01-flutter-patched/` (exclude `test-results/` if you want a lighter zip).
2. Ship to the outsourced developer with `DEVELOPER_NOTES.md`.
3. They run `bash build.sh` (requires Flutter SDK 3.24.5) to produce `build/web/`.
4. Deploy to Render.
5. Run `responsive.spec.js` (from `_tools/`) against the deployed URL to confirm the patch landed cleanly.

### For future client deliveries

Follow [`FUTURE-STACK-RECOMMENDATION.md`](FUTURE-STACK-RECOMMENDATION.md)'s decision tree. The short version:
- **Default:** V2 Astro.
- **React client:** V3 Next.js.
- **CMS client:** V4 Plain HTML.
- **Flutter client:** V1 Flutter subtree (rare).

---

## How the shared IR widget contract works

All four versions use the same contract for embedding an IR widget:

1. A placeholder: `<div data-widget="<widget-type>" class="widget__body"></div>`.
2. A bootstrap (`widgets.js` in V2/V3/V4; `external_script_widget.dart` in V1) that:
   - Lazy-mounts via IntersectionObserver (500 px rootMargin).
   - Loads `https://irp.atnmo.com/v3/widget/widget-loader.js` once.
   - Calls `loadWidget(widgetType, UUID, lang, listingId, 'v3')`.
3. Configuration (constant across versions, matching the live Alsaif site):
   - `UUID = 5be9c146-613e-4141-a351-1f5e13fc5513`
   - `listingId = 81a06c05-1a48-4d1b-8dbd-bcf60a76730f`
   - `version = v3`

To onboard a new client:
1. Clone the relevant version folder.
2. Change the UUID and listingId to the client's values (given by the widget team).
3. Change brand tokens (colors, logo, hero image, copy).
4. Build (if V2/V3) or edit HTML directly (if V4).
5. Ship the built output.

---

## Testing tools shared across versions

`_tools/` contains a shared Playwright + Lighthouse harness used to benchmark all four versions:

```
_tools/
├── package.json             @playwright/test, lighthouse, http-server
├── playwright.config.js
├── tests/
│   ├── responsive.spec.js   Main responsive + interaction suite (12 tests)
│   └── v1-ir-route.spec.js  One-off V1 Flutter IR-route screenshots
└── node_modules/
```

To benchmark a new version:

```bash
cd _tools
BASE_URL=http://localhost:<port> VERSION_LABEL=<label> \
  SCREENSHOT_DIR=<path>/test-results/screenshots \
  npx playwright test --reporter=list

npx lighthouse http://localhost:<port>/ --preset=desktop \
  --output=json --output=html --output-path=<path>/test-results/lighthouse/desktop

npx lighthouse http://localhost:<port>/ \
  --output=json --output=html --output-path=<path>/test-results/lighthouse/mobile
```

---

## File tree summary

```
versions/
├── README.md                          ← this file
├── BENCHMARK-COMPARISON.md            ← head-to-head table
├── FUTURE-STACK-RECOMMENDATION.md     ← client-scenario decision tree
├── _tools/                            ← shared Playwright / Lighthouse
├── 01-flutter-patched/                ← Flutter source + patches + notes
├── 02-astro/                          ← Astro source + dist/ + notes
├── 03-nextjs/                         ← Next.js source + out/ + notes
└── 04-plain-html/                     ← Pure HTML bundle + notes
```

Each version is self-contained and shippable.
