# Stack Recommendation for Future IR-Widget Client Deliveries

Use this document to pick which of the four shipped versions (`V1 Flutter`, `V2 Astro`, `V3 Next.js`, `V4 Plain HTML`) to hand off to a given client. The recommendation is driven by the client's existing tech stack, their team's maintenance profile, and the IR page's performance / SEO requirements.

---

## Quick decision tree

```
Is the client's existing site built in...?

  Flutter                        → V1 Flutter subtree (or recommend iframe of V4)
  Next.js / React SPA            → V3 Next.js (component library or built out/)
  Astro / Eleventy / static HTML → V2 Astro (built dist/) or V4 plain HTML
  WordPress / Drupal / Joomla    → V4 Plain HTML (page-builder drop-in)
  Vue / Nuxt / Svelte            → V4 Plain HTML (framework-agnostic)
  Salesforce / AEM / Sitecore    → V4 Plain HTML (iframe or page fragment)
  Green-field / no existing site → V2 Astro (default for best Lighthouse + SEO)

Does the client need a logged-in investor portal NOW or NEXT QUARTER?
  Yes → V3 Next.js (can extend to Node runtime for portal routes)
  No  → V2 Astro
```

---

## Per-scenario guidance

### Scenario A — Client has a Next.js or React site

**Recommendation:** V3 Next.js.

Two handoff options:
1. **Drop-in route.** Ship the built `out/` as a static subtree at `/ir/` on their domain. Deploy via their existing static hosting.
2. **Component library.** Zip `components/`, `lib/widgets.js`, `app/global.css`, `public/widgets.js`. The client's team imports `<WidgetTabs lang="en" />`, `<Hero copy={copy} />` etc. into their own App Router pages. The copy dictionary lives where they want.

Either way they get React idioms, JSX, hydration by default. If they later want a filings-search page or an investor portal, the same tree extends.

### Scenario B — Client has an Astro / static HTML site

**Recommendation:** V2 Astro.

Ship the built `dist/` or have them merge `src/components/`, `src/data/`, `src/styles/` into their own Astro tree. The component API is consistent: `<TopBar copy={copy} />`, `<WidgetTabs lang="en" />`, etc.

If they're **Eleventy / Hugo / Jekyll** and don't want another build tool: ship V4 Plain HTML instead. The output is an HTML file + CSS + JS — their existing build tool copies it as a static asset.

### Scenario C — Client has WordPress, Drupal, or Joomla

**Recommendation:** V4 Plain HTML.

Their webmaster creates a new Page in the CMS, switches to HTML mode, and pastes the `<body>` contents of `index.html`. Upload `assets/css/main.css`, `assets/js/widgets.js`, `assets/img/*`, `assets/fonts/*` to the site's media library or a `/wp-content/alsaif-ir/` directory. Adjust the asset paths in the pasted HTML.

Alternatively, for page-builder-heavy sites (Elementor, Divi): wrap the IR page in an iframe pointing at a subdomain `ir.clientdomain.com/` where V4 is deployed standalone.

### Scenario D — Client has Vue, Nuxt, Svelte, or SolidStart

**Recommendation:** V4 Plain HTML.

Our V3 is React-specific; V2 Astro's `.astro` syntax is also framework-agnostic at output but requires Astro CLI at build time. For clients who want framework purity, drop in V4. If they insist on a native Vue component: this folder does not contain one; quote a 2-3 day port of V2 Astro components to `.vue` single-file components and reuse `widgets.js` verbatim.

### Scenario E — Client has a Flutter app (mobile or web)

**Recommendation:** Depends on context.

- If the Flutter app is a **mobile app** — IR content should live in a **web view** pointing at a deployed V2 or V4 build. Embedding 15 iframes inside a mobile app is ergonomically wrong.
- If the Flutter app is a **web app** — ship V1 Flutter widget subtree (the patched `lib/widgets/*_widget.dart` files + `external_script_widget.dart`) for them to integrate. This is the only scenario where V1 is the *right* answer for a future client.

### Scenario F — Greenfield / IR microsite under its own subdomain

**Recommendation:** V2 Astro.

No existing stack constraints. Astro wins on Lighthouse, SEO, payload, DX. Deploy `dist/` to Cloudflare Pages / Netlify / Vercel (all free tier). Done.

### Scenario G — Client needs investor portal (auth, filings search, dashboards) within 6 months

**Recommendation:** V3 Next.js.

Public IR pages render as static (`output: 'export'`). When the portal is added, remove the `output: 'export'` line in `next.config.mjs` and deploy to a Node host. The same component tree supports both modes. Pure static stacks (V2/V4) can't extend without a full rewrite.

### Scenario H — Client wants Arabic + English + another language (e.g., French, Spanish)

All four versions support additional locales:

- **V1 Flutter:** add strings to `lib/utils/app_localizations.dart`, wire the selector in `top_bar.dart`. Days of work.
- **V2 Astro:** add a `COPY.fr` block in `src/data/widgets.js`, add `src/pages/fr/index.astro`. ~30 minutes.
- **V3 Next.js:** add `app/(fr)/fr/` route group + `COPY.fr`. ~30 minutes.
- **V4 Plain HTML:** create `fr.html` as a copy of `ar.html` with French translations. ~30 minutes.

For many locales (5+) with translator workflow, V3 Next.js + `next-intl` is the scalable choice.

---

## Per-stack operational profile

| Aspect | V1 Flutter | V2 Astro | V3 Next.js | V4 Plain HTML |
|---|---|---|---|---|
| Build required before ship? | Yes (Flutter SDK 3.24.5) | Yes (Node ≥ 20) | Yes (Node ≥ 18) | No |
| Source lines to maintain | ~30K (whole Flutter site) | ~400 (IR page only) | ~500 (IR page only) | ~400 |
| Time to onboard a new dev | 1–2 weeks (Dart) | 1–2 days (Astro) | Existing React devs: hours | Any dev: minutes |
| Deployment surface | Static site needs SW caching | Pure static | Pure static (export) or Node | Pure static |
| Works offline after first load | Yes (SW) | No (unless you add SW) | No (unless you add SW) | No |
| SEO / crawlers | Weak (client-rendered) | Strong (pre-rendered) | Strong (pre-rendered) | Strong (pre-rendered) |
| Mobile Lighthouse ceiling | ~70 (best case, HTML renderer) | 95+ | 80–85 (React runtime cost) | 95+ |
| JS shipped to browser | 2.5–3 MB (Dart) | ~4 KB | ~100 KB | ~4 KB |

---

## Default choice (when in doubt)

**V2 Astro** is the default. It:
- Matches any modern static host.
- Is the fastest to build, fastest to deploy.
- Has the best Lighthouse scores.
- Produces the smallest zip (excluding fonts).
- Uses `.astro` syntax that React/Vue/Svelte devs can all read.

Move away from V2 only when the scenario dictates — notably Next.js clients, WordPress clients, or clients with a portal roadmap.

---

## Anti-patterns to avoid

1. **Don't ship V1 Flutter for new clients.** It's the right fix for the *current* Alsaif project because we inherited it. For new work, Flutter Web is the wrong technology for a content-heavy IR microsite.
2. **Don't ship V3 Next.js to a WordPress client.** The React overhead is waste. Give them V4.
3. **Don't hand-customize V4 for every client** without a template script. If you find yourself editing `index.html` by hand for the 3rd client, switch that client to V2 Astro — the templating pays off.
4. **Don't load widgets eagerly on mobile.** Every version in this folder uses IntersectionObserver with 500 px rootMargin. Don't disable it.
5. **Don't set `pointer-events: none` on iframes.** This was the V1 anti-pattern that created the "unresponsive" bug. Iframes should be `pointer-events: auto` at all times.
6. **Don't forward iframe scroll events to the parent.** The browser does this natively when iframe content can't scroll further. Forwarders create the exact scroll-arena confusion that motivated the V1 pointer-events hack.
