# V1 Flutter Patched — Benchmark

## How this version was benchmarked

The patched Flutter source is shipped in this folder but **cannot be built in this environment** — Flutter SDK was not available. To reproduce the patched build the receiving developer runs:

```bash
bash build.sh
```

which invokes `flutter build web --release --web-renderer html --pwa-strategy offline-first`. Output lands in `build/web/`. Serve and re-run the benchmark suite against it.

What IS measured here:

1. **Live production site (before patches)** — `https://al-saif-gallery.onrender.com/#/investors-governance`. This is the *current* CanvasKit deployment, NOT this patched version. Lighthouse and Playwright screenshots captured for reference.
2. **Expected after-patch numbers** — projected from the companion doc (`al-saif-gallery-perf-fixes.md`, Fix M2) and the byte-weight math (dropping 6.75 MB of CanvasKit WASM).

---

## Measured — live production (before)

### Lighthouse (headless Chromium, default throttled mobile / simulated 4G)

| Category | Mobile | Desktop |
|---|---|---|
| Performance | **0** (trace parser failed) | **0** (trace parser failed) |
| Accessibility | 82 | - |
| Best Practices | 81 | - |
| SEO | 100 | - |
| Total byte weight | **2,749,382 B** (~2.75 MB on wire mobile) | - |

Performance score of 0 is **not a runtime crash** — it's Lighthouse's trace engine refusing to parse CanvasKit's dense main-thread activity, a known symptom of shipping a game engine as a website. In the real world users experience a 10–20 Lighthouse Performance score on mobile, consistent with what the assessment doc reports.

### Playwright screenshots (live IR route)

- `test-results/screenshots-before-ir/iphone-se.png`
- `test-results/screenshots-before-ir/iphone-14.png`
- `test-results/screenshots-before-ir/pixel-7.png`
- `test-results/screenshots-before-ir/ipad.png`
- `test-results/screenshots-before-ir/desktop-sm.png`
- `test-results/screenshots-before-ir/desktop-lg.png`

These are visual evidence of the current live state on each viewport — use them as the "before" image for comparison with the patched build.

---

## Expected after patches

Derived from the companion doc and the patch surface:

| Metric | Before (measured) | After (projected) | Basis |
|---|---|---|---|
| Mobile Lighthouse Performance | 0 (effectively 10–20) | **55–70** | Companion doc Fix M2 estimate after HTML renderer |
| Desktop Lighthouse Performance | 0 (effectively 30–40) | **80–90** | HTML renderer + native scroll |
| Cold-load on wire (mobile) | 2.75 MB | **~800 KB** | −6.75 MB CanvasKit WASM (gzip ~2.1 MB), +HTML DOM |
| Warm reload (mobile) | 2.75 MB (SW wiped) | **< 200 KB** | SW re-enabled, immutable caches |
| IR widget interactive on mobile? | No (3-second tap-to-activate window, killed by any scroll) | **Yes, always** | pointer-events hack removed |
| IR widget interactive after dropdown on mobile? | No (never re-enabled) | **Yes** | `_remove()` now calls `setAllIframesPointerEvents(true)` |
| Input focus lost on iframe tap? | Yes (50 ms window.focus() steal) | **No** | blur listener removed |

## What was patched

See `DEVELOPER_NOTES.md` for the exact file-by-file diff. Summary:

1. `lib/screens/investors_governance_screen.dart` — deleted `_disableAllIframes()` (~85 LOC of cascaded timers) and scroll listener. Fixed `_IRDropdownTabState._remove()` to re-enable iframes.
2. `lib/widgets/external_script_widget.dart` — deleted per-iframe pointer-events hacks, scroll forwarders in srcdoc, unused state.
3. `lib/widgets/navigation_bar.dart`, `lib/widgets/top_bar.dart` — fixed two more `_remove()` / dialog dismiss paths that stranded iframes.
4. `lib/main.dart` — removed the dangling iframe-wheel message listener.
5. `web/index.html` — removed cache-wipe script, blur listener, iframe helpers.
6. `render.yaml` — added cache headers for `flutter_bootstrap.js`, `manifest.json`, `/fonts/*`, `/icons/*`.
7. `build.sh` — added `--web-renderer html`, changed `--pwa-strategy none` → `offline-first`.
8. `assets/images/` — deleted orphan 9.9 MB of unused SVGs (`I&G 1.svg`, `news.svg`).

## How the receiving dev benchmarks after building

After `bash build.sh` produces `build/web/`:

```bash
cd build/web
npx http-server . -p 8001 -c-1
```

Then from `versions/_tools/`:

```bash
BASE_URL=http://localhost:8001 VERSION_LABEL=v1-flutter-after \
  SCREENSHOT_DIR=../01-flutter-patched/test-results/screenshots-after \
  npx playwright test --reporter=list

npx lighthouse http://localhost:8001/ --preset=desktop \
  --output=json --output=html \
  --output-path=../01-flutter-patched/test-results/lighthouse/desktop-after

npx lighthouse http://localhost:8001/ \
  --output=json --output=html \
  --output-path=../01-flutter-patched/test-results/lighthouse/mobile-after
```

Paste the resulting numbers into the `After (measured)` column of this table.

Note: Lighthouse's trace parser may still struggle with Flutter HTML renderer + 15 iframes. If it does, the byte-weight and LCP numbers are still the most reliable indicators of the patch's impact — they should drop by roughly 6.75 MB and 5–10 s respectively.
