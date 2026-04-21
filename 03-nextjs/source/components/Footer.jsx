export default function Footer({ copy }) {
  const year = new Date().getFullYear();
  return (
    <footer className="footer">
      <div className="footer__inner">
        <div>
          <img src="/img/logo.svg" alt="Al Saif Gallery" width="140" height="36" style={{ filter: 'brightness(0) invert(1)', marginBottom: '1rem' }} />
          <p style={{ fontSize: '.9rem' }}>{copy.footerTagline}</p>
        </div>
        <div>
          <h4>{copy.footerInvestors}</h4>
          <ul>
            <li><a href="#ir">{copy.footerLinks.irHome}</a></li>
            <li><a href="#widgets">{copy.footerLinks.sharePrice}</a></li>
            <li><a href="#widgets">{copy.footerLinks.financials}</a></li>
            <li><a href="#widgets">{copy.footerLinks.announcements}</a></li>
          </ul>
        </div>
        <div>
          <h4>{copy.footerCompany}</h4>
          <ul>
            <li><a href="#about">{copy.footerLinks.about}</a></li>
            <li><a href="#strategy">{copy.footerLinks.strategy}</a></li>
            <li><a href="#news">{copy.footerLinks.news}</a></li>
            <li><a href="#contact">{copy.footerLinks.contact}</a></li>
          </ul>
        </div>
        <div>
          <h4>{copy.footerContact}</h4>
          <ul>
            <li><a href="mailto:ir@alsaifgallery.com">ir@alsaifgallery.com</a></li>
            <li><a href="tel:+966920000000">+966 9200 00000</a></li>
          </ul>
        </div>
      </div>
      <div className="footer__bottom">© {year} Al Saif Gallery. {copy.copyright}</div>
    </footer>
  );
}
