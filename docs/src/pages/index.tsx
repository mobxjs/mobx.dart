import book from '../images/book.png';
import {
  BuildStatus,
  CoverageStatus,
  DiscordChat,
  FlutterFavorite,
  NetlifyStatus,
  PubBadge,
  PublishStatus,
} from '../components/Shield';
import { SponsorList } from '../components/home/Sponsor';
import { TestimonialList } from '../components/home/Testimonial';
import React from 'react';
import Layout from '@theme/Layout';
import { Section } from '../components/home/Section';
import { NutshellSection } from '../components/home/NutshellSection';
import { HeroSection } from '../components/home/HeroSection';

export default function () {
  return (
    <Layout>
      <HeroSection />
      <BadgesSection />
      <NutshellSection />
      <TestimonialSection />
      <SponsorSection />
      <ConcludingSection />
    </Layout>
  );
}

function BadgesSection() {
  return (
    <Section
      className={'bg-slate-100'}
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

function SponsorSection() {
  return (
    <Section className={'bg-slate-100'} title={'Sponsors'}>
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
