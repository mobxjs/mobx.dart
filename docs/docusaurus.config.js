const path = require('path');

module.exports = {
  title: 'MobX.dart',
  tagline: 'Hassle free state-management for your Dart and Flutter apps',
  url: 'https://mobx.netlify.app',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  favicon: 'mobx.png',
  organizationName: 'mobxjs', // Usually your GitHub org/user name.
  projectName: 'mobx.dart', // Usually your repo name.
  themeConfig: {
    colorMode: {
      defaultMode: 'light',
      disableSwitch: true,
    },
    navbar: {
      title: 'MobX.dart',
      logo: {
        alt: 'MobX.dart Logo',
        src: 'mobx.svg',
      },
      items: [
        {
          href: 'https://discord.gg/dNHY52k',
          position: 'right',
          className: 'icon-link discord-link',
        },
        {
          href: 'https://github.com/mobxjs/mobx.dart',
          position: 'right',
          className: 'icon-link github-link',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Learn',
          items: [
            {
              label: 'Getting Started 🚀',
              href: '/getting-started',
            },
            {
              label: 'Cheat Sheet',
              href: '/guides/cheat-sheet',
            },
            {
              label: 'Core Concepts',
              href: '/concepts',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'Stack Overflow',
              href: 'https://stackoverflow.com/questions/tagged/mobx+dart',
            },
            {
              label: 'Discord',
              href: 'https://discord.gg/dNHY52k',
            },
            {
              label: 'GitHub',
              href: 'https://github.com/mobxjs/mobx.dart',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'Twitter',
              href: 'https://twitter.com/pavanpodila',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} MobX.dart team. Built with Docusaurus.`,
    },
    prism: {
      theme: require('prism-react-renderer/themes/vsDark'),
      additionalLanguages: ['dart'],
      defaultLanguage: 'dart',
    },
    metadatas: [
      { name: 'twitter:card', content: 'summary' },
      { name: 'twitter:site', content: '@pavanpodila' },
      { name: 'twitter:title', content: 'MobX for the Dart language' },
      {
        name: 'twitter:description',
        content:
          'MobX is a library for reactively managing the state of your applications. Use the power of observables, actions, and reactions to supercharge your Dart and Flutter apps.',
      },
      {
        name: 'twitter:image',
        content:
          'https://raw.githubusercontent.com/mobxjs/mobx.dart/master/docs/src/images/mobx.png',
      },
      { name: 'twitter:image:alt', content: 'The MobX Logo' },
    ],
    gtag: {
      trackingID: 'UA-60235345-4',
    },
  },
  plugins: [
    path.resolve(__dirname, './plugins/fetch-versions'),
  ],
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        pages: false,
        blog: false,
        docs: {
          path: 'docs',
          routeBasePath: '/',
          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          editUrl: 'https://github.com/mobxjs/mobx.dart/edit/master/docs/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
};
