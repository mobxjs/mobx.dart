module.exports = {
  title: 'MobX.dart',
  tagline: 'Hassle free state-management for your Dart and Flutter apps',
  url: 'https://your-docusaurus-test-site.com',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  favicon: 'img/mobx.png',
  organizationName: 'mobxjs', // Usually your GitHub org/user name.
  projectName: 'mobx.dart', // Usually your repo name.
  themeConfig: {
    navbar: {
      title: 'MobX.dart',
      logo: {
        alt: 'MobX.dart Logo',
        src: 'img/mobx.svg',
      },
      items: [
        {
          href: 'https://github.com/mobxjs/mobx.dart',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
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
              label: 'Twitter',
              href: 'https://twitter.com/pavanpodila',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/mobxjs/mobx.dart',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} MobX.dart team. Built with Docusaurus.`,
    },
    prism: {
      additionalLanguages: ['dart'],
    },
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        pages: false,
        blog: false,
        docs: {
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
