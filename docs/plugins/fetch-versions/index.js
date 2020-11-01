const webpack = require('webpack');
const axios = require('axios');
const plugins = [
  {
    pub: 'mobx',
  },
  {
    pub: 'flutter_mobx',
  },
  {
    pub: 'mobx_codegen',
  },
  {
    pub: 'build_runner',
  },
  {
    pub: 'dart_json_mapper',
  },
  {
    pub: 'dart_json_mapper_mobx',
  },
];

// Fetch the plugins latest version from the pub API
async function fetchPluginVersion(plugin) {
  try {
    const response = await axios.get(`https://pub.dev/api/packages/${plugin}`);
    const versions = response.data.versions;

    if (!Array.isArray(versions)) {
      return '';
    }

    return versions[versions.length - 1].version;
  } catch (e) {
    console.log(`Failed to load version for plugin "${plugin}".`);
    return '';
  }
}

module.exports = function sourceVersions() {
  return {
    name: '@mobx/fetch-versions',
    // Create a content string which will contain pub.dev versions for each plugin in the format of a .env file
    // See https://www.npmjs.com/package/dotenv#usage for more information.
    async loadContent() {
      let versions = '';

      for (let i = 0; i < plugins.length; i++) {
        const { pub } = plugins[i];

        const version = await fetchPluginVersion(pub);
        versions += `PUB_${pub.toUpperCase()}=${version}`;
        if (i < plugins.length - 1) versions += '\n';
      }

      return versions;
    },
    // Using the content string, create a cached file on the local filesystem
    // Read the contents of the file with dotenv.
    // See https://www.npmjs.com/package/dotenv#path for more information.
    async contentLoaded({ content, actions }) {
      require('dotenv').config({
        path: await actions.createData('versions.env', content),
        debug: process.env.NODE_ENV !== 'production',
      });
    },
    // Using webpack, create a global variable for each plugin, using the created environment variable.
    // This ensures we can access the data on both the server and client.
    // See https://webpack.js.org/plugins/define-plugin/ for more information.
    configureWebpack() {
      return {
        plugins: [
          new webpack.DefinePlugin(
            plugins.reduce((current, plugin) => {
              const envVar = `PUB_${plugin.pub.toUpperCase()}`;
              return {
                ...current,
                [envVar]: JSON.stringify(process.env[envVar] || ''),
              };
            }, {})
          ),
        ],
      };
    },
  };
};
