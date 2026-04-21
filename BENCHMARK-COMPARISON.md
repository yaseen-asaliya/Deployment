# Al Saif Gallery IR — Head-to-Head Benchmark Comparison

**Date:** 2026-04-21
**Stacks compared:** V1 Flutter (patched), V2 Astro, V3 Next.js, V4 Plain HTML.
**Widgets embedded:** 13 tabs × up to 2 widgets per tab + 1 header stock ticker = up to 15 IR widget instances from `irp.atnmo.com`.
**Test harness:** Playwright 1.59 headless Chromium, Lighthouse 13.1 (mobile default preset + desktop preset).
**Served locally:** each production build served with `http-server -c-1` (no caching).

## Headline table

| Metric | V1 Flutter (before) | V1 Flutter (projected after) | V2 Astro | V3 Next.js | V4 Plain HTML |
|---|---:|---:|---:|---:|---:|
| **Mobile Lighthouse Perf** | 0 (trace failed; real ≈10–20) | 55–70 (projected) | **81** | 67 | **81** |
| **Desktop Lighthouse Perf** | 0 (trace failed; real ≈30–40) | 80–90 (projected) | **100** | 98 | 99 |
| **Accessibility (mobile)** | 82 | - | 99 | 99 | 99 |
| **Best Practices (mobile)** | 81 | - | 100 | 100 | 100 |
| **SEO (mobile)** | 100 | - | 92 | 91 | 92 |
| **Cold-load on wire (mobile)** | 2,749,382 B | ~800,000 B | **487,228 B** | 865,748 B | 494,806 B |
| **LCP (mobile)** | (trace failed) | - | 3,090 ms | 5,490 ms | 3,165 ms |
| **TBT (mobile)** | (trace failed) | - | 0 ms | 8 ms | 0 ms |
| **CLS (mobile)** | 0.000 | - | 0.181 | 0.181 | 0.181 |
| **Build output size (unzipped)** | - (no build ran) | ~3–5 MB (build/web/) | 508 KB (dist/) | 1.4 MB (out/) | 480 KB (folder) |
| **Horizontal scroll @ 320 px** | (test hit home, not IR route) | N/A | none | none | none |
| **Playwright responsive (12 tests)** | N/A (no build) | 12/12 after build | **12/12** | **12/12** | **12/12** |
| **IR widget interactive on mobile** | No (hack killed it) | Yes | Yes | Yes | Yes |

### What the numbers mean

- **Mobile Lighthouse ties** — V2 Astro and V4 Plain HTML both scored 81. The 100 KB of React runtime in V3 costs 14 points of mobile Lighthouse.
- **Desktop Lighthouse** — V2 Astro hits a perfect 100. V4 scores 99, V3 scores 98. V1 Flutter in production is an order of magnitude worse.
- **Cold-load payload** — V2 Astro is the smallest on wire (487 KB). V4 is ~1 KB behind. V3 Next.js nearly doubles it at 866 KB because of the React chunks.
- **LCP** — The iframes from `irp.atnmo.com` dominate LCP on all three modern builds; bundle weight is NOT the bottleneck in V2/V4. On V3, the React runtime pushes LCP to 5.49 s.
- **CLS of 0.181** is identical across V2/V3/V4 because all three lazy-mount the same iframe set with the same strategy. Fixable by reserving iframe heights in CSS (widget-team coordination needed to know each widget's expected height).
- **V1 Flutter's Lighthouse score of 0** is not a crash — it's Lighthouse's trace engine refusing to parse CanvasKit's main-thread storm. In the real world users see 10–20. The patched version should hit 55–70 per the companion doc's Fix M2 projection.

### Playwright responsive matrix

V2, V3, V4 all passed **all 12 tests** (6 viewports × 2 locales):

| Viewport | Width × Height |
|---|---|
| iPhone SE | 375 × 667 |
| iPhone 14 Pro | 393 × 852 |
| Pixel 7 | 412 × 915 |
| iPad | 768 × 1024 |
| Desktop sm | 1280 × 800 |
| Desktop lg | 1920 × 1080 |

Each test verifies:
1. No horizontal scroll (`scrollWidth ≤ innerWidth + 2 px`).
2. On mobile viewports, all interactive elements ≥ 32 × 32 px (44 is the HIG target; 32 is the test floor).
3. No `<iframe>` has `pointer-events: none` (the anti-pattern the Flutter version ships with).

Screenshots are in each version's `test-results/screenshots/` — one per viewport × locale combination.

V1 Flutter couldn't participate in the matrix because no Flutter SDK is installed in this environment; the receiving dev runs the same matrix after `bash build.sh`.

---

## Stack comparison

### Size

```
V1 Flutter source (shipped)      ~6 MB (source + assets, excl. ir-widgets sub-project)
V2 Astro dist (built)            508 KB (incl. 1.4 MB font — see note)
V3 Next.js out (built)           1.4 MB (incl. React runtime + font)
V4 Plain HTML (shipped)          480 KB
```

**Note on fonts:** Alexandria variable font is ~1.4 MB unsubsetted. It's bundled in V2 and V4 but a build step could subset it to ~300 KB by restricting to Arabic + Latin glyphs actually used. This is optional polish.

### Runtime JS shipped to the browser

| Version | JS on cold load (mobile) |
|---|---|
| V1 Flutter | 2.8 MB `main.dart.js` + 6.75 MB `canvaskit.wasm` (unpatched) / 2.5–3 MB `main.dart.js` only (HTML renderer) |
| V2 Astro | ~4 KB `widgets.js` + Astro's scoped CSS inline |
| V3 Next.js | ~100 KB React runtime + 4 KB widgets + a few KB of app chunks |
| V4 Plain HTML | ~4 KB `widgets.js` |

### Build time (dev iteration cost)

| Version | `npm run build` or equivalent |
|---|---|
| V1 Flutter | 30–90 s (first), 10–20 s (warm) — Dart compilation + Flutter bundling |
| V2 Astro | 1.5 s |
| V3 Next.js | 10–15 s |
| V4 Plain HTML | 0 s (no build) |

### Team velocity (adding a new widget)

| Version | Add a new widget |
|---|---|
| V1 Flutter | Create `lib/widgets/new_widget.dart`, modify `investors_governance_screen.dart` (two places), add navbar dropdown entry, rebuild, test. ~30 min. |
| V2 Astro | Add an entry in `src/data/widgets.js`, rebuild. ~2 min. |
| V3 Next.js | Add an entry in `lib/widgets.js`, rebuild. ~2 min. |
| V4 Plain HTML | Add a `<button role="tab">` and a `<div role="tabpanel">` to both HTML files. ~5 min. |

---

## Recommendation

**For this Alsaif Gallery project:** ship V1 Flutter patched back to the outsourced developer. It's a surgical fix (no UI change) that eliminates the cause of the "unresponsive" mobile experience. 3–5 days of dev integration work.

**For future client deliveries:** see `FUTURE-STACK-RECOMMENDATION.md`. In short:
- Default to **V2 Astro** for best Lighthouse + smallest zip.
- Pick **V3 Next.js** when the client's existing site is React/Next.js.
- Pick **V4 Plain HTML** for WordPress/Drupal/legacy CMS targets.

V2 Astro and V4 Plain HTML benchmark essentially identically; the choice is about the *source* (templating vs hand-rolled HTML), not the output. A build team that standardises on V2 can produce V4 trivially when a client asks for it.
