import { Arrow } from '../components/Arrow';
import React from 'react';
import Layout from '@theme/Layout';
import Link from '@docusaurus/Link';

import { MobxTriad } from '../components/home/MobxTriad';
import { ExampleShowcase } from '../components/home/ExampleShowcase';
import { CommunitySection } from '../components/home/CommunitySection';
import './index.css';

export default function Home() {
  return (
    <Layout
      title="Big ideas. Simple state."
      description="MobX brings automatic reactivity to Dart and Flutter. Model your state with observables, update it with actions, and let your UI follow."
    >
      <main className="mobx-home">
        <section
          className="home-hero home-section"
          aria-labelledby="hero-title"
        >
          <div className="hero-copy">
            <h1 id="hero-title">
              Big ideas.
              <br />
              <em>Simple state.</em>
            </h1>
            <p>
              Make Dart and Flutter apps that stay in sync. MobX connects your data to the places that need it, automatically. So you can get on with the good stuff.
            </p>
            <div className="hero-actions">
              <Link className="home-button" to="/getting-started">
                Start building <Arrow />
              </Link>
              <a className="home-text-link" href="#examples">
                Try an example <Arrow down />
              </a>
            </div>
            <div className="hero-footnote">
              <span className="status-dot" />
              Open source. MIT licensed. Made for Dart.
            </div>
          </div>
          <MobxTriad />
        </section>
        <nav className="package-strip home-section" aria-label="MobX packages">
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
        <ExampleShowcase />
        <section id="how-it-works" className="pieces-section home-section" aria-labelledby="pieces-title">
          <div className="section-heading"><h2 id="pieces-title">Small pieces.<br/><em>Wonderful possibilities.</em></h2><p>Learn a few ideas. Use them everywhere.<br/>From your first counter to state shared across an entire app.</p></div>
          <div className="atomic-pieces">
            {[
              ['Observable', 'The state you care about.', 'A name, a cart, a collection. Make it observable and MobX can track who uses it.', '/api/observable', 'blue'],
              ['Action', 'A clear place to make changes.', 'Update one value or several together. Reactions see the state after the action finishes.', '/api/action', 'orange'],
              ['Computed', 'Answers that work themselves out.', 'Totals, filtered lists, validation. Describe how to derive a value, and let MobX keep it current.', '/api/observable#computed', 'violet'],
              ['Reaction', 'The right response to a change.', 'Save a draft or respond to a status update. Run an effect when the state it reads changes.', '/api/reaction', 'green'],
              ['Observer', 'Your Flutter UI, connected.', 'Read observables inside an Observer builder. It rebuilds when those dependencies change.', '/api/observers', 'pink'],
              ['Futures & streams', 'Async joins the conversation.', 'Observe request status and live events, using the same reactive ideas as the rest of your app.', '/api/observable#observablefuture', 'blue'],
            ].map(([name,tagline,body,url,color])=><Link className="atomic-piece" to={url} key={name}><span className={"atomic-symbol atomic-" + color} aria-hidden="true">{name==='Observable'?'o':name==='Computed'?'=':name==='Action'?'+':name==='Reaction'?'r':name==='Observer'?'O':'~'}</span><div><h3>{name}<Arrow/></h3><strong>{tagline}</strong><p>{body}</p></div></Link>)}
          </div>
        </section>
        <section
          className="learning-band home-section"
          aria-labelledby="learning-title"
        >
          <h2 id="learning-title">
            From your first counter
            <br />
            to your next big app.
          </h2>
          <div className="learning-links">
            <Link to="/getting-started">
              <span>Get up and running</span>
              <Arrow />
            </Link>
            <Link to="/guides/cheat-sheet">
              <span>Keep the cheat sheet close</span>
              <Arrow />
            </Link>
            <Link to="/examples/counter">
              <span>Learn through examples</span>
              <Arrow />
            </Link>
            <a href="https://www.packtpub.com/web-development/mobx-quick-start-guide">
              <span>Read the MobX Quick Start Guide</span>
              <Arrow />
            </a>
          </div>
        </section>
        <CommunitySection />
        <section className="home-close home-section">
          <h2>
            Make room for
            <br />
            what you’re building.
          </h2>
          <div>
            <p>Let MobX take care of keeping state in sync.</p>
            <Link className="home-button" to="/getting-started">
              Get started with MobX <Arrow />
            </Link>
          </div>
        </section>
      </main>
    </Layout>
  );
}
