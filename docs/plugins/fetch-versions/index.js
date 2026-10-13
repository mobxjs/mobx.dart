const { loadVersions } = require('./versions');

module.exports = function sourceVersions() {
  return {
    name: '@mobx/fetch-versions',
    loadContent: () => loadVersions(),
    async contentLoaded({ content, actions }) {
      actions.setGlobalData({ versions: content });
    },
  };
};
