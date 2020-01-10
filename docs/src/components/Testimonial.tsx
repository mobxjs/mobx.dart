import React, { FunctionComponent, Fragment } from 'react';
import styled from 'styled-components';
import config from '../../doczrc';
import { testimonials } from './testimonials';

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

const Testimonial: FunctionComponent<Props> = ({
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

export const TestimonialList: FunctionComponent = () => {
  return (
    <TestimonialContainer>
      {testimonials.map((item) => (
        <Testimonial {...item} key={item.author} />
      ))}
    </TestimonialContainer>
  );
};
