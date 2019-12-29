import React from 'react';
import { useConfig } from 'docz';
import { media } from 'gatsby-theme-docz/src/theme/breakpoints';
import styled from 'styled-components';
import logoImage from './mobx.png';

const LogoTitleContainer = styled.div`
  display: flex;
  flex-direction: column;
  margin-left: 10px;

  ${media.mobile} {
    display: none;
  }
`;

export function Logo() {
  const { title, description } = useConfig();

  return (
    <a
      href={'/'}
      style={{
        display: 'flex',
        alignItems: 'center',
        textDecoration: 'none'
      }}
    >
      <img src={logoImage} alt="MobX Logo" height={64} />
      <LogoTitleContainer>
        <span style={{ display: 'inline-block', fontSize: '2rem' }}>
          {title}
        </span>

        <span style={{ fontSize: '0.8rem', color: 'gray' }}>{description}</span>
      </LogoTitleContainer>
    </a>
  );
}
