# V4 Plain HTML — Benchmark

Tested against `http://localhost:8004/` with 13 IR widgets loading from `irp.atnmo.com`.

## Lighthouse (headless Chromium)

| Category | Mobile | Desktop |
|---|---|---|
| Performance | **81** | **99** |
| Accessibility | **99** | **99** |
| Best Practices | **100** | - |
| SEO | **92** | **92** |

## Core Web Vitals (mobile, simulated 4G)

| Metric | Value | Budget |
|---|---|---|
| LCP (Largest Contentful Paint) | 3165 ms | < 2500 ms (needs image preload) |
| TBT (Total Blocking Time) | 0 ms | < 200 ms ✓ |
| CLS (Cumulative Layout Shift) | 0.181 | < 0.1 (iframe mount; can be fixed with reserved-height) |
| Total byte weight | 494,806 B | < 1 MB ✓ |

## Playwright responsive test matrix

All 12 tests passed:

| Viewport | Locale | Horizontal scroll | Tap targets ≥ 32 px | pointer-events:none iframes |
|---|---|---|---|---|
| iPhone SE (375×667) | EN | none | pass | 0 |
| iPhone SE | AR | none | pass | 0 |
| iPhone 14 (393×852) | EN | none | pass | 0 |
| iPhone 14 | AR | none | pass | 0 |
| Pixel 7 (412×915) | EN | none | pass | 0 |
| Pixel 7 | AR | none | pass | 0 |
| iPad (768×1024) | EN | none | pass | 0 |
| iPad | AR | none | pass | 0 |
| Desktop (1280×800) | EN | none | pass | 0 |
| Desktop | AR | none | pass | 0 |
| Desktop LG (1920×1080) | EN | none | pass | 0 |
| Desktop LG | AR | none | pass | 0 |

Screenshots are under `test-results/screenshots/`. Lighthouse HTML reports under `test-results/lighthouse/`.

## Source size

```
assets/css/main.css   ~13 KB
assets/js/widgets.js   ~4 KB
index.html            ~14 KB
ar.html               ~15 KB
```
