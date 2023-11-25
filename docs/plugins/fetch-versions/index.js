const axios = require('axios');
const plugins = [
  'mobx',
  'flutter_mobx',
  'mobx_codegen',
  'build_runner',
  'json_serializable',
  'json_annotation',
];

// Fetch the plugins latest version from the pub API
async function fetchPluginVersion(plugin) {
  const defaultVersion = 'any';

  try {
    const response = await axios.get(`https://pub.dev/packages/${plugin}.json`);
    const versions = response.data.versions;

    if (!Array.isArray(versions)) {
      return defaultVersion;
    }

    return versions[0];
  } catch (e) {
    console.log(`Failed to load version for plugin "${plugin}".`);
    return defaultVersion;
  }
}

module.exports = function sourceVersions() {
  return {
    name: '@mobx/fetch-versions',
    // Create a content map which will contain pub.dev versions for each plugin
    async loadContent() {
      let versions = {};

      for (let plugin of plugins) {
        versions[plugin] = await fetchPluginVersion(plugin);
      }

      return versions;
    },
    // Using the content map and set as global data
    async contentLoaded({ content, actions }) {
      const { setGlobalData } = actions;

      setGlobalData({
        versions: content,
      });
    },
  };
};
