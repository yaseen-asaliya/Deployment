export default function Hero({ copy }) {
  return (
    <section className="hero" id="ir">
      <div className="hero__inner">
        <div className="hero__eyebrow">{copy.eyebrow}</div>
        <h1 className="hero__title">{copy.heroTitle}</h1>
        <p className="hero__subtitle">{copy.heroSubtitle}</p>
      </div>
    </section>
  );
}
