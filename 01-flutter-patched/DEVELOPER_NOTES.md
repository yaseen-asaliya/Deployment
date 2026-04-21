# V1 — Flutter Web, Patched for Mobile Responsiveness

**Audience:** The original outsourced developer of Al Saif Gallery, receiving this as a drop-in replacement of the current source tree.
**Goal:** Same Flutter app, same Dart UI, same visual design — but mobile actually works and cold-load is a fraction of today's size.
**Bottom line:** The IR page was never "not responsive" in layout — `Responsive.isMobile()` branches already exist. It was non-interactive because iframes were held under `pointer-events: none` by defensive timers that never re-enabled them. Those timers are gone.

---

## What changed (exact diffs)

### 1. `lib/screens/investors_governance_screen.dart`

**Removed:** `_disableAllIframes()` (10 cascaded `Future.delayed` timers), `_onScroll()` listener, scroll-listener wiring in `initState`/`didChangeDependencies`/`dispose`, the `dart:html`/`dart:async` imports.

**Rationale:** This block was setting `iframe.style.pointerEvents = 'none'` on every iframe in the DOM at 10 successive timestamps after mount, then re-disabling on every scroll event. The widgets' own state machine took over after tap, with a 3-second interaction window. On mobile, the result was: tap to activate → interact for ≤ 3 s → scroll anywhere → iframe dies. Removing the hack lets the browser do what browsers do.

**Additional fix at `_IRDropdownTabState._remove()`:** The dropdown's dismiss path said (in Arabic comment) "don't re-enable the iframes." Now it does. That alone was stranding widgets after every tab-dropdown dismissal on mobile.

### 2. `lib/widgets/external_script_widget.dart`

**Removed:**
- Initial `pointerEvents = 'none'` on iframe construction.
- Six trailing `Future.delayed` calls re-applying the same.
- `_onPointerDown()` (enable-for-3-seconds hack) and `_onScroll()` (disable-immediately-on-scroll hack).
- `deactivate()` and `didUpdateWidget()` overrides whose only purpose was to re-disable the iframe.
- The `Listener(onPointerDown/onPointerMove/onPointerSignal: ...)` wrapper around `HtmlElementView`.
- The `wheel`/`touchmove` → `postMessage({type: 'iframe-wheel'})` forwarders inside each widget's `srcdoc`.
- `package:flutter/gestures.dart` import (no longer needed).
- Per-instance `_enableTimer`, `_isScrolling` state.

**Kept:** The `postMessage({type: 'widget-height'})` height-reporting flow from inside the iframe. That's the only cross-frame message still needed.

**Rationale:** With native browser scroll back in charge (because pointer-events is auto), the iframe no longer needs to fake-forward touches to the parent. Flutter's `HtmlElementView` cooperates with native scroll when the iframe is a regular sized element in the document flow.

### 3. `lib/widgets/navigation_bar.dart`

**Fixed:** `_IRDropdownNavItemState._removeDropdown()` now calls `setAllIframesPointerEvents(true)` when the nav dropdown closes. It previously left them disabled.

### 4. `lib/widgets/top_bar.dart`

**Fixed:** Language-select dialog's `.then((_) {...})` now re-enables iframe pointer events on dismissal. It previously left them disabled.

### 5. `lib/main.dart`

**Removed:** the window-level `message` listener that consumed fake `iframe-wheel` events from the srcdoc forwarders. Now obsolete.
**Removed:** the `dart:html` / `dart:js_util` imports.

### 6. `web/index.html`

**Removed:**
- `window.disableAllIframes` / `window.enableAllIframes` / `window._iframesManuallyDisabled` globals (nothing calls them after the Dart patches).
- The `window.addEventListener('blur', () => setTimeout(() => window.focus(), 50))` handler that was stealing focus back from iframes every 50 ms, breaking form inputs and date pickers inside widgets.

**Kept:** preconnect/dns-prefetch/preload for `irp.atnmo.com`, meta tags, manifest, selection styles.

### 7. `build.sh`

**Changed:**
- Added `--web-renderer html` (drops the 6.75 MB CanvasKit WASM, restores native scroll/text rendering, native a11y tree). Flutter 3.24.5 supports it.
- Changed `--pwa-strategy none` → `--pwa-strategy offline-first` (default). The Flutter-managed `flutter_service_worker.js` now emits; paired with index.html no longer wiping caches, repeat visits will serve from cache.

### 8. `render.yaml`

**Added:** cache-header rules for `flutter_bootstrap.js` (`no-cache`), `manifest.json` (`max-age=3600`), `/fonts/*` and `/icons/*` (`immutable, max-age=31536000`). Existing rules for `main.dart.js`, `/assets/*`, `/canvaskit/*` were already correct.

### 9. `assets/images/`

**Deleted (unused, saves ~9.9 MB from every bundle):**
- `I&G 1.svg` (6.7 MB)
- `news.svg` (3.2 MB)

These are referenced nowhere in the Dart code but were being bundled because `pubspec.yaml` globs the whole `assets/images/` folder. If you need them later, re-add them — but consider re-exporting the SVGs, they're almost certainly un-optimized exports from a design tool.

---

## What you still need to do

### Required before shipping (you'll need Flutter SDK installed)

```bash
bash build.sh
```

This runs `flutter pub get` + `flutter build web --release --web-renderer html --pwa-strategy offline-first`. Output lands in `build/web/`.

### Verify locally

```bash
flutter run -d chrome
```

Then open Chrome DevTools → Network and confirm: (a) **no** `canvaskit.wasm` appears; (b) `main.dart.js` is roughly 2.5–3 MB instead of ~2.8 MB + 6.75 MB WASM.

### Widget team tasks (in a separate codebase, not this one)

The widget platform at `irp.atnmo.com` still has issues that are out-of-scope for this Flutter patch. Pass these back upstream:

- `widget-loader.js` hard-codes `https://test.irp.atnmo.com` for the IRAI widget — must be production URL.
- `widget-loader.js` lacks `event.origin` check on its `message` listener (security and correctness).
- `widget-loader.js` is served `Cache-Control: public, max-age=0` — should be versioned + `immutable`.
- Optional: replace the `iFrameResize` polling library with a `ResizeObserver` inside each widget iframe, reported via `postMessage`. Current polling churns the parent layout.

Full details in the companion doc `al-saif-gallery-perf-fixes.md` (Fixes 7–13).

---

## How the IR widget integration now works

- `web/index.html` preconnects to `https://irp.atnmo.com` and preloads `widget-loader.js`.
- Each Dart IR widget (`CompanySnapshotWidget`, `FactSheetTableWidget`, etc.) renders an `ExternalScriptWidget` that creates an `<iframe>` via `HtmlElementView`, with its `srcdoc` loading `widget-loader.js` and calling `loadWidget(widgetType, UUID, lang, listingId, 'v3')`.
- Production UUIDs (unchanged):
  - `UUID = 5be9c146-613e-4141-a351-1f5e13fc5513`
  - `listingId = 81a06c05-1a48-4d1b-8dbd-bcf60a76730f`
  - `version = 'v3'`
- The iframe reports its natural height via `postMessage({type: 'widget-height', id, height})`. Dart debounces at 200 ms and updates the `SizedBox` height.
- iOS gets `_LazyExternalScriptWidgetIOS` (intersection-observed lazy mount). Android and desktop get immediate `ExternalScriptWidget`.

Pointer events are `auto` on all iframes — they handle their own touch and wheel events natively, and the browser propagates scroll to the parent when the iframe content can't scroll further.

---

## Responsive breakpoints (unchanged)

Defined in `lib/utils/responsive.dart`:

| Range | Bucket | `Responsive.isMobile()` |
|---|---|---|
| `< 600 px` | Mobile | `true` |
| `600-899 px` | Tablet | `false` |
| `900-1199 px` | Laptop | `false` |
| `1200-1919 px` | Desktop | `false` |
| `≥ 1920 px` | Large Desktop | `false` |

The IR screen already branches at line 56 (`investors_governance_screen.dart`): mobile uses `SingleChildScrollView`, non-mobile uses `CustomScrollView` with slivers. Not changed.

---

## Bilingual (EN/AR)

Unchanged. `LocaleProvider` in `lib/utils/locale_provider.dart` drives `Directionality` in `main.dart`. Arabic text scaling is reduced via `MediaQuery.textScaleFactor = 0.9` when `localeProvider.isArabic`.

---

## Cache & hosting

`render.yaml` now has the right pattern. Verify post-deploy:

- `main.dart.js`: `cache-control: public, max-age=31536000, immutable` on second load, `(ServiceWorker)` in Network tab.
- `index.html`: `cache-control: no-store, no-cache, must-revalidate`.
- `flutter_service_worker.js`: `cache-control: no-store, no-cache, must-revalidate`.
- `flutter_bootstrap.js`: `cache-control: no-cache`.
- `/canvaskit/*`: rule retained for safety but this build emits HTML renderer, so these files won't be requested.

Warm-reload transfer target: < 200 KB.

---

## Benchmark snapshot (expected)

| Metric | Before | After (target) |
|---|---|---|
| Mobile Lighthouse Performance | 10–20 | 55–70 |
| Cold-load on-wire (mobile) | ~3 MB | ~800 KB |
| Warm reload | ~3 MB (cache wiped) | < 200 KB |
| IR widget interactive after scroll? | No (3 s window) | Yes (always) |
| Arabic text rendering | Correct (SkParagraph) | Correct (native text, may differ slightly) |

Actual numbers populate `BENCHMARK.md` after `flutter build web` is run and the output is served + measured with Playwright/Lighthouse (see `/versions/BENCHMARK-COMPARISON.md`).

---

## Gotchas

- **Flutter version:** `build.sh` pins `FLUTTER_VERSION=3.24.5`. The HTML renderer was removed in Flutter 3.29. If you upgrade Flutter, this build breaks until you either pin back or migrate to CanvasKit-only (regresses mobile perf).
- **Arabic with HTML renderer:** SkParagraph (CanvasKit) shapes Arabic slightly differently from the native browser. Visual-QA both locales after the first HTML-renderer build. Rare words may ligature differently; 99% of cases are identical.
- **Widget interaction on top of dropdowns:** Dropdowns still call `setAllIframesPointerEvents(false)` when opening (correct — overlays need to receive clicks) and `setAllIframesPointerEvents(true)` on close (fixed). If you introduce a new dropdown/dialog later, remember the pair.
- **The IR widgets are third-party.** This patch does not change their code. If widgets still feel slow, that's the widget team's court (see the out-of-scope list above).

---

## Extending — adding a new IR widget section

1. Create `lib/widgets/<new>_widget.dart` modelled on e.g. `company_snapshot_widget.dart` — it wraps a `LazyExternalScriptWidget(viewId: 'new-widget', widgetType: '<widget-key>', ...)`.
2. Add an entry in `lib/screens/investors_governance_screen.dart` inside the `_IRTabContent` builder (check the existing list of 15 widgets).
3. Add the localized label in `lib/utils/app_localizations.dart`.
4. Add a navbar dropdown entry in `lib/widgets/navigation_bar.dart` inside `_IRDropdownNavItemState._showDropdown()`.

The widget key must match an endpoint known to `widget-loader.js` at `irp.atnmo.com`.
