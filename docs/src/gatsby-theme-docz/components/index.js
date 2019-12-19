import * as headings from 'gatsby-theme-docz/src/components/Headings';
import { Layout } from 'gatsby-theme-docz/src/components/Layout';
import { Playground } from 'gatsby-theme-docz/src/components/Playground';
import { Props } from 'gatsby-theme-docz/src/components/Props';
import styled from 'styled-components';

const InlineCode = styled.span`
  display: inline-block;
  color: rgb(250, 96, 0);
  font-size: 1em;
  background: rgb(245, 246, 247);
  padding: 0 0.5rem;
  line-height: 1.25;
`;

export default {
  ...headings,
  playground: Playground,
  layout: Layout,
  props: Props,
  inlineCode: InlineCode
};
