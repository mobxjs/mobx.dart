import React, {
  Fragment,
  FunctionComponent,
  FunctionComponentElement,
} from 'react';
import styled from '@emotion/styled';
import config from '../../docusaurus.config';

const primaryColor = config.themeConfig.colors.primary;

const Bullet = styled.div`
  display: inline-block;
  border-radius: 50%;
  background: ${primaryColor};
  width: 32px;
  height: 32px;
  color: white;
  padding: 3px;
  text-align: center;
  vertical-align: middle;
  box-sizing: border-box;
  margin-right: 5px;
  font-weight: bold;
  font-family: monospace;
`;

export const CircleBullet: FunctionComponent<any> = ({ children }) => {
  return (
    <Fragment>
      <div />
      <Bullet>{children}</Bullet>
    </Fragment>
  );
};
