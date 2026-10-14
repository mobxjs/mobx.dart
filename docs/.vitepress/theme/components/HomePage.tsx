import {Eye,Zap,Calculator,Sparkles,PanelsTopLeft,Radio} from '@lucide/vue';
import { Arrow } from './Arrow';
import { MobxTriad } from './home/MobxTriad';
import { ExampleShowcase } from './home/ExampleShowcase';
import { CommunitySection } from './home/CommunitySection';
import { CompanyLogos } from './home/CompanyLogos';
import { useI18n } from '../i18n';

const pieces = [
  ['observable', Eye, '/api/observable', 'blue'],
  ['action', Zap, '/api/action', 'orange'],
  ['computed', Calculator, '/api/observable#computed', 'violet'],
  ['reaction', Sparkles, '/api/reaction', 'green'],
  ['observer', PanelsTopLeft, '/api/observers', 'pink'],
  ['async', Radio, '/api/observable#observablefuture', 'blue'],
] as const;

export default function Home() {
  const { t: { value: t }, link } = useI18n();
  return (
    <>
      <div class="mobx-home">
        <section
          class="home-hero home-section"
          aria-labelledby="hero-title"
        >
          <div class="hero-copy">
            <h1 id="hero-title">
              {t.hero.title[0]}
              <br />
              <em>{t.hero.title[1]}</em>
            </h1>
            <p>
              {t.hero.body}
            </p>
            <div class="hero-actions">
              <a class="home-button" href={link('/getting-started')}>
                {t.hero.start} <Arrow />
              </a>
              <a class="home-text-link" href="#examples">
                {t.hero.example} <Arrow down />
              </a>
            </div>
            <div class="hero-footnote">
              <span class="status-dot" />
              {t.hero.footnote}
            </div>
          </div>
          <MobxTriad />
        </section>
        <nav class="package-strip home-section" aria-label={t.packages.label}>
          <span>
            {t.packages.title[0]}
            <br />
            <strong>{t.packages.title[1]}</strong>
          </span>
          <a href="https://pub.dev/packages/mobx">
            <code>mobx</code>
            <span>
              {t.packages.mobx} <Arrow />
            </span>
          </a>
          <a href="https://pub.dev/packages/flutter_mobx">
            <code>flutter_mobx</code>
            <span>
              {t.packages.flutter} <Arrow />
            </span>
          </a>
          <a href="https://pub.dev/packages/mobx_codegen">
            <code>mobx_codegen</code>
            <span>
              {t.packages.codegen} <Arrow />
            </span>
          </a>
        </nav>
        <CompanyLogos />
        <ExampleShowcase />
        <section id="how-it-works" class="pieces-section home-section" aria-labelledby="pieces-title">
          <div class="section-heading"><h2 id="pieces-title">{t.pieces.title[0]}<br/><em>{t.pieces.title[1]}</em></h2><p>{t.pieces.body[0]}<br/>{t.pieces.body[1]}</p></div>
          <div class="atomic-pieces">
            {pieces.map(([id,Icon,url,color])=>{const [name,tagline,body]=t.pieces.items[id];return <a class="atomic-piece" href={link(url)} key={id}><span class={"atomic-symbol atomic-" + color} aria-hidden="true"><Icon/></span><div><h3>{name}<Arrow/></h3><strong>{tagline}</strong><p>{body}</p></div></a>;})}
          </div>
        </section>
        <section
          class="learning-band home-section"
          aria-labelledby="learning-title"
        >
          <h2 id="learning-title">
            {t.learning.title[0]}
            <br />
            {t.learning.title[1]}
          </h2>
          <div class="learning-links">
            <a href={link('/getting-started')}>
              <span>{t.learning.start}</span>
              <Arrow />
            </a>
            <a href={link('/guides/cheat-sheet')}>
              <span>{t.learning.cheatSheet}</span>
              <Arrow />
            </a>
            <a href={link('/gallery/')}>
              <span>{t.learning.examples}</span>
              <Arrow />
            </a>
            <a href="https://www.packtpub.com/en-us/product/mobx-quick-start-guide-9781789344837">
              <span>{t.learning.book}</span>
              <Arrow />
            </a>
          </div>
        </section>
        <CommunitySection />
        <section class="home-close home-section">
          <h2>
            {t.close.title[0]}
            <br />
            {t.close.title[1]}
          </h2>
          <div>
            <p>{t.close.body}</p>
            <a class="home-button" href={link('/getting-started')}>
              {t.close.button} <Arrow />
            </a>
          </div>
        </section>
      </div>
    </>
  );
}
