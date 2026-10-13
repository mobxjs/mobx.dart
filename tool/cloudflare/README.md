# Website deployment

`.github/workflows/website.yml` builds and deploys on relevant pushes to `main`
and supports manual dispatch. GitHub builds VitePress and both Flutter roots
from the same commit, then Wrangler uploads `docs/build` to Cloudflare Pages.
No Cloudflare GitHub App installation or Cloudflare-hosted build is needed.

The embedded runtime is served under `/flutter/`, and the standalone GoRouter
gallery under `/gallery-app/`. Both include JavaScript and Wasm builds. The
workflow retains the combined output as a downloadable GitHub artifact.

## One-time authentication

Create a Cloudflare API token scoped to account
`8e7561a2f1d77b61ee68fd14f8d65e22`, with **Account: Cloudflare Pages: Edit**.
Store it in this repository's Actions secrets as `CLOUDFLARE_API_TOKEN`.
Do not commit the token. The account ID is public configuration in the workflow.

The workflow creates the `mobx-dart` Direct Upload project if it is absent.
It refuses to overwrite a Git-connected project's configuration.
After the first deployment, associate `mobx.vyuh.tech` in the Pages custom-domain
settings and create the offered DNS record. This is a one-time domain setup;
subsequent pushes update the same project and domain automatically.

## Build

The build script uses Flutter 3.47.2 and pnpm 12.3.4. Run locally with:

```sh
FLUTTER_BIN=/path/to/flutter/bin/flutter bash tool/cloudflare/build.sh
```

Verify the homepage, a documentation deep link, and a live gallery example after
deployment. Check that `.wasm` responses use `application/wasm` and that the
isolation headers in `docs/public/_headers` are served. Flutter files deliberately
revalidate because their filenames are shared across releases.

The former website job in `build.yml` remains paused; the dedicated deployment
workflow now owns website checks and deployment. Package CI and publishing remain
separate. Retire the old Netlify site only after the Cloudflare domain is verified.
