import React from 'react';
import { useConfig } from 'docz';

export function Logo() {
  const {
    title,
    description,
    themeConfig: { logo }
  } = useConfig();

  return (
    <a
      href={'/'}
      style={{
        display: 'flex',
        alignItems: 'center',
        textDecoration: 'none'
      }}
    >
      <img src={logo.src} alt="MobX Logo" height={64} />
      <div style={{ display: 'flex', flexDirection: 'column', marginLeft: 10 }}>
        <span style={{ display: 'inline-block', fontSize: '2rem' }}>
          {title}
        </span>

        <span style={{ fontSize: '0.8rem', color: 'gray' }}>{description}</span>
      </div>
    </a>
  );
}
