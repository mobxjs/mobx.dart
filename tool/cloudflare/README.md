# Website deployment

Cloudflare Pages builds the VitePress website and both Flutter roots from the
same commit. The embedded runtime is served under `/flutter/`, and the standalone
GoRouter gallery under `/gallery-app/`. Both include JavaScript and Wasm builds.

Git-connected Pages project settings:

- Project: `mobx-dart`
- Repository: `mobxjs/mobx.dart`
- Production branch: `main`
- Root directory: repository root
- Build command: `bash tool/cloudflare/build.sh`
- Output directory: `docs/build`
- Environment: `NODE_VERSION=22`, `SKIP_DEPENDENCY_INSTALL=true`
- Custom domain: `mobx.vyuh.tech`

The build script installs Flutter 3.47.2 and pnpm 12.3.4. Changes to `main`
trigger a complete build; enable previews for other branches as desired.
GitHub's website job is paused; package CI and package publishing remain active.

Verify the homepage, a documentation deep link, and a live gallery example after
deployment. Check that `.wasm` responses use `application/wasm` and that the
isolation headers in `docs/public/_headers` are served. Flutter files deliberately
revalidate because their filenames are shared across releases.
