import React from 'react';
import CodeBlock from '@theme-original/CodeBlock';
import type { Props } from '@theme/CodeBlock';
import { usePluginData } from '@docusaurus/useGlobalData';
import { setVersions } from './utils';

export default function CodeBlockWrapper(props: Props) {
  const { versions } = usePluginData('@mobx/fetch-versions') as {
    versions: Record<string, string>;
  };
  return (
    <CodeBlock {...props}>
      {typeof props.children === 'string'
        ? setVersions(props.children, versions)
        : props.children}
    </CodeBlock>
  );
}
