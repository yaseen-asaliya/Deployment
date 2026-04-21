export default function NavigationBar({ copy }) {
  const links = [
    { href: '#home',     label: copy.navHome },
    { href: '#about',    label: copy.navAbout },
    { href: '#strategy', label: copy.navStrategy },
    { href: '#ir',       label: copy.navIR, active: true },
    { href: '#news',     label: copy.navNews },
    { href: '#contact',  label: copy.navContact },
  ];
  return (
    <nav className="navbar" aria-label="Primary">
      <div className="navbar__inner">
        <a className="navbar__logo" href="/" aria-label="Al Saif Gallery">
          <img src="/img/logo.svg" alt="Al Saif Gallery" width="160" height="40" />
        </a>
        <ul className="navbar__links" role="menubar">
          {links.map(l => (
            <li role="none" key={l.href}>
              <a role="menuitem" href={l.href} className={l.active ? 'is-active' : ''} aria-current={l.active ? 'page' : undefined}>{l.label}</a>
            </li>
          ))}
        </ul>
        <button className="navbar__toggle" type="button" aria-expanded="false" aria-controls="mobile-menu" aria-label="Menu">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
            <line x1="3" y1="6" x2="21" y2="6"/>
            <line x1="3" y1="12" x2="21" y2="12"/>
            <line x1="3" y1="18" x2="21" y2="18"/>
          </svg>
        </button>
        <div className="navbar__mobile-menu" id="mobile-menu" hidden>
          <ul>
            {links.map(l => (
              <li key={l.href}><a href={l.href} className={l.active ? 'is-active' : ''}>{l.label}</a></li>
            ))}
          </ul>
        </div>
      </div>
    </nav>
  );
}
