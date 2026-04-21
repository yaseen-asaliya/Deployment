# V2 Astro — Benchmark

Tested against `http://localhost:8002/` (Astro production build served with `http-server`) with 13 IR widgets loading from `irp.atnmo.com`.

## Lighthouse (headless Chromium)

| Category | Mobile | Desktop |
|---|---|---|
| Performance | **81** | **100** |
| Accessibility | **99** | **99** |
| Best Practices | **100** | - |
| SEO | **92** | **92** |

## Core Web Vitals (mobile, simulated 4G)

| Metric | Value | Budget |
|---|---|---|
| LCP | 3090 ms | < 2500 ms (iframe content is LCP source) |
| TBT | 0 ms | < 200 ms ✓ |
| CLS | 0.181 | < 0.1 (lazy iframe mount; fix by reserving heights in CSS) |
| Total byte weight | 487,228 B | < 1 MB ✓ |

## Playwright responsive matrix — 12/12 passed

iPhone SE, iPhone 14, Pixel 7, iPad, Desktop sm, Desktop lg × EN + AR. All viewports: no horizontal scroll, all tap targets ≥ 32 px on mobile, 0 iframes with `pointer-events: none`.

## Build output

```
dist/
├── index.html           (12.3 KB)
├── ar/index.html        (13.9 KB)
├── _assets/<hash>.css   (inlined by Astro when small)
├── widgets.js           (4 KB - public/)
├── img/logo.svg
├── img/ig_hero.jpeg
└── fonts/Alexandria.ttf
```

Total `dist/` unzipped: ~1.6 MB (including the 1.4 MB Alexandria font file).

## Source size

```
src/
├── pages/index.astro           (1 KB)
├── pages/ar/index.astro        (1 KB)
├── layouts/Base.astro          (1 KB)
├── components/*.astro (×7)    (~5 KB total)
├── data/widgets.js             (4 KB)
└── styles/global.css           (13 KB)
```

Screenshots under `test-results/screenshots/`. Lighthouse HTML reports under `test-results/lighthouse/`.
