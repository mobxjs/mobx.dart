import React, { CSSProperties, FunctionComponent } from 'react';
import { testimonials } from './testimonials';

interface Props {
  author: string;
  title: string;
  message: string;
  twitter: string;
  photoUrl: string;
}

export const Profile: FunctionComponent<{
  photo: string;
  author: string;
  title: string;
  twitter: string;
  size?: number;
  style?: CSSProperties;
}> = ({ photo, author, title, twitter, size = 64, style }) => {
  return (
    <div className={'flex flex-row'}>
      <img
        src={photo}
        width={size}
        height={size}
        className={'rounded-full border-solid border-2 border-blue-300'}
      />
      <div className={'flex flex-col flex-1 ml-8'}>
        <a href={twitter} className={'text-xl text-blue-300 mb-2'}>
          {author}
        </a>
        <div className={'text-sm font-mono'}>{title}</div>
      </div>
    </div>
  );
};

const Testimonial: FunctionComponent<Props> = ({
  author,
  title,
  message,
  photoUrl,
  twitter,
}) => {
  return (
    <div className={'flex flex-col shadow-sm shadow-white rounded-xl p-8'}>
      <div className={'text-xl mb-8'}>{message}</div>
      <Profile
        photo={photoUrl}
        twitter={twitter}
        author={author}
        title={title}
      />
    </div>
  );
};

export const TestimonialList: FunctionComponent = () => {
  return (
    <div className={'grid grid-cols-3 gap-8'}>
      {testimonials.map((item) => (
        <Testimonial {...item} key={item.author} />
      ))}
    </div>
  );
};
