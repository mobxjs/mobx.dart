import React from 'react';
import CodeBlock from '@theme-original/CodeBlock';
import { usePluginData } from '@docusaurus/useGlobalData';
import { setVersions } from './utils';

export default function CodeBlockWrapper(props) {
  const { children } = props;
  const { versions } = usePluginData('@mobx/fetch-versions');

  if (typeof children === 'string') {
    return <CodeBlock {...props}>{setVersions(children, versions)}</CodeBlock>;
  }

  return children;
}
