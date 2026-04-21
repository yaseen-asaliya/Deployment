import TopBar from '../../../components/TopBar.jsx';
import NavigationBar from '../../../components/NavigationBar.jsx';
import Hero from '../../../components/Hero.jsx';
import Intro from '../../../components/Intro.jsx';
import InvestmentCase from '../../../components/InvestmentCase.jsx';
import StockTicker from '../../../components/StockTicker.jsx';
import WidgetTabs from '../../../components/WidgetTabs.jsx';
import Footer from '../../../components/Footer.jsx';
import WidgetMounter from '../../../components/WidgetMounter.jsx';
import { COPY, CASE_ITEMS } from '../../../lib/widgets.js';

export default function Page() {
  const lang = 'ar';
  const copy = COPY[lang];
  const items = CASE_ITEMS[lang];
  return (
    <>
      <TopBar copy={copy} />
      <NavigationBar copy={copy} />
      <Hero copy={copy} />
      <Intro copy={copy} />
      <InvestmentCase copy={copy} items={items} />
      <StockTicker />
      <WidgetTabs lang={lang} />
      <Footer copy={copy} />
      <WidgetMounter />
    </>
  );
}
