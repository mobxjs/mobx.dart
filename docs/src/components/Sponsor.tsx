import React from 'react';
import { sponsors } from '../data/sponsors';

export const Sponsor = ({ logo, url }) => {
  return (
    <a href={url}>
      <img src={logo} height={64} />
    </a>
  );
};

export const SponsorList = () => {
  return (
    <>
      <ul
        className={'list-none flex flex-row items-center gap-8 sm:gap-16 p-0'}
      >
        <a
          href={'https://opencollective.com/mobx#sponsor'}
          className={
            'bg-slate-300 hover:bg-blue-300 rounded-lg items-center flex flex-col px-4 py-2 hover:no-underline'
          }
        >
          <div className={'text-5xl'}>+</div>
          <div className={'text-lg sm:text-xl'}>Become a sponsor</div>
        </a>

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
