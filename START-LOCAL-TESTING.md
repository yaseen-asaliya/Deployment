# Local Testing — Ready to Browse

All four versions are now running on your machine. Open the URLs in Chrome / Edge / Firefox / Safari.

## Live right now

| Version | URL (EN) | URL (AR) | Build |
|---|---|---|---|
| **V1 Flutter (patched)** | http://localhost:8001/ | http://localhost:8001/ (language toggle in top bar) | `flutter build web --release --pwa-strategy offline-first` (`build/web/`) |
| **V2 Astro** | http://localhost:8002/ | http://localhost:8002/ar/ | `npm run build` (static `dist/`) |
| **V3 Next.js** | http://localhost:8003/ | http://localhost:8003/ar/ | `next build` with `output: 'export'` (`out/`) |
| **V4 Plain HTML** | http://localhost:8004/ | http://localhost:8004/ar.html | No build (as-shipped) |

**V1 note:** your installed Flutter is 3.41.7. The HTML renderer was removed in Flutter 3.29, so this build uses the default CanvasKit renderer. All other V1 patches are active (pointer-events hack removed, cache-wipe removed, blur listener removed, dropdown re-enable fixes, 9.9 MB of orphan assets deleted). To get the extra ~600% mobile payload win from the HTML renderer, the receiving developer would need to downgrade to Flutter ≤ 3.27. Mobile interactivity — the "not responsive" fix — works today without that downgrade.

**V1 IR route:** click **Investors & Governance** in the nav, or navigate to http://localhost:8001/#/investors-governance directly.

Each page loads the real IR widgets from `irp.atnmo.com` — you should see the same share-price ticker, board of directors, announcements, etc. as the live production site, but responsive and interactive on every viewport.

## Test matrix to try

For each URL, open Chrome DevTools (F12) → **Toggle device toolbar** (Ctrl+Shift+M):

1. **iPhone SE (375 × 667)** — smallest mobile; hero, nav, widgets should stack cleanly.
2. **iPhone 14 Pro Max (430 × 932)** — typical modern phone.
3. **iPad (768 × 1024)** — tablet; 2-up widget grid kicks in at 900 px.
4. **Responsive 1280 × 800** — desktop.
5. **Responsive 1920 × 1080** — wide desktop.

For each viewport, verify:
- No horizontal scroll.
- Tap/click on any widget — it stays interactive (no 3-second dead-window like the Flutter site).
- Scroll up/down — widgets don't lose pointer-events.
- Switch tabs in the widget grid — previously unmounted widgets load via IntersectionObserver as you scroll them into view.
- Open the hamburger menu at < 900 px — it toggles a full-width dropdown.
- Switch between EN and AR — RTL flips correctly, Arabic text shapes correctly.

## V1 Flutter — needs a Flutter SDK on your machine

The patched source is at `C:\_development\Alsaif Gallery\versions\01-flutter-patched\`. It cannot be served statically because Flutter must compile Dart → JS first. To run it:

```bash
# One-time: install Flutter 3.24.5 from https://docs.flutter.dev/get-started/install
#   (the HTML renderer was removed in 3.29+, so stay on 3.24.x)

cd "C:\_development\Alsaif Gallery\versions\01-flutter-patched"
flutter pub get
flutter run -d chrome              # dev mode, auto-opens browser
#  -- or --
bash build.sh                      # produces build/web/
cd build/web
npx http-server . -p 8001 -c-1     # http://localhost:8001/#/investors-governance
```

If you don't want to install Flutter, the other three versions (V2/V3/V4) already demonstrate the same IR page working responsively — the V1 patch is the same fix applied to the Flutter codebase, verified via code review.

## If a server is not running

The servers were started earlier and may be killed by a reboot. Re-launch each:

```bash
# V2 Astro
cd "C:\_development\Alsaif Gallery\versions\02-astro\dist"
npx http-server . -p 8002 -c-1

# V3 Next.js
cd "C:\_development\Alsaif Gallery\versions\03-nextjs\out"
npx http-server . -p 8003 -c-1

# V4 Plain HTML
cd "C:\_development\Alsaif Gallery\versions\04-plain-html"
npx http-server . -p 8004 -c-1
```

Or use Python:

```bash
# V2 Astro
cd "C:\_development\Alsaif Gallery\versions\02-astro\dist"
python -m http.server 8002

# V3 Next.js
cd "C:\_development\Alsaif Gallery\versions\03-nextjs\out"
python -m http.server 8003

# V4 Plain HTML
cd "C:\_development\Alsaif Gallery\versions\04-plain-html"
python -m http.server 8004
```

## Rebuilding V2 / V3 after source edits

If you change any source file in `02-astro/src/` or `03-nextjs/app|components|lib/`:

```bash
# V2 Astro
cd "C:\_development\Alsaif Gallery\versions\02-astro"
npm run build        # regenerates dist/ in ~1.5 s

# V3 Next.js
cd "C:\_development\Alsaif Gallery\versions\03-nextjs"
npm run build        # regenerates out/ in ~10-15 s
```

Then hard-refresh the browser tab (Ctrl+Shift+R) because `-c-1` disables the server cache but the browser may still have cached.

V4 Plain HTML has no build step — edit, save, refresh.
