# V4 — Plain HTML Bundle

**Audience:** Clients with an existing CMS (WordPress, Drupal, Joomla, Webflow, hand-rolled static HTML) who want an IR page they can drop in with zero build tooling.
**Goal:** One folder, two HTML files (EN + AR), one CSS file, one JS file. Ship as a zip, extract into a web directory, done.

---

## What this is

- Semantic HTML for an investor relations page — top bar, main nav, hero, intro, investment case, live stock ticker, 13-tab widget grid, footer.
- Hand-rolled responsive CSS (no Tailwind, no framework) with CSS custom properties for brand tokens.
- Vanilla JS that handles tabs, mobile menu, and lazy-mounts the IR widgets from `irp.atnmo.com` as the user scrolls.
- Bilingual: `index.html` (EN, LTR) and `ar.html` (AR, RTL).
- **No build step. No npm. No Node. No Webpack.** Open `index.html` in any browser — or upload the folder to any static host.

---

## Directory layout

```
04-plain-html/
├── index.html                   EN page
├── ar.html                      AR page (RTL)
├── assets/
│   ├── css/main.css             All styles, no framework, ~8 KB min.
│   ├── js/widgets.js            Tabs, mobile nav, lazy widget mount.
│   ├── fonts/Alexandria.ttf     Variable font used by the Flutter original.
│   └── img/
│       ├── logo.svg
│       └── ig_hero.jpeg
└── DEVELOPER_NOTES.md           ← you are here
```

That's it. Nothing else is needed.

---

## How to run locally

Option A — Python (already on most systems):
```bash
python -m http.server 8004
```
Then visit `http://localhost:8004/`.

Option B — Node:
```bash
npx http-server . -p 8004 -c-1
```

Option C — VS Code Live Server extension, any IDE built-in preview, or just double-click `index.html` (though the IR widgets' `loadWidget` requires the page to be served over `http://` / `https://` to pass origin checks, so prefer A or B).

---

## How widgets are integrated

`assets/js/widgets.js` does three things:

1. **Finds every `<div data-widget="...">`** on the page.
2. **Lazy-mounts** each one using `IntersectionObserver` with a 500 px root margin. This ensures widgets below the fold don't block the initial paint.
3. When a widget scrolls near the viewport, the script:
   - Loads `https://irp.atnmo.com/v3/widget/widget-loader.js` (once, cached across all widgets).
   - Inserts an anchor `<div id="${widgetType}-widget">` inside the container.
   - Calls `window.loadWidget(widgetType, UUID, lang, listingId, 'v3')`.

The UUID, listing ID, and version are configured at the top of `widgets.js`:

```js
var CONFIG = {
  uuid:      '5be9c146-613e-4141-a351-1f5e13fc5513',
  listingId: '81a06c05-1a48-4d1b-8dbd-bcf60a76730f',
  version:   'v3',
  loaderUrl: 'https://irp.atnmo.com/v3/widget/widget-loader.js',
  rootMargin: '500px',
};
```

**Language auto-detection:** the script reads `document.documentElement.lang`. `ar.html` sets `lang="ar"` → widgets render in Arabic. `index.html` is `lang="en"` → English.

---

## Widgets used (all 13 tabs + 1 ticker = 14 containers, 15 instances including both fact-sheet layouts and both stock-activity views)

| Tab | `data-widget` value |
|---|---|
| (header) | `stock-ticker` |
| Overview | `company-snapshot` |
| Announcements | `corporate-news` |
| Fact Sheet | `fact-sheet-table`, `fact-sheet-charts` |
| Stock Activity | `stock-activity-simple`, `stock-activity-advanced` |
| Corporate Actions | `corporate-actions` |
| Financials | `company-financials` |
| Share Price | `share-price` |
| Performance | `performance` |
| Calculator | `investment-calculator` |
| Share Series | `share-series` |
| Peer Group | `peer-group-analysis` |
| Zakat | `zakat-calculator` |
| Subscribe | `email-subscription` |

**To add a new widget section:** add a new `<button role="tab">` inside `.widgets__tabs`, a new `<div role="tabpanel">` after the others, and inside it put `<div class="widget"><div class="widget__body" data-widget="<widget-type>"></div></div>`. Do the same in `ar.html` with the Arabic label.

---

## Responsive breakpoints

Defined as CSS `@media` rules in `assets/css/main.css`:

| Breakpoint | What changes |
|---|---|
| `< 600 px` | Mobile: single-column investment case grid, hamburger nav, 12 px gutters |
| `≥ 600 px` | Tablet: 2-col investment case grid, 32 px gutters |
| `≥ 900 px` | Two-up widget grid (fact-sheet, stock-activity) |
| `≥ 1024 px` | Desktop: 4-col investment case grid, 48 px gutters, full horizontal nav |
| `≥ 1440 px` | Wide desktop: 64 px gutters |

Mobile menu appears at `< 900 px`. All tap targets are ≥ 44 × 44 px.

There is **no horizontal scroll** at 320 px — verified in the Playwright suite.

---

## Bilingual (EN / AR)

Two HTML files, one for each locale. All copy is hard-coded in the HTML — there is no i18n engine, which is appropriate for a single-page deliverable. If future clients need many locales, upgrade to V2 (Astro) or V3 (Next.js).

RTL handling:
- `<html dir="rtl" lang="ar">` in `ar.html`.
- CSS logical properties (`padding-inline`, `margin-inline`) handle most flipping automatically.
- A small RTL-specific block at the bottom of `main.css` flips navbar link order and re-aligns some text blocks that needed explicit handling.

The Alexandria variable font handles both scripts.

---

## Cache & hosting

Ship this `_headers` file alongside if the host supports it (Netlify, Cloudflare Pages, Vercel):

```
/assets/css/*
  Cache-Control: public, max-age=31536000, immutable
/assets/js/*
  Cache-Control: public, max-age=31536000, immutable
/assets/fonts/*
  Cache-Control: public, max-age=31536000, immutable
/assets/img/*
  Cache-Control: public, max-age=604800
/index.html
  Cache-Control: no-cache
/ar.html
  Cache-Control: no-cache
```

For Apache: use `.htaccess`. For nginx: add `expires` directives to the server block.

If you hash-fingerprint the CSS and JS filenames later, the `immutable` cache is safe forever.

---

## Benchmark snapshot

Numbers populated after running the Playwright + Lighthouse suite. See `/versions/BENCHMARK-COMPARISON.md` for head-to-head against V1/V2/V3.

Expected (based on payload alone):
- Mobile Lighthouse Performance: 95+
- On-wire cold load (no widgets yet): < 40 KB
- On-wire cold load (after first widget mounts): < 100 KB
- LCP: < 1.2 s on simulated 4G

---

## Gotchas

- **Opening the file directly (`file://`) can block the widget-loader.js fetch** due to CORS / origin. Always serve over HTTP.
- **Variable font**: browsers that don't support variable fonts fall back to system fonts (acceptable, the fallback stack is `system-ui, -apple-system, "Segoe UI", Roboto, sans-serif`).
- **Arabic text shaping**: modern browsers handle Arabic natively. No special script required.
- **Widget iframes are third-party.** If a widget fails to render, it's upstream at `irp.atnmo.com` — check the browser console for `[IR] loadWidget failed for ...` messages.
- **Skeleton shimmer**: the empty-state `:empty::before` in `main.css` shows a shimmer while the iframe is loading. Once the iframe is mounted, it replaces the shimmer.
- **Tab switching on mobile**: when you switch tabs, any not-yet-mounted widgets in the newly-visible panel will mount via their IntersectionObserver. Widgets already mounted persist across tab switches (no re-fetching).

---

## Extending for other clients

This is the template for the "zip-and-ship" IR product. For each client:

1. Copy the folder.
2. Edit `CONFIG.uuid` and `CONFIG.listingId` in `assets/js/widgets.js`.
3. Edit brand tokens at the top of `assets/css/main.css` (primary color, typography, spacing).
4. Replace `assets/img/logo.svg` and hero image.
5. Edit the hero copy, intro copy, and investment case cards in `index.html` + `ar.html`.
6. Rename widget tabs or remove any the client doesn't want.
7. Re-zip, ship.

No code generation, no scaffolding, no framework upgrade to worry about.
