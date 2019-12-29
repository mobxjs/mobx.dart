import * as headings from 'gatsby-theme-docz/src/components/Headings';
import { Layout } from 'gatsby-theme-docz/src/components/Layout';
import { Playground } from 'gatsby-theme-docz/src/components/Playground';
import { Props } from 'gatsby-theme-docz/src/components/Props';
import styled from 'styled-components';

const InlineCode = styled.code`
  font-family: 'PT Mono', monospace;
  display: inline-block;
  color: rgb(250, 96, 0);
  padding: 0 0.5rem;
`;

export default {
  ...headings,
  playground: Playground,
  layout: Layout,
  props: Props,
  inlineCode: InlineCode
};
