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
    <div className={'flex flex-col lg:flex-row gap-4'}>
      <img
        src={photo}
        width={size}
        height={size}
        className={'rounded-full border-solid border-2 border-blue-300'}
      />
      <div className={'flex flex-col flex-1'}>
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
    <div
      className={
        'flex flex-col border-gray-500 border-solid border rounded-xl p-4 sm:p-8'
      }
    >
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
    <div
      className={'grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-8 mt-16'}
    >
      {testimonials.map((item) => (
        <Testimonial {...item} key={item.author} />
      ))}
    </div>
  );
};
