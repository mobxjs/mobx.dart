# Documentation and gallery audit — 2026-09-11

## Coverage and ownership

The resolved-export inventory covers 104 declarations and 507 declared public members across `mobx`, `flutter_mobx`, `mobx_codegen` (including `builder.dart`), and `mobx_lint` (plugin and version entry points). Export `show`/`hide` rules are resolved by analyzer. The generated reference is a coverage floor; handwritten family guides explain purpose, boundaries, ownership, and examples. Inherited platform members retain Dart/Flutter contracts.

The learning path moves from observable/action/Observer through computed state, collections, async state, disposal, and conditional tracking to application architecture and runtime internals. Contributor guides document package ownership, tracking, propagation, batching, zones, and cleanup. Refactoring opportunities are recorded as proposals with guardrails; this pass does not claim unmeasured core performance improvements.

Corrected the annotation source comment that inverted equality-comparer semantics. Converted homepage snippets into analyzable Dart while displaying only their teaching regions. Removed the earlier Vue/compiled-Dart demonstration bridge and its duplicate runtime tests; live examples now use Flutter and the package's widget test suite.

## Gallery

Eight GoRouter routes: counter, cart, tasks, collections, async, stream, reactions, dependencies. Each uses a deferred import. A shared Flutter engine hosts independently removable views. Initial docs load does not download Flutter; Run starts the engine. Loading, failed downloads, deferred retry, and teardown during loading have explicit behavior. Async routes own their request store, streams own subscriptions/controllers, and reaction routes dispose effects. Cart/task stores demonstrate shared state.

The default browser build is split JavaScript. The installed SDK has no Wasm deferred-loading switch, so Wasm remains opt-in through `?renderer=wasm`. Both builds use the same source. See `gallery-build-report.json` for measured artifact bytes and gzip estimates; these exclude engine/font overhead and do not measure server transfer sizes.

## Verification

- 53 rendered HTML pages (including the app entry points); local href/src sweep found no missing page or asset destinations.
- Runtime inventory drift check and generated-reference/gallery coverage checks.
- VitePress production build and Vue/TypeScript typecheck.
- Repository-wide Dart analysis: no issues.
- Core: 508 passed, one existing skip.
- Generator: 99 passed.
- Flutter bindings: 30 passed.
- Flutter examples: 29 passed native and 29 passed Chrome/Wasm.
- Standalone: direct counter link loaded, counter interaction worked, returning to the gallery updated the URL, and selecting dependencies produced `#/dependencies`. A normal Flutter root owns history; the documentation retains its separate multi-view entry point.
- Browser: counter 0→1; cart quantity 3, subtotal 72, free shipping; stream value→error→recovery→done; both Wasm and split-JS engines exercised.
- Desktop/mobile screenshots in `.impeccable/review/`; independent review covered the gallery and cart at both widths. Its cart-label and persistence fixes were applied.

## Maintenance

Run `dart run tool/docs_inventory.dart --check` at the repository root. Update the inventory with the same command without `--check`, then `node docs/scripts/api-reference.mjs`. Add a family explanation and example when appropriate; generated symbol presence does not prove teaching quality. `pnpm build` in `docs` rebuilds the Flutter runtime and website. `node scripts/report-gallery-size.mjs` records artifact sizes after a build.

No deployment, package release, or commit is claimed by this audit.
