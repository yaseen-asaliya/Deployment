export default function TopBar({ copy }) {
  return (
    <div className="topbar" role="navigation" aria-label={copy.irTeam}>
      <div className="topbar__inner">
        <div className="topbar__links">
          <a href="tel:+966920000000">{copy.contact}</a>
          <a href="mailto:ir@alsaifgallery.com">{copy.irTeam}</a>
        </div>
        <div className="topbar__links">
          <a href={copy.langToggleHref}>{copy.langToggle}</a>
        </div>
      </div>
    </div>
  );
}
