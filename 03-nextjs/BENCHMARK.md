# V3 Next.js — Benchmark

Tested against `http://localhost:8003/` (Next.js 15 static export served with `http-server`) with 13 IR widgets loading from `irp.atnmo.com`.

## Lighthouse (headless Chromium)

| Category | Mobile | Desktop |
|---|---|---|
| Performance | **67** | **98** |
| Accessibility | **99** | **99** |
| Best Practices | **100** | - |
| SEO | **91** | **91** |

Mobile Perf of 67 is below the 80s that V2/V4 hit. The extra ~100 KB of React + Next runtime (even with `output: 'export'`) inflates cold-load on simulated 4G. LCP is 5.49 s vs V2 Astro's 3.09 s — the difference is purely the React bundle on the critical path.

## Core Web Vitals (mobile, simulated 4G)

| Metric | Value | Budget |
|---|---|---|
| LCP | 5490 ms | < 2500 ms (React bundle blocks) |
| TBT | 8 ms | < 200 ms ✓ |
| CLS | 0.181 | < 0.1 (iframe lazy mount; fixable) |
| Total byte weight | 865,748 B | < 1 MB (just barely ✓) |

## Playwright responsive matrix — 12/12 passed

Same matrix as V2/V4. All viewports: no horizontal scroll, tap targets OK, 0 iframes with `pointer-events: none`.

## Build output

```
out/
├── index.html           (39.5 KB — React render inlined + data)
├── ar/index.html        (42.1 KB)
├── _next/static/        (React runtime, ~100 KB gzipped)
├── widgets.js
├── img/{logo.svg, ig_hero.jpeg}
├── fonts/Alexandria.ttf
├── 404.html
└── index.txt            (Next.js internal)
```

Total `out/` unzipped: ~1.9 MB (includes 1.4 MB Alexandria font).

## Source size

```
app/
  (en)/layout.jsx, page.jsx           (~2.5 KB)
  (ar)/layout.jsx, ar/page.jsx        (~2.5 KB)
  global.css                          (13 KB)
components/
  TopBar, NavigationBar, Hero, Intro,
  InvestmentCase, StockTicker,
  WidgetTabs, Footer  (×8)            (~9 KB total)
lib/widgets.js                        (4 KB)
```
