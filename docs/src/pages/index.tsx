import { PubBadge } from '../components/PubBadge';
import book from '../images/book.png';
import {
  BuildStatus,
  CoverageStatus,
  DiscordChat,
  FlutterFavorite,
  NetlifyStatus,
  PublishStatus
} from '../components/Shield';
import { SponsorList } from '../components/Sponsor';
import { TestimonialList } from '../components/Testimonial';

import MobXLogo from '../images/mobx.svg';
import React from 'react';
import Layout from '@theme/Layout';

export default function() {
  return <Layout>
    <div className={'container my-32 grid grid-cols-2 gap-8 items-center justify-items-center'}>
      <div>
        <div className={'text-6xl font-extrabold'}>
          <a href={'https://github.com/mobxjs/mobx'}>MobX</a> for Dart and Flutter
        </div>

        <div className={'text-3xl mb-8'}>
          Hassle free state-management for your Dart and Flutter apps.
        </div>

        <div className={'text-xl text-gray-500 mb-32'}>
          Use the power of <code>Observables</code>, <code>Actions</code> and <code>Reactions</code> to supercharge the
          state in your apps.
        </div>

        <a
          className={'border-blue-800 border bg-blue-500 hover:bg-blue-600 hover:transition-colors text-2xl p-6 rounded-lg hover:no-underline text-white hover:text-white mr-4'}
          href={'/getting-started'}>Get Started 🚀</a>
        <a
          className={'border-blue-500 border-2 border-solid text-2xl p-6 rounded-lg hover:no-underline hover:border-blue-600 hover:transition-colors '}
          href={'/concepts'}>Learn
          More...</a>

      </div>

      <MobXLogo alt={'MobX logo'} width={512} />

    </div>

    <section className={'bg-blue-50'}>
      <div className={'grid grid-cols-3 gap-8 py-16 items-center container'}>
        <FlutterFavorite />

        <div className={'flex flex-wrap gap-4'}>
          <PubBadge name="mobx" />
          <PubBadge name="flutter_mobx" />
          <PubBadge name="mobx_codegen" />

          <BuildStatus />
          <PublishStatus />
          <CoverageStatus />
          <NetlifyStatus />
          <DiscordChat />

        </div>

        <ul className={'list-none text-2xl'}>
          <li>🎉 With official support for <a href={'https://dart.dev/null-safety'}>Null Safety</a></li>
          <li className={'text-gray-500 my-2'}>Works on iOS, Android, Web, MacOS, Linux, Windows</li>
          <li className={'text-gray-500'}>Dart 3.0 compatible</li>
        </ul>

      </div>
    </section>

    ## Introduction

    MobX is a state-management library that makes it simple to connect the reactive
    data of your application with the UI (or any observer). This wiring is
    completely automatic and feels very natural. As the application-developer, you
    focus purely on what reactive-data needs to be consumed in the UI (and
    elsewhere) without worrying about keeping the two in sync.

    It's not really magic, but it does have some smarts around what is being
    consumed (**observables**) and where (**reactions**), and automatically tracks
    it for you. When the _observables_ change, all _reactions_ are re-run. What's
    interesting is that these reactions can be anything from a simple console log, a
    network call to re-rendering the UI.

    > MobX has been a very effective library for the JavaScript apps and this port
    > to the Dart language aims to bring the same levels of productivity.

    <section className={'bg-slate-800 text-gray-300 py-16'}>
      <div className="container">
        <h1 className={'mb-16'}>Tried, tested and said...</h1>

        <TestimonialList />
      </div>
    </section>

    <section className={'py-8 my-16'}>
      <div className={'container grid grid-cols-2 gap-8'}>
        <div>
          <h2>Get Started 🚀</h2>

          <div className={'text-xl'}>
            Follow along with the <a href={'/getting-started'}>Getting Started Guide</a> to incorporate
            MobX within your Flutter project.
          </div>
        </div>

        <div>
          <h2>Go Deep 🧐</h2>

          <div className={'text-xl grid grid-cols-2 gap-8'}>
            <div>
              For a deeper coverage of MobX, do check out the <a
              href={'https://www.packtpub.com/web-development/mobx-quick-start-guide'}>MobX Quick Start Guide</a>.
              Although the book uses the JavaScript version of MobX, <b>almost all</b> of the
              concepts are applicable to Dart and Flutter.
            </div>

            <a href="https://www.packtpub.com/web-development/mobx-quick-start-guide">
              <img src={book} alt={'MobX Quick Start Guide'} />
            </a>
          </div>
        </div>
      </div>


    </section>

    ## Sponsors

    We are very thankful to our sponsors to make us part of their _Open Source
    Software (OSS)_ program.

    [[Become a sponsor](https://opencollective.com/mobx#sponsor)]

    <SponsorList />

  </Layout>;
}
