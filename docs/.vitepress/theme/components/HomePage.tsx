import {Eye,Zap,Calculator,Sparkles,PanelsTopLeft,Radio} from '@lucide/vue';
import { Arrow } from './Arrow';
import { MobxTriad } from './home/MobxTriad';
import { ExampleShowcase } from './home/ExampleShowcase';
import { CommunitySection } from './home/CommunitySection';
import { CompanyLogos } from './home/CompanyLogos';


export default function Home() {
  return (
    <>
      <div class="mobx-home">
        <section
          class="home-hero home-section"
          aria-labelledby="hero-title"
        >
          <div class="hero-copy">
            <h1 id="hero-title">
              Big ideas.
              <br />
              <em>Simple state.</em>
            </h1>
            <p>
              Make Dart and Flutter apps that stay in sync. MobX connects your data to the places that need it, automatically. So you can get on with the good stuff.
            </p>
            <div class="hero-actions">
              <a class="home-button" href="/getting-started">
                Start building <Arrow />
              </a>
              <a class="home-text-link" href="#examples">
                Try an example <Arrow down />
              </a>
            </div>
            <div class="hero-footnote">
              <span class="status-dot" />
              Open source. MIT licensed. Made for Dart.
            </div>
          </div>
          <MobxTriad />
        </section>
        <nav class="package-strip home-section" aria-label="MobX packages">
          <span>
            Small pieces.
            <br />
            <strong>One reactive system.</strong>
          </span>
          <a href="https://pub.dev/packages/mobx">
            <code>mobx</code>
            <span>
              The reactive core <Arrow />
            </span>
          </a>
          <a href="https://pub.dev/packages/flutter_mobx">
            <code>flutter_mobx</code>
            <span>
              Reactive Flutter widgets <Arrow />
            </span>
          </a>
          <a href="https://pub.dev/packages/mobx_codegen">
            <code>mobx_codegen</code>
            <span>
              Less boilerplate <Arrow />
            </span>
          </a>
        </nav>
        <CompanyLogos />
        <ExampleShowcase />
        <section id="how-it-works" class="pieces-section home-section" aria-labelledby="pieces-title">
          <div class="section-heading"><h2 id="pieces-title">Small pieces.<br/><em>Wonderful possibilities.</em></h2><p>Learn a few ideas. Use them everywhere.<br/>From your first counter to state shared across an entire app.</p></div>
          <div class="atomic-pieces">
            {[
              ['Observable', 'The state you care about.', 'A name, a cart, a collection. Make it observable and MobX can track who uses it.', '/api/observable', 'blue'],
              ['Action', 'A clear place to make changes.', 'Update one value or several together. Reactions see the state after the action finishes.', '/api/action', 'orange'],
              ['Computed', 'Answers that work themselves out.', 'Totals, filtered lists, validation. Describe how to derive a value, and let MobX keep it current.', '/api/observable#computed', 'violet'],
              ['Reaction', 'The right response to a change.', 'Save a draft or respond to a status update. Run an effect when the state it reads changes.', '/api/reaction', 'green'],
              ['Observer', 'Your Flutter UI, connected.', 'Read observables inside an Observer builder. It rebuilds when those dependencies change.', '/api/observers', 'pink'],
              ['Futures & streams', 'Async joins the conversation.', 'Observe request status and live events, using the same reactive ideas as the rest of your app.', '/api/observable#observablefuture', 'blue'],
            ].map(([name,tagline,body,url,color])=><a class="atomic-piece" href={url} key={name}><span class={"atomic-symbol atomic-" + color} aria-hidden="true">{name==='Observable'?<Eye/>:name==='Computed'?<Calculator/>:name==='Action'?<Zap/>:name==='Reaction'?<Sparkles/>:name==='Observer'?<PanelsTopLeft/>:<Radio/>}</span><div><h3>{name}<Arrow/></h3><strong>{tagline}</strong><p>{body}</p></div></a>)}
          </div>
        </section>
        <section
          class="learning-band home-section"
          aria-labelledby="learning-title"
        >
          <h2 id="learning-title">
            From your first counter
            <br />
            to your next big app.
          </h2>
          <div class="learning-links">
            <a href="/getting-started">
              <span>Get up and running</span>
              <Arrow />
            </a>
            <a href="/guides/cheat-sheet">
              <span>Keep the cheat sheet close</span>
              <Arrow />
            </a>
            <a href="/gallery/">
              <span>Learn through examples</span>
              <Arrow />
            </a>
            <a href="https://www.packtpub.com/en-us/product/mobx-quick-start-guide-9781789348972">
              <span>Read the MobX Quick Start Guide</span>
              <Arrow />
            </a>
          </div>
        </section>
        <CommunitySection />
        <section class="home-close home-section">
          <h2>
            Make room for
            <br />
            what you’re building.
          </h2>
          <div>
            <p>Let MobX take care of keeping state in sync.</p>
            <a class="home-button" href="/getting-started">
              Get started with MobX <Arrow />
            </a>
          </div>
        </section>
      </div>
    </>
  );
}
