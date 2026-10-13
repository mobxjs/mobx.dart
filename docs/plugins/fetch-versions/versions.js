const fallbackVersions = require('./published-versions.json');

/** Fetch independent package releases concurrently, with a bounded offline fallback. */
async function loadVersions({ fetcher = fetch, warn = console.warn } = {}) {
  const entries = await Promise.all(
    Object.entries(fallbackVersions).map(async ([name, fallback]) => {
      try {
        const response = await fetcher(`https://pub.dev/api/packages/${name}`, {
          signal: AbortSignal.timeout(5000),
        });
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const { latest } = await response.json();
        if (!/^\d+\.\d+\.\d+(?:[-+][\w.-]+)?$/.test(latest?.version ?? ''))
          throw new Error('Invalid version');
        return [name, latest.version];
      } catch (error) {
        warn(
          `Using last verified published version of ${name} (${fallback}): ${error.message}`,
        );
        return [name, fallback];
      }
    }),
  );
  return Object.fromEntries(entries);
}
module.exports = { loadVersions };
