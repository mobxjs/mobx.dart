import { Arrow } from '../Arrow';
import {Fragment} from 'vue';
import { testimonials } from '../../data/testimonials';
import { sponsors } from '../../data/sponsors';
import { useI18n } from '../../i18n';

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
  const { t: { value: { community: t } } } = useI18n();
  return (
    <section
      class="community-section home-section"
      aria-labelledby="community-title"
    >
      <div class="section-heading">
        <h2 id="community-title">
          {t.title[0]}
          <br />
          {t.title[1]}
        </h2>
        <p>
          {t.body[0]}
          <br />
          {t.body[1]}
        </p>
      </div>
      <Quotes items={testimonials} />
      <div class="sponsor-heading">
        <h3>{t.sponsors}</h3>
        <a href="https://opencollective.com/mobx/donate">
          {t.support} <Arrow />
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
        {t.past}{' '}
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
