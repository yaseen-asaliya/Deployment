/* Al Saif Gallery IR — widget bootstrap (Flutter-parity layout)
 *
 * Default: all IR widgets are stacked with section titles.
 * Optional: a sticky filter bar lets the user show only one section at a time.
 *   - Desktop: horizontal tab row + "Analytics" dropdown (matches Flutter nav).
 *   - Mobile : single <select> dropdown (matches Flutter _MobileTabDropdown).
 *
 * Matches the Flutter behaviour in lib/screens/investors_governance_screen.dart:
 *   _selectedTab = -1   → show all   (here: filter = "all")
 *   _selectedTab >=  0  → show one   (here: filter = "<data-section>")
 */
(function () {
  'use strict';

  var CONFIG = {
    uuid:      '5be9c146-613e-4141-a351-1f5e13fc5513',
    listingId: '81a06c05-1a48-4d1b-8dbd-bcf60a76730f',
    version:   'v3',
    loaderUrl: 'https://irp.atnmo.com/v3/widget/widget-loader.js',
    rootMargin: '500px',
  };

  var lang = (document.documentElement.lang || 'en').toLowerCase().startsWith('ar') ? 'ar' : 'en';

  // ── Widget loader ────────────────────────────────────────────────────────
  var loaderPromise = null;
  function loadScript(src) {
    if (loaderPromise) return loaderPromise;
    loaderPromise = new Promise(function (resolve, reject) {
      if (typeof window.loadWidget === 'function') return resolve();
      var s = document.createElement('script');
      s.src = src; s.defer = true;
      s.onload = function () {
        if (typeof window.loadWidget === 'function') resolve();
        else reject(new Error('widget-loader.js loaded but loadWidget is missing'));
      };
      s.onerror = function () { reject(new Error('Failed to load ' + src)); };
      document.head.appendChild(s);
    });
    return loaderPromise;
  }

  function mount(el) {
    if (el.dataset.mounted === '1') return;
    el.dataset.mounted = '1';
    var widgetType = el.dataset.widget;
    if (!widgetType) return;
    if (!el.querySelector('[id$="-widget"]')) {
      var anchor = document.createElement('div');
      anchor.id = widgetType + '-widget';
      el.appendChild(anchor);
    }
    loadScript(CONFIG.loaderUrl).then(function () {
      try {
        window.loadWidget(widgetType, CONFIG.uuid, lang, CONFIG.listingId, CONFIG.version);
      } catch (err) {
        console.error('[IR] loadWidget failed for', widgetType, err);
      }
    }).catch(function (err) {
      console.error('[IR] widget-loader.js failed to load', err);
    });
  }

  function initLazy() {
    var placeholders = document.querySelectorAll('[data-widget]');
    if (!placeholders.length) return;
    // Mount all immediately. We had used IntersectionObserver for lazy mounting,
    // but widget-loader.js sets iframe height via iFrameResize post-message after
    // load, which changes document height AFTER the initial observer pass. On a
    // page with 15 widgets, later widgets were pushed beyond the rootMargin
    // before they ever intersected, so they never mounted. Eager mount is
    // simpler and matches what the Flutter version does (each widget mounts as
    // its HtmlElementView enters the Dart widget tree).
    placeholders.forEach(mount);
  }

  // ── Section filter (Flutter _selectedTab parity) ─────────────────────────
  function applyFilter(target) {
    var sections = document.querySelectorAll('.ir-section');
    sections.forEach(function (s) {
      var id = s.dataset.section;
      s.hidden = (target !== 'all' && id !== target);
    });

    // Sync tab active state
    document.querySelectorAll('.ir-tab[data-target]').forEach(function (t) {
      var match = t.dataset.target === target;
      t.classList.toggle('is-active', match);
      t.setAttribute('aria-selected', match ? 'true' : 'false');
    });
    document.querySelectorAll('.ir-tab-dropdown__menu [data-target]').forEach(function (t) {
      t.classList.toggle('is-active', t.dataset.target === target);
    });
    var sel = document.getElementById('ir-tab-select');
    if (sel && sel.value !== target) sel.value = target;
  }

  function initFilter() {
    // Desktop tabs
    document.querySelectorAll('.ir-tab[data-target]').forEach(function (t) {
      t.addEventListener('click', function () { applyFilter(t.dataset.target); });
    });
    // Analytics dropdown
    document.querySelectorAll('.ir-tab-dropdown').forEach(function (dd) {
      var btn = dd.querySelector('.ir-tab--dropdown');
      var menu = dd.querySelector('.ir-tab-dropdown__menu');
      if (!btn || !menu) return;
      btn.addEventListener('click', function (e) {
        e.stopPropagation();
        var open = !menu.hidden;
        menu.hidden = open;
        btn.setAttribute('aria-expanded', String(!open));
      });
      menu.querySelectorAll('[data-target]').forEach(function (item) {
        item.addEventListener('click', function () {
          menu.hidden = true;
          btn.setAttribute('aria-expanded', 'false');
          applyFilter(item.dataset.target);
        });
      });
      document.addEventListener('click', function (e) {
        if (!dd.contains(e.target)) { menu.hidden = true; btn.setAttribute('aria-expanded', 'false'); }
      });
    });
    // Mobile select
    var sel = document.getElementById('ir-tab-select');
    if (sel) sel.addEventListener('change', function () { applyFilter(sel.value); });
    // Initial state: show all
    applyFilter('all');
  }

  // ── Mobile nav toggle ────────────────────────────────────────────────────
  function initMobileNav() {
    var toggle = document.querySelector('.navbar__toggle');
    var menu = document.querySelector('.navbar__mobile-menu');
    if (!toggle || !menu) return;
    toggle.addEventListener('click', function () {
      var expanded = toggle.getAttribute('aria-expanded') === 'true';
      toggle.setAttribute('aria-expanded', String(!expanded));
      menu.hidden = expanded;
    });
  }

  function boot() { initLazy(); initFilter(); initMobileNav(); }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', boot);
  } else { boot(); }
})();
