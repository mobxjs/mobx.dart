import { Section } from './Section';
import {
  BuildStatus,
  CoverageStatus,
  DiscordChat,
  FlutterFavorite,
  NetlifyStatus,
  PubBadge,
  PublishStatus,
} from '../Shield';
import React from 'react';

export function BadgesSection() {
  return (
    <Section className={'bg-slate-100'}>
      <div className="flex flex-col sm:flex-row gap-8 items-center justify-center pb-8">
        <Statistic stat={'2.3K+'}>
          <div className={'flex flex-row items-center'}>
            Github <Star />
          </div>
        </Statistic>
        <Statistic stat={'18,000+'}> Projects</Statistic>
        <Statistic stat={'~70'}>Contributors</Statistic>
      </div>

      <div className={'grid grid-cols-1 sm:grid-cols-2 gap-8 items-center'}>
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
      </div>
    </Section>
  );
}

function Statistic({
  stat,
  children,
}: {
  stat: string;
  children: React.ReactNode;
}) {
  return (
    <div
      className={
        'flex flex-col items-center bg-white p-8 rounded-lg text-center shadow-xl'
      }
    >
      <div className={'text-3xl font-bold font-mono'}>{stat}</div>
      <div>{children}</div>
    </div>
  );
}

function Star() {
  return (
    <svg
      aria-hidden="true"
      height="16"
      viewBox="0 0 16 16"
      version="1.1"
      width="16"
      className="inline-block mx-1 fill-amber-400"
    >
      <path d="M8 .25a.75.75 0 0 1 .673.418l1.882 3.815 4.21.612a.75.75 0 0 1 .416 1.279l-3.046 2.97.719 4.192a.751.751 0 0 1-1.088.791L8 12.347l-3.766 1.98a.75.75 0 0 1-1.088-.79l.72-4.194L.818 6.374a.75.75 0 0 1 .416-1.28l4.21-.611L7.327.668A.75.75 0 0 1 8 .25Z"></path>
    </svg>
  );
}
