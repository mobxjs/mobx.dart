import { PubBadge } from '../components/PubBadge';
import book from '../images/book.png';
import {
  BuildStatus,
  CoverageStatus,
  DiscordChat,
  FlutterFavorite,
  NetlifyStatus,
  PublishStatus,
} from '../components/Shield';
import { SponsorList } from '../components/Sponsor';
import { TestimonialList } from '../components/Testimonial';

import MobXLogo from '../images/mobx.svg';
import React from 'react';
import Layout from '@theme/Layout';

export default function () {
  return (
    <Layout>
      <HeroSection />
      <BadgesSection />
      <NutshellSection />
      <SponsorSection />
      <TestimonialSection />
      <ConcludingSection />
    </Layout>
  );
}

function HeroSection() {
  return (
    <Section
      containerClassName={
        'grid grid-cols-1 sm:grid-cols-2 gap-8 items-center justify-items-center'
      }
    >
      <div className={'order-2 sm:order-1'}>
        <div className={'text-4xl sm:text-6xl font-extrabold'}>
          <a href={'https://github.com/mobxjs/mobx'}>MobX</a> for Dart and
          Flutter
        </div>

        <div className={'text-2xl sm:text-3xl mb-8'}>
          Hassle free state-management for your Dart and Flutter apps.
        </div>

        <div className={'text-lg sm:text-xl text-gray-500 mb-32'}>
          Use the power of <code>Observables</code>, <code>Actions</code> and{' '}
          <code>Reactions</code> to supercharge the state in your apps.
        </div>

        <div className="flex flex-col sm:flex-row items-stretch sm:items-center gap-4 text-center">
          <a
            className={
              'text-2xl p-4 rounded-md sm:rounded-lg border-blue-800 border bg-blue-500 hover:bg-blue-600 hover:transition-colors hover:no-underline text-white hover:text-white'
            }
            href={'/getting-started'}
          >
            Get Started 🚀
          </a>
          <a
            className={
              'text-2xl p-4 rounded-md sm:rounded-lg border-blue-500 border-2 border-solid hover:no-underline hover:border-blue-600 hover:transition-colors '
            }
            href={'/concepts'}
          >
            Learn More...
          </a>
        </div>
      </div>

      <MobXLogo className={'order-1 sm:order-2 w-48 sm:w-80 lg:w-96'} />
    </Section>
  );
}

function BadgesSection() {
  return (
    <Section
      className={'bg-slate-300'}
      containerClassName={'grid grid-cols-1 sm:grid-cols-2 gap-8 items-center'}
    >
      <div className={'flex flex-col lg:flex-row gap-4 items-center'}>
        <FlutterFavorite />

        <ul className={'list-none text-xl'}>
          <li>
            🎉 With official support for{' '}
            <a href={'https://dart.dev/null-safety'}>Null Safety</a>
          </li>
          <li className={'my-2'}>
            Works on iOS, Android, Web, MacOS, Linux, Windows
          </li>
          <li>Dart 3.0 compatible</li>
        </ul>
      </div>

      <div className={'flex flex-wrap gap-2'}>
        <PubBadge name="mobx" />
        <PubBadge name="flutter_mobx" />
        <PubBadge name="mobx_codegen" />

        <BuildStatus />
        <PublishStatus />
        <CoverageStatus />
        <NetlifyStatus />
        <DiscordChat />
      </div>
    </Section>
  );
}

function NutshellSection() {
  return (
    <Section title={'In a nutshell...'}>
      <div className={'text-lg sm:text-2xl text-gray-500 mb-16 sm:columns-2'}>
        MobX is a state-management library that makes it simple to connect the
        reactive data of your application with the UI (or any observer). This
        wiring is <b>completely automatic</b> and feels very natural. As the
        application-developer, you focus purely on what reactive-data needs to
        be consumed <b>without worrying about keeping the two in sync</b>.
      </div>

      <div className={'flex flex-col'}>
        <div className={'grid grid-cols-1 lg:grid-cols-3 gap-4 sm:gap-8'}>
          <NutshellListItem
            title={'Observables'}
            index={1}
            detail={
              <div>
                Observables store the <b>reactive state</b> of your application.
                It will notify the associated reactions whenever the state
                changes. Observables can be simple primitives like numbers,
                strings, booleans to List, Map, Stream and Future.
              </div>
            }
          />
          <NutshellListItem
            title={'Actions'}
            index={2}
            detail={
              <div>
                Actions are responsible for <b>mutating</b> the reactive state.
                When the mutations happen, the notifications are fired
                immediately, causing all the reactions to execute. An action
                acts as an intentionally-named operation that changes the state
                of the application.
              </div>
            }
          />
          <NutshellListItem
            title={'Reactions'}
            index={3}
            detail={
              <div>
                Reactions, as the name suggests are responsible for{' '}
                <b>reacting to the state changes</b>. These can be anything from
                a simple console log, API calls to rendering the Flutter UI.
                Reaction (aka <i>"side-effect"</i>) is the only element that can
                take you out of the MobX reactivity loop.
              </div>
            }
          />
        </div>

        <div className={'col-span-3 text-center'}>
          <img
            src={require('../images/mobx-triad.png').default}
            alt="MobX Triad"
            className={'sm:col-span-3 text-center w-fit'}
          />
        </div>
      </div>
    </Section>
  );
}

function SponsorSection() {
  return (
    <Section className={'bg-slate-300'} title={'Sponsors'}>
      <div className={'text-xl mb-8'}>
        We are very thankful to our sponsors to make us part of their{' '}
        <i>Open Source Software (OSS)</i> program.
      </div>

      <SponsorList />
    </Section>
  );
}

function TestimonialSection() {
  return (
    <Section
      className={'bg-slate-800 text-gray-300'}
      title={'Tried, tested and said...'}
    >
      <TestimonialList />
    </Section>
  );
}
function ConcludingSection() {
  return (
    <Section
      containerClassName={'grid grid-cols-1 sm:grid-cols-2 gap-4 sm:gap-8'}
    >
      <div>
        <h2>Get Started 🚀</h2>

        <div className={'text-xl'}>
          Follow along with the{' '}
          <a href={'/getting-started'}>Getting Started Guide</a> to incorporate
          MobX within your Flutter project.
        </div>
      </div>

      <div>
        <h2>Go Deep 🧐</h2>

        <div className={'text-xl grid grid-cols-1 sm:grid-cols-2 gap-8'}>
          <div>
            For a deeper coverage of MobX, do check out the{' '}
            <a
              href={
                'https://www.packtpub.com/web-development/mobx-quick-start-guide'
              }
            >
              MobX Quick Start Guide
            </a>
            . Although the book uses the JavaScript version of MobX,{' '}
            <b>almost all</b> of the concepts are applicable to Dart and
            Flutter.
          </div>

          <a href="https://www.packtpub.com/web-development/mobx-quick-start-guide">
            <img src={book} alt={'MobX Quick Start Guide'} />
          </a>
        </div>
      </div>
    </Section>
  );
}

function NutshellListItem({
  title,
  detail,
  index,
}: {
  title: string;
  detail: React.ReactElement;
  index: number;
}) {
  // NOTE:
  // Have to specifically create this array to ensure the tailwindcss processor
  // does not exclude these classes
  const blue = ['bg-blue-100', 'bg-blue-200', 'bg-blue-300'];
  return (
    <aside
      className={`border border-solid border-blue-500 p-4 sm:p-8 rounded-lg ${
        blue[index - 1]
      }`}
    >
      <h2 className={'text-xl sm:text-2xl'}>
        <span
          className={
            'inline-block mr-4 rounded-lg px-4 py-2 text-lg sm:text-xl bg-blue-900 text-white'
          }
        >
          {index}
        </span>
        <span className={'text-blue-900'}>{title}</span>
      </h2>
      <div className={'text-lg sm:text-xl'}>{detail}</div>
    </aside>
  );
}

function Section({
  children,
  className,
  containerClassName,
  title,
}: {
  children: React.ReactNode;
  className?: string;
  containerClassName?: string;
  title?: string;
}) {
  return (
    <section className={`py-16 ${className}`}>
      <div className={`container ${containerClassName}`}>
        {title && <h1>{title}</h1>}
        {children}
      </div>
    </section>
  );
}
