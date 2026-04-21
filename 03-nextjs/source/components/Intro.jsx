export default function Intro({ copy }) {
  return (
    <section className="intro">
      <div className="intro__inner">
        <div>
          <h2 className="intro__title" dangerouslySetInnerHTML={{ __html: copy.introTitle }} />
        </div>
        <div className="intro__body">
          {copy.introBody.map((p, i) => <p key={i}>{p}</p>)}
        </div>
      </div>
    </section>
  );
}
