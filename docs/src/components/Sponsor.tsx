import React from 'react';

export const Sponsor = ({ logo, url }) => {
  return (
    <a href={url}>
      <img src={logo} height={64} />
    </a>
  );
};

const sponsors = [
  {
    logo: require('../images/publicis-sapient-sponsor.png'),
    url: 'https://publicis.sapient.com'
  },
  {
    logo: require('../images/wunderdog-sponsor.png'),
    url: 'https://wunderdog.fi'
  },
  {
    logo: 'https://www.netlify.com/img/global/badges/netlify-color-bg.svg',
    url: 'https://www.netlify.com'
  }
];
export const SponsorList = () => {
  return (
    <ul style={{ listStyle: 'none', padding: 0 }}>
      {sponsors.map((s) => (
        <li
          style={{ display: 'inline-block', marginRight: 40, marginTop: 20 }}
          key={s.url}
        >
          <Sponsor logo={s.logo} url={s.url} />
        </li>
      ))}
    </ul>
  );
};
