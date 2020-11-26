import React, { HTMLProps } from 'react';
import CodeBlock from '@theme/CodeBlock';

import { getVersion } from './utils';

export default {
  inlineCode: (props: HTMLProps<HTMLElement>) => {
    const { children } = props;
    if (typeof children === 'string') {
      return <code {...props}>{getVersion(children)}</code>;
    }
    return children;
  },

  code: (props: HTMLProps<HTMLElement>) => {
    const { children } = props;
    if (typeof children === 'string') {
      return <CodeBlock {...props}>{getVersion(children)}</CodeBlock>;
    }
    return children;
  },
};
