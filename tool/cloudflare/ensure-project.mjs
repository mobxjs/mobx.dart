// Project provisioning for the GitHub Actions Direct Upload workflow.
const {CLOUDFLARE_API_TOKEN: token, CLOUDFLARE_ACCOUNT_ID: account} = process.env;
if (!token || !account) throw new Error('Set the CLOUDFLARE_API_TOKEN GitHub Actions secret (Account: Cloudflare Pages: Edit).');
const base = `https://api.cloudflare.com/client/v4/accounts/${account}/pages/projects`;
const headers = {Authorization: `Bearer ${token}`, 'Content-Type': 'application/json'};
const existing = await fetch(`${base}/mobx-dart`, {headers});
if (existing.ok) {
  const result = await existing.json();
  if (!result.success) throw new Error('Unable to inspect the Cloudflare Pages project.');
  if (result.result.source) throw new Error('mobx-dart is Git-connected; review its deployment configuration before using Direct Upload.');
  console.log('Using existing mobx-dart Direct Upload project.');
} else if (existing.status === 404) {
  const created = await fetch(base, {method: 'POST', headers, body: JSON.stringify({name: 'mobx-dart', production_branch: 'main'})});
  const result = await created.json();
  if (!created.ok || !result.success) throw new Error(`Unable to create Pages project (HTTP ${created.status}).`);
  console.log('Created mobx-dart Direct Upload project.');
} else {
  throw new Error(`Unable to inspect Pages project (HTTP ${existing.status}); check the token's account and Pages permissions.`);
}
