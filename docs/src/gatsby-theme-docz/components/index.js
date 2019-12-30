import * as headings from 'gatsby-theme-docz/src/components/Headings';
import { Layout } from 'gatsby-theme-docz/src/components/Layout';
import { Playground } from 'gatsby-theme-docz/src/components/Playground';
import { Props } from 'gatsby-theme-docz/src/components/Props';
import styled from 'styled-components';
import theme from 'gatsby-theme-docz/src/theme';

const InlineCode = styled.code`
  font-family: 'PT Mono', monospace;
  display: inline-block;
  color: rgb(250, 96, 0);
  padding: 0 0.25rem;
`;

const BlockQuote = styled.blockquote`
  margin: 1rem 0;
  background: ${theme.colors.blockquote.bg};
  border-left: 10px solid #99e7ff;
  padding: 1rem 1.5rem;
`;

export default {
  ...headings,
  playground: Playground,
  layout: Layout,
  props: Props,
  inlineCode: InlineCode,
  blockquote: BlockQuote
};
