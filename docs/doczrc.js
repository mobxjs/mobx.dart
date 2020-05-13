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
      options: {
        language: 'dart',
        extensions: ['dart-syntax-highlighting-only'],
      },
    },
  ],
  themeConfig: {
    showDarkModeSwitch: false,
    fonts: {
      monospace: 'PT Mono',
      body: 'Montserrat',
      main: 'Montserrat',
    },
    mode: 'light',
    colors: {
      primary: '#1389FD',
      codeColor: '#fa6000',
      blockquoteColor: '#00579b',
    },
    styles: {
      h1: {
        fontFamily: 'Montserrat, sans-serif',
      },
      code: {
        fontSize: '1.1rem',
      },
      img: {
        marginBottom: 0,
      },
    },
  },
  menu: [
    'Home',
    'Getting Started',
    'Core Concepts',
    'Examples',
    'Guides',
    'Community',
    'API Overview',
    'Developer',
  ],
};
