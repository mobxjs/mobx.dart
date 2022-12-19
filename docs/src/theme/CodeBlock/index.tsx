import React from 'react';
import CodeBlock from '@theme-original/CodeBlock';
import { getVersion } from './utils';

export default function CodeBlockWrapper(props) {
  const { children } = props;
  if (typeof children === 'string') {
    return <CodeBlock {...props}>{getVersion(children)}</CodeBlock>;
  }
  return children;
}
