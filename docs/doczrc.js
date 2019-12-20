const path = require('path');

export default {
  title: 'MobX.dart',
  description: 'Hassle free state-management for your Dart and Flutter Apps',
  src: './src',
  files: '**/*.{md,markdown,mdx}',
  repository: 'https://github.com/mobxjs/mobx.dart',
  indexHtml: 'src/index.html',
  favicon:
    'https://raw.githubusercontent.com/mobxjs/mobx.dart/master/docs/src/images/mobx.png',
  gatsbyRemarkPlugins: [
    {
      resolve: 'gatsby-remark-vscode',
      // OPTIONAL
      options: {
        extensionDataDirectory: path.resolve(
          __dirname,
          'gatsby-remark-vscode-extensions'
        ),
        extensions: [
          {
            identifier: 'oscarcs.dart-syntax-highlighting-only',
            version: '1.0.0'
          }
        ]
      }
    }
  ],
  themeConfig: {
    showDarkModeSwitch: false,
    logo: {
      src:
        'https://raw.githubusercontent.com/mobxjs/mobx.dart/master/docs/src/images/mobx.png'
    },
    mode: 'light',
    colors: {
      primary: '#1389FD',
      codeColor: '#fa6000',
      blockquoteColor: '#00579b'
    },
    styles: {
      code: {
        fontSize: '1.1rem'
      }
    }
  },
  menu: [
    'Home',
    'Getting Started',
    'Core Concepts',
    'Examples',
    'Guides',
    'Community',
    'API Overview',
    'Developer'
  ]
};
