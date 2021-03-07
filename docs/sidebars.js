module.exports = {
  docs: [
    'home',
    'getting-started/index',
    'concepts',
    {
      type: 'category',
      label: 'Examples',
      collapsed: false,
      items: [
        'examples/counter',
        'examples/dice/index',
        'examples/todos/index',
        'examples/form/index',
        'examples/connectivity/index',
        'examples/github/index',
        'examples/hacker-news/index',
        'examples/random-stream/index',
      ],
    },
    {
      type: 'category',
      label: 'Guides',
      collapsed: false,
      items: [
        'guides/cheat-sheet',
        'guides/build-output',
        'guides/json-serialization',
        'guides/organizing-stores',
        'guides/when-does-mobx-react',
      ],
    },
    'community',
    {
      type: 'category',
      label: 'API Overview',
      collapsed: false,
      items: [
        'api/observable',
        'api/action',
        'api/reaction',
        'api/context',
        'api/spy',
      ],
    },
    {
      Development: ['development/blueprint', 'development/release'],
    },
  ],
};
