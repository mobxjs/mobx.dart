import { Arrow } from '../Arrow';
import React from 'react';
import { testimonials } from '../../data/testimonials';
import { sponsors } from '../../data/sponsors';

function Quotes({ items }: { items: typeof testimonials }) {
  return (
    <div className="community-quotes">
      {items.map((person) => (
        <figure key={person.author}>
          <blockquote>{person.message}</blockquote>
          <figcaption>
            <img
              src={person.photoUrl}
              alt=""
              width="40"
              height="40"
              loading="lazy"
            />
            <div>
              <a href={person.twitter}>{person.author}</a>
              <span>{person.title}</span>
            </div>
          </figcaption>
        </figure>
      ))}
    </div>
  );
}

export function CommunitySection() {
  return (
    <section
      className="community-section home-section"
      aria-labelledby="community-title"
    >
      <div className="section-heading">
        <h2 id="community-title">
          Built in the open.
          <br />
          Used in the real world.
        </h2>
        <p>
          Part of the Dart and Flutter community.
          <br />
          Here’s what developers have shared.
        </p>
      </div>
      <Quotes items={testimonials.slice(1, 3)} />
      <details className="more-stories">
        <summary>More from the community</summary>
        <Quotes items={[testimonials[0], ...testimonials.slice(3)]} />
      </details>
      <div className="sponsor-heading">
        <h3>Supported by our sponsors</h3>
        <a href="https://opencollective.com/mobx/donate">
          Support MobX <Arrow />
        </a>
      </div>
      <ul className="sponsor-list">
        {sponsors
          .filter((s) => s.active)
          .map((s) => (
            <li key={s.url}>
              <a href={s.url}>{s.name}</a>
            </li>
          ))}
      </ul>
      <p className="past-sponsors">
        With thanks to our past sponsors:{' '}
        {sponsors
          .filter((s) => !s.active)
          .map((s, i) => (
            <React.Fragment key={s.url}>
              {i > 0 && ' · '}
              <a href={s.url}>{s.name}</a>
            </React.Fragment>
          ))}
      </p>
    </section>
  );
}
