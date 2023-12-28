import React from 'react';

const GithubWorkflowStatus = ({
  label,
  workflow,
}: {
  label: string;
  workflow: string;
}) => (
  <a
    href={`https://github.com/mobxjs/mobx.dart/actions/workflows/${workflow}.yml`}
  >
    <img
      alt={label}
      src={`https://img.shields.io/github/actions/workflow/status/mobxjs/mobx.dart/${workflow}.yml?label=${label}&logo=github&style=for-the-badge`}
    />
  </a>
);

export const BuildStatus = () => (
  <GithubWorkflowStatus workflow="build" label="Build" />
);

export const PublishStatus = () => (
  <GithubWorkflowStatus workflow="publish" label="Publish" />
);

export const CoverageStatus = () => (
  <a href="https://codecov.io/gh/mobxjs/mobx.dart">
    <img
      alt="Coverage Status"
      src="https://img.shields.io/codecov/c/github/mobxjs/mobx.dart?logo=codecov&style=for-the-badge"
    />
  </a>
);

export const NetlifyStatus = () => (
  <a href="https://app.netlify.com/sites/mobx/deploys">
    <img
      alt="Netlify Status"
      src="https://img.shields.io/netlify/05330d31-0411-4aac-a278-76615bcaff9e?logo=netlify&style=for-the-badge"
    />
  </a>
);

export const DiscordChat = () => (
  <a href="https://discord.gg/dNHY52k">
    <img
      alt="Join the chat at https://discord.gg/dNHY52k"
      src="https://img.shields.io/discord/637471236116447233?style=for-the-badge&logo=discord"
    />
  </a>
);

export const FlutterFavorite = () => (
  <div style={{ margin: '2rem 0' }}>
    <a href="https://flutter.dev/docs/development/packages-and-plugins/favorites">
      <img
        src={require('../images/flutter-favorite.png').default}
        height={128}
        alt="Flutter Favorite Badge"
      />
    </a>
  </div>
);
