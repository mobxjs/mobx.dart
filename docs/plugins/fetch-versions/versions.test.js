const { test } = require('node:test');
const assert = require('node:assert/strict');
const { loadVersions } = require('./versions');
const fallback = require('./published-versions.json');

test('uses current pub API and starts requests concurrently', async () => {
  const requests = [];
  const fetcher = (url, { signal }) =>
    new Promise((resolve) => {
      assert.ok(signal instanceof AbortSignal);
      assert.match(url, /^https:\/\/pub.dev\/api\/packages\//);
      requests.push(() =>
        resolve({
          ok: true,
          json: async () => ({ latest: { version: '9.1.2' } }),
        }),
      );
    });
  const pending = loadVersions({ fetcher });
  assert.equal(requests.length, Object.keys(fallback).length);
  requests.forEach((resolve) => resolve());
  const versions = await pending;
  assert.deepEqual(
    Object.values(versions),
    Object.keys(fallback).map(() => '9.1.2'),
  );
});

for (const [name, fetcher] of [
  [
    'offline',
    async () => {
      throw new Error('offline');
    },
  ],
  ['HTTP failure', async () => ({ ok: false, status: 503 })],
  [
    'malformed JSON',
    async () => ({ ok: true, json: async () => ({ versions: ['wrong API'] }) }),
  ],
  [
    'invalid version',
    async () => ({
      ok: true,
      json: async () => ({ latest: { version: 'any' } }),
    }),
  ],
])
  test(`keeps verified constraints on ${name}`, async () => {
    const warnings = [];
    assert.deepEqual(
      await loadVersions({ fetcher, warn: (text) => warnings.push(text) }),
      fallback,
    );
    assert.equal(warnings.length, Object.keys(fallback).length);
  });
