import React from 'react';

export const BuildStatus = () => {
  return (
    <a href="https://github.com/mobxjs/mobx.dart/actions">
      <img
        alt="Build Status"
        src="https://github.com/mobxjs/mobx.dart/workflows/Build/badge.svg"
      />
    </a>
  );
};

export const PublishStatus = () => (
  <a href="https://github.com/mobxjs/mobx.dart/actions">
    <img
      alt="Publish"
      src="https://github.com/mobxjs/mobx.dart/workflows/Publish/badge.svg"
    />
  </a>
);

export const CoverageStatus = () => (
  <a href="https://codecov.io/gh/mobxjs/mobx.dart">
    <img
      alt="Coverage Status"
      src="https://img.shields.io/codecov/c/github/mobxjs/mobx.dart/master.svg"
    />
  </a>
);

export const NetlifyStatus = () => (
  <a href="https://app.netlify.com/sites/mobx/deploys">
    <img
      alt="Netlify Status"
      src="https://api.netlify.com/api/v1/badges/05330d31-0411-4aac-a278-76615bcaff9e/deploy-status"
    />
  </a>
);

export const DiscordChat = () => (
  <a href="https://discord.gg/dNHY52k">
    <img
      alt="Join the chat at https://discord.gg/dNHY52k"
      src="https://img.shields.io/badge/Chat-on%20Discord-lightgrey?style=flat&amp;logo=discord"
    />
  </a>
);

export const FlutterFavorite = () => (
  <div style={{ margin: '2rem 0' }}>
    <a href="https://flutter.dev/docs/development/packages-and-plugins/favorites">
      <img
        src={require('../images/flutter-favorite.png')}
        height={128}
        alt="Flutter Favorite Badge"
      />
    </a>
  </div>
);
