export default function InvestmentCase({ copy, items }) {
  return (
    <section className="case">
      <div className="case__inner">
        <div className="case__header">
          <div className="case__eyebrow">{copy.caseEyebrow}</div>
          <h2 className="case__title">{copy.caseTitle}</h2>
        </div>
        <div className="case__grid">
          {items.map(item => (
            <article className="case__item" key={item.n}>
              <div className="case__num">{item.n}</div>
              <h3>{item.title}</h3>
              <p>{item.body}</p>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}
