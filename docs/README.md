# MobX documentation

The active website is VitePress: `content/` owns Markdown and `.vitepress/` owns configuration and presentation. The Flutter gallery lives in `../mobx_examples/lib/gallery/`, with the multi-view entry point in `lib/site/main.dart`.

```sh
pnpm install --frozen-lockfile
pnpm build       # Flutter Wasm + JS, then VitePress
pnpm dev         # http://localhost:4178
```

Set `FLUTTER_BIN` if Flutter is not on PATH. `pnpm build:docs` rebuilds documentation against an existing Flutter build; `pnpm build:flutter` refreshes the runtime. No Flutter assets are fetched until a reader runs an example.

From the repository root, regenerate the resolved API inventory with `dart run tool/docs_inventory.dart`. CI checks it with `--check`. `pnpm build:docs` renders its local API reference. Add a guided explanation to the relevant API family whenever adding a symbol; the mechanical reference is only the coverage floor.

The earlier Docusaurus source folders are legacy migration material, not the active site. New pages belong only in `content/`.
