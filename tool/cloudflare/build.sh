#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
# Pin the SDK used by the verified native and Wasm release tests.
FLUTTER_VERSION=3.47.2
sdk_dir="${TMPDIR:-/tmp}/mobx-flutter-${FLUTTER_VERSION}"
if [[ -n "${FLUTTER_BIN:-}" ]]; then
  sdk_dir="$(cd "$(dirname "$FLUTTER_BIN")/.." && pwd)"
fi
if [[ ! -x "$sdk_dir/bin/flutter" ]]; then
  git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git "$sdk_dir"
fi
export PATH="$sdk_dir/bin:$PATH"
export FLUTTER_BIN="$sdk_dir/bin/flutter"
flutter config --no-analytics
flutter pub get
(cd mobx_lint && dart pub get)
dart run tool/docs_inventory.dart --check
cd docs
# The exact pnpm version is declared in package.json.
npm exec --yes --package=pnpm@12.3.4 -- pnpm install --frozen-lockfile
npm exec --yes --package=pnpm@12.3.4 -- pnpm test
npm exec --yes --package=pnpm@12.3.4 -- pnpm typecheck
npm exec --yes --package=pnpm@12.3.4 -- pnpm build
