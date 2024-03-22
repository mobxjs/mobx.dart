import { Section } from './Section';
import React from 'react';
import { sponsors } from '../../data/sponsors';

const Sponsor = ({ logo, url }) => {
  return (
    <a href={url} target={'_blank'}>
      <img src={logo} height={64} />
    </a>
  );
};

const SponsorList = () => {
  return (
    <>
      <ul className={'list-none flex flex-wrap items-center gap-8 p-0'}>
        {sponsors
          .filter((x) => x.active)
          .map((s) => (
            <li className={'inline-block'} key={s.url}>
              <Sponsor logo={s.logo} url={s.url} />
            </li>
          ))}
      </ul>

      <h2 className={'text-xl sm:text-2xl text-gray-500 mt-16 mb-8'}>
        Past Sponsors
      </h2>
      <ul
        className={'list-none flex flex-row items-center gap-8 sm:gap-16 p-0'}
      >
        {sponsors
          .filter((x) => !x.active)
          .map((s) => (
            <li className={'inline-block opacity-40'} key={s.url}>
              <Sponsor logo={s.logo} url={s.url} />
            </li>
          ))}
      </ul>
    </>
  );
};

export function SponsorSection() {
  return (
    <Section className={'bg-slate-100'} title={'Sponsors'}>
      <a
        href="https://opencollective.com/mobx/donate"
        target="_blank"
        className={'w-64 block'}
      >
        <img src="https://opencollective.com/mobx/donate/button@2x.png?color=blue" />
      </a>

      <div className={'text-xl my-8'}>
        We are very thankful to our sponsors to make us part of their{' '}
        <i>Open Source Software (OSS)</i> program.
      </div>

      <SponsorList />
    </Section>
  );
}
