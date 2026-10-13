import React, { type CSSProperties } from 'react';

export function Profile({
  photo,
  author,
  title,
  twitter,
  size = 64,
  style,
}: {
  photo: string;
  author: string;
  title?: string;
  twitter: string;
  size?: number;
  style?: CSSProperties;
}) {
  return (
    <div className="author-profile" style={style}>
      <img src={photo} alt="" width={size} height={size} loading="lazy" />
      <div>
        <a href={twitter}>{author}</a>
        {title && <p>{title}</p>}
      </div>
    </div>
  );
}
