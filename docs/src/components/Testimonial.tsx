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
    font-size: 24px;
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

const TestimonialContainer = styled.div``;

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
      'https://pbs.twimg.com/profile_images/1188747996843761665/8CiUdKZW_400x400.jpg',
    message:
      'We at GeekyAnts have used MobX.dart in many Flutter projects. We have chosen it as the default state-management library for the internal frameworks built for Flutter.'
  },

  {
    author: 'Chris Sells',
    twitter: 'https://twitter.com/csells',
    title:
      'Google Product Manager on the Flutter Development Experience. Enjoys long walks on the beach and various technologies.',
    photoUrl:
      'https://pbs.twimg.com/profile_images/1660905119/vikingme128x128_400x400.jpg',
    message: `If you haven\'t seen MobX.dart @ https://mobx.pub, check it out. In combination with Provider, it\'s PFM (Pure Flutter Magic). I use it when I build anything real. #recommended #Flutter`
  },
  {
    author: 'Michael Bui',
    twitter: 'https://twitter.com/MaikuB84',
    title:
      'Flutter Enthusiast and maintainer of flutter_local_notifications and flutter_appauth packages.',
    photoUrl:
      'https://pbs.twimg.com/profile_images/989477066566320129/zCN6USCc_400x400.jpg',
    message: `MobX's concepts of Observables, Actions and Reactions make it intuitive to figure out how to model the state of an application. I would highly recommend it as a solution for managing the application's state.`
  },
  {
    author: 'Robert Felker',
    twitter: 'https://twitter.com/BlueAquilae',
    title: '#Minimalism | #flutter artist | github Awesome #flutter',
    photoUrl:
      'https://pbs.twimg.com/profile_images/948652731115429889/sQnk1F3m_400x400.jpg',
    message: `On Professional projects, MobX helps me manage hundreds of forms and thousands of fields with transparency.
When working on Generative Art, it helps me create highly configurable widgets without complexity. 
MobX supports me on all of my projects.`
  },
  {
    author: 'Jacob Moura',
    twitter: 'https://twitter.com/jacob_moura',
    title:
      'Founded the Brazilian community Flutterando. Creator of bloc_pattern, Slidy and flutter_modular packages.',
    photoUrl:
      'https://pbs.twimg.com/profile_images/1207420946056990720/77G9XtUp_400x400.jpg',
    message: `MobX feels so robust and leverages the Dart language very well.

Brazil's community was previously attached to BLoC. With MobX, they have found a great replacement.

Several people here in Brazil are building Flutter apps quickly, thanks to MobX.`
  }
];

export const TestimonialList: FunctionComponent = () => {
  return (
    <TestimonialContainer>
      {list.map((item) => (
        <Testimonial {...item} key={item.author} />
      ))}
    </TestimonialContainer>
  );
};
