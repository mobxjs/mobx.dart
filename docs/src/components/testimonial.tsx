import React, { FunctionComponent, Fragment } from 'react';
import styled from 'styled-components';
import config from '../../doczrc';

const primaryColor = config.themeConfig.colors.primary;

interface Props {
  author: string;
  title: string;
  message: string;
  twitter: string;
  photoUrl: string;
}

const Message = styled.div`
  padding: 16px;
  font-size: 18px;

  &:before,
  &:after {
    font-size: 30px;
    font-family: 'Georgia', serif;
    color: ${primaryColor};
  }

  &:before {
    content: '“';
  }

  &:after {
    content: '”';
  }
`;

const Container = styled.div`
  display: flex;
  flex-direction: column;
  padding: 20px;
  background: #f5f6f7;
  border-radius: 8px;
  margin-bottom: 30px;
  box-shadow: 1px 1px 5px #ddd;
`;

const Profile = styled.div`
  display: flex;

  .name {
    font-size: 18px;
    color: ${primaryColor};

    & > a,
    & > a:visited,
    & > a:hover {
      color: ${primaryColor};
      text-decoration: none;
    }
  }

  .title {
    font-size: 14px;
    color: gray;
  }

  img {
    border-radius: 50%;
    border: 5px solid ${primaryColor};
  }
`;

export const Testimonial: FunctionComponent<Props> = ({
  author,
  title,
  message,
  photoUrl,
  twitter
}) => {
  return (
    <Container>
      <Message>{message}</Message>
      <Profile>
        <img src={photoUrl} width={64} height={64} />
        <div
          style={{
            marginLeft: 10,
            flex: 1,
            display: 'flex',
            flexDirection: 'column'
          }}
        >
          <div className={'name'}>
            <a href={twitter}>{author}</a>
          </div>
          <div className={'title'}>{title}</div>
        </div>
      </Profile>
    </Container>
  );
};

const list = [
  {
    author: 'Remi Rousselet',
    twitter: 'https://twitter.com/remi_rousselet',
    title:
      'Flutter enthusiast, creator of the flutter_hooks, provider packages.',
    photoUrl:
      'https://pbs.twimg.com/profile_images/1072447244719284225/AVEGksps_400x400.jpg',
    message: "It's like BLoC, but actually works."
  },

  {
    author: 'Sanket Sahu',
    twitter: 'https://twitter.com/sanketsahu',
    title:
      'Founder of GeekyAnts • Creator of BuilderXio, NativeBaseIO & VueNativeIO • Speaker • Loves tea • Strums guitar',
    photoUrl:
      'https://pbs.twimg.com/profile_images/1087336663666151424/NpYnCmzC_400x400.jpg',
    message:
      'We at GeekyAnts have used MobX.dart in many Flutter projects. We have chosen it as the default state-management library for the internal frameworks built for Flutter.'
  }
];

export const TestimonialList: FunctionComponent = () => {
  return (
    <Fragment>
      {list.map((item) => (
        <Testimonial {...item} key={item.author} />
      ))}
    </Fragment>
  );
};
