import React, { FunctionComponent } from 'react';

interface Props {
  name: string;
}
export const PubBadge: FunctionComponent<Props> = (props) => {
  const { name } = props;

  return (
    <a href={`https://pub.dartlang.org/packages/${name}`}>
      <img
        alt="pub"
        src={`https://img.shields.io/pub/v/${name}.svg?label=${name}&color=blue`}
      />
    </a>
  );
};
