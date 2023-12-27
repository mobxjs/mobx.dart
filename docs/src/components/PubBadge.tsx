import React, { FunctionComponent } from 'react';

interface Props {
  name: string;
}

export const PubBadge: FunctionComponent<Props> = (props) => {
  const { name } = props;

  return (
    <a
      href={`https://pub.dartlang.org/packages/${name}`}
      style={{
        display: 'inline-block',
        marginLeft: '0.25rem',
        marginRight: '0.25rem',
      }}
    >
      <img
        alt="pub"
        src={`https://img.shields.io/pub/v/${name}.svg?label=${name}&logo=dart&color=blue&style=for-the-badge`}
      />
    </a>
  );
};
