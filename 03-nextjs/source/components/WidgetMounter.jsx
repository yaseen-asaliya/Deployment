'use client';
import { useEffect } from 'react';

// Mount IR widgets from irp.atnmo.com after React hydration. Running this as a
// <script src="/widgets.js" defer/> at page level doesn't work with Next.js —
// React hydration strips any DOM nodes added outside React's tree. A client
// useEffect runs post-hydration and owns the placeholder mutations.

const CONFIG = {
  uuid:      '5be9c146-613e-4141-a351-1f5e13fc5513',
  listingId: '81a06c05-1a48-4d1b-8dbd-bcf60a76730f',
  version:   'v3',
  loaderUrl: 'https://irp.atnmo.com/v3/widget/widget-loader.js',
};

let loaderPromise = null;
function loadScript(src) {
  if (loaderPromise) return loaderPromise;
  loaderPromise = new Promise((resolve, reject) => {
    if (typeof window.loadWidget === 'function') return resolve();
    const s = document.createElement('script');
    s.src = src; s.defer = true;
    s.onload = () => typeof window.loadWidget === 'function' ? resolve() : reject(new Error('loadWidget missing'));
    s.onerror = () => reject(new Error('Failed to load ' + src));
    document.head.appendChild(s);
  });
  return loaderPromise;
}

function mount(el, lang) {
  if (el.dataset.mounted === '1') return;
  el.dataset.mounted = '1';
  const widgetType = el.dataset.widget;
  if (!widgetType) return;
  if (!el.querySelector('[id$="-widget"]')) {
    const anchor = document.createElement('div');
    anchor.id = widgetType + '-widget';
    el.appendChild(anchor);
  }
  loadScript(CONFIG.loaderUrl).then(() => {
    try { window.loadWidget(widgetType, CONFIG.uuid, lang, CONFIG.listingId, CONFIG.version); }
    catch (err) { console.error('[IR] loadWidget failed for', widgetType, err); }
  }).catch(err => console.error('[IR] widget-loader.js failed', err));
}

function applyFilter(target) {
  document.querySelectorAll('.ir-section').forEach(s => {
    s.hidden = target !== 'all' && s.dataset.section !== target;
  });
  document.querySelectorAll('.ir-tab[data-target]').forEach(t => {
    const match = t.dataset.target === target;
    t.classList.toggle('is-active', match);
    t.setAttribute('aria-selected', match ? 'true' : 'false');
  });
  const sel = document.getElementById('ir-tab-select');
  if (sel && sel.value !== target) sel.value = target;
}

export default function WidgetMounter() {
  useEffect(() => {
    const lang = (document.documentElement.lang || 'en').toLowerCase().startsWith('ar') ? 'ar' : 'en';

    // Mount every widget placeholder immediately — eager mount avoids the
    // IntersectionObserver race where later widgets are pushed off-screen by
    // earlier ones expanding their iframes.
    document.querySelectorAll('[data-widget]').forEach(el => mount(el, lang));

    // Filter bar: desktop tabs
    const tabClick = (e) => {
      const t = e.currentTarget;
      if (t.dataset.target) applyFilter(t.dataset.target);
    };
    const tabs = document.querySelectorAll('.ir-tab[data-target]');
    tabs.forEach(t => t.addEventListener('click', tabClick));

    // Analytics dropdown
    const dropdowns = document.querySelectorAll('.ir-tab-dropdown');
    const cleanups = [];
    dropdowns.forEach(dd => {
      const btn = dd.querySelector('.ir-tab--dropdown');
      const menu = dd.querySelector('.ir-tab-dropdown__menu');
      if (!btn || !menu) return;
      const onBtn = (e) => { e.stopPropagation(); const open = !menu.hidden; menu.hidden = open; btn.setAttribute('aria-expanded', String(!open)); };
      btn.addEventListener('click', onBtn);
      const items = menu.querySelectorAll('[data-target]');
      const onItem = (item) => () => { menu.hidden = true; btn.setAttribute('aria-expanded', 'false'); applyFilter(item.dataset.target); };
      const itemHandlers = Array.from(items).map(i => { const h = onItem(i); i.addEventListener('click', h); return [i, h]; });
      const outside = (e) => { if (!dd.contains(e.target)) { menu.hidden = true; btn.setAttribute('aria-expanded', 'false'); } };
      document.addEventListener('click', outside);
      cleanups.push(() => {
        btn.removeEventListener('click', onBtn);
        itemHandlers.forEach(([i, h]) => i.removeEventListener('click', h));
        document.removeEventListener('click', outside);
      });
    });

    // Mobile <select>
    const sel = document.getElementById('ir-tab-select');
    const onSel = () => applyFilter(sel.value);
    if (sel) sel.addEventListener('change', onSel);

    // Mobile nav toggle
    const toggle = document.querySelector('.navbar__toggle');
    const menu = document.querySelector('.navbar__mobile-menu');
    const onToggle = () => {
      const expanded = toggle.getAttribute('aria-expanded') === 'true';
      toggle.setAttribute('aria-expanded', String(!expanded));
      menu.hidden = expanded;
    };
    if (toggle && menu) toggle.addEventListener('click', onToggle);

    // Initial filter = all
    applyFilter('all');

    return () => {
      tabs.forEach(t => t.removeEventListener('click', tabClick));
      cleanups.forEach(fn => fn());
      if (sel) sel.removeEventListener('change', onSel);
      if (toggle) toggle.removeEventListener('click', onToggle);
    };
  }, []);

  return null;
}
