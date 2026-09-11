import { Arrow } from '../Arrow';
import {Fragment} from 'vue';
import { testimonials } from '../../data/testimonials';
import { sponsors } from '../../data/sponsors';

function Quotes({ items }: { items: typeof testimonials }) {
  return (
    <div class="community-quotes">
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
      class="community-section home-section"
      aria-labelledby="community-title"
    >
      <div class="section-heading">
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
      <Quotes items={testimonials} />
      <div class="sponsor-heading">
        <h3>Supported by our sponsors</h3>
        <a href="https://opencollective.com/mobx/donate">
          Support MobX <Arrow />
        </a>
      </div>
      <ul class="sponsor-list">
        {sponsors
          .filter((s) => s.active)
          .map((s) => (
            <li key={s.url}>
              <a href={s.url} aria-label={s.name}>
                <img src={s.logo} alt={s.name === 'Vyuh' ? '' : s.name} width={s.name === 'Vyuh' ? 44 : 144} height="44" loading="lazy" />
                {s.name === 'Vyuh' && <span>Vyuh</span>}
              </a>
            </li>
          ))}
      </ul>
      <p class="past-sponsors">
        With thanks to our past sponsors:{' '}
        {sponsors
          .filter((s) => !s.active)
          .map((s, i) => (
            <Fragment key={s.url}>
              {i > 0 && ' · '}
              <a href={s.url}>{s.name}</a>
            </Fragment>
          ))}
      </p>
    </section>
  );
}
