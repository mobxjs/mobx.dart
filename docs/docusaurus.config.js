const path = require('path');

module.exports = {
  title: 'MobX.dart',
  tagline: 'Hassle free state-management for your Dart and Flutter apps',
  url: 'https://mobx.netlify.app',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  favicon: 'mobx.png',
  organizationName: 'mobxjs', // Usually your GitHub org/username.
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
          type: 'doc',
          position: 'left',
          docId: 'getting-started/index',
          label: 'Docs',
        },
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
              label: 'X',
              href: 'https://twitter.com/pavanpodila',
            },
          ],
        },
      ],
      copyright: `Copyright © 2018-${new Date().getFullYear()} MobX.dart team. All rights reserved.`,
    },
    prism: {
      theme: require('prism-react-renderer').themes.vsDark,
      additionalLanguages: ['dart'],
      defaultLanguage: 'dart',
    },
    metadata: [
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
    algolia: {
      appId: 'AMDU1T0FSC',

      // Public API key: it is safe to commit it
      apiKey: 'a35f8d278e5a09518b214b23d3b03bf7',

      indexName: 'mobx',

      // The following configuration is required to ensure we are not tampering the facets for Algolia
      // The default values of Docusaurus are not helping in retrieving the results correctly
      contextualSearch: false,
      searchParameters: {
        facetFilters: [],
      },
    },
  },
  plugins: [
    // require.resolve('docusaurus-lunr-search'),
    [
      path.resolve(__dirname, './plugins/fetch-versions'),
      {
        indexBaseUrl: true,
      },
    ],
    function postCSSPlugin(context, options) {
      return {
        name: 'docusaurus-tailwindcss',
        configurePostCss(postcssOptions) {
          postcssOptions.plugins.push(require('tailwindcss/nesting'));
          postcssOptions.plugins.push(require('tailwindcss'));
          postcssOptions.plugins.push(require('autoprefixer'));
          return postcssOptions;
        },
      };
    },
  ],
  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      {
        pages: {
          path: 'src/pages',
          routeBasePath: '/',
        },
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
        gtag: {
          trackingID: 'G-HD7VP109DL',
          anonymizeIP: true,
        },
      },
    ],
  ],
};
