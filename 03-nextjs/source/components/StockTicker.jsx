export default function StockTicker() {
  return (
    <section className="ticker" aria-label="Live share price">
      <div className="ticker__inner">
        <div className="widget" style={{ border: 'none', boxShadow: 'none', marginBottom: 0 }}>
          <div className="widget__body" data-widget="stock-ticker"></div>
        </div>
      </div>
    </section>
  );
}
