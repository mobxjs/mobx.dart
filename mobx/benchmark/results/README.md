# Performance implementation audit and measurements

> Correctness follow-up: the ten remaining audit specifications are now fixed. See [the resolved audit](../../tool/audit/RESOLVED.md). Counts and unresolved findings below describe the earlier performance-pass snapshot; follow-up verification and measurements are recorded at the end.


Measured 2026-09-11. Baseline: unmodified MobX 2.6.1 at `dc532481ab5d1044889e63335defd40501bee8c6`. Candidate: the performance-pass source recorded in `candidate-source.json`, before the later correctness follow-up. Both use the same vendored harness and local adapter. Dart 3.13.2 stable, macOS arm64, 12 logical processors. Native measurements use compiled executables with assertions disabled. Browser measurements use release Dart Wasm in Chrome 153.

## Changes implemented

| Owner | Before | Now | Evidence / limit |
|---|---|---|---|
| Dependency tracking (`context.dart`, `derivation.dart`) | A new dependency Set and difference Sets on every tracked evaluation | Retained ordered dependency arrays, read cursor and tracking IDs; stable reads reuse storage; membership changes fall back to Set reconciliation | Eight propagation cases show repeatable improvement; dynamic graphs still allocate. No per-change attribution or heap profile yet. |
| Atom storage (`atom.dart`) | Eager observer Set and lifecycle map | Empty shared storage and lazy allocation; release empty observer/hook containers | Reduces eagerly created containers. Allocation bytes and retained heap have not been measured. |
| Scalar observables (`observable.dart`) | Eager listener/interceptor holders; equality reads public getter | Lazy holders; equality reads internal value | Avoids unused holders and false subscriptions from writes. |
| Reaction queue (`context.dart`) | Copy pending reactions for each wave | Swap two wave buffers within each drain | Retains scheduling order and wave-based cycle limit; still creates one buffer per drain. |
| Actions | Reflective `Function.apply` in `runInAction`; create spy event objects while disabled | Direct typed invocation; guarded event/timestamp work | Contributes to aggregate timings; not isolated in an ablation benchmark. |
| List filtering | Repeated `removeAt`, shifting tails: quadratic worst case | Reverse predicate pass, then one forward compaction: linear; notification payload only when needed | 100k alternating removal improves 1,587x native. Uses O(k) removal-index storage. Predicate exceptions do not cause partial filtering by the operation. |
| Bulk map/set mutation | Each element can flush reactions | One action around each bulk operation | Insertion of 10k entries: 10,000 to 1 reaction per collection. Direct mutation case 9.58x native. Already-batched callers gain little. |
| List notifications | Allocate detailed events without listeners | Skip event construction when there are no direct listeners | Reactive invalidation remains. Some range argument construction still occurs before the notification method. |

The propagation algorithm still uses MobX's existing dirty/possibly-stale states and computed equality suppression. There is no new public reactive API. These changes do not implement per-key map tracking, per-membership set tracking, per-index list tracking, or an intrusive dependency-edge graph.

## All upstream workloads: published results and local before/after

All **35 of 35** workloads are vendored unmodified from [medz/dart-reactivity-benchmark](https://github.com/medz/dart-reactivity-benchmark/tree/03663d64413a84c3449b932dac10f576b6314dd0): 8 Kairo graphs, 1 mol workload, 17 creation/computation/update microbenchmarks, 3 cellx graphs, and 6 dynamic graph configurations. We use the full suite, plus a repeated median runner for the eight Kairo cases.

The published column is the upstream README's historical MobX result (its dependency was MobX 2.5.0). It is **not** a same-machine baseline. Local speedup compares only the two local builds, using the same SDK and harness. Times below are milliseconds; local upstream runs have one outer sample and preserve the upstream family-specific inner timing methods.

| Workload | Published MobX | Local original ms | Local candidate ms | Local speedup |
|---|---:|---:|---:|---:|
| avoidablePropagation | 2.39s | 1422.466 | 754.771 | 1.88x |
| broadPropagation | 4.38s | 2491.174 | 790.938 | 3.15x |
| deepPropagation | 1.47s | 897.306 | 357.156 | 2.51x |
| diamond | 2.35s | 1402.940 | 493.702 | 2.84x |
| mux | 1.85s | 1114.948 | 511.633 | 2.18x |
| repeatedObservers | 233.22ms | 131.415 | 63.650 | 2.06x |
| triangle | 751.15ms | 468.739 | 150.959 | 3.11x |
| unstable | 344.35ms | 197.574 | 133.548 | 1.48x |
| molBench | 590.86ms | 380.574 | 339.336 | 1.12x |
| create_signals | 82.88ms | 32.464 | 25.174 | 1.29x |
| comp_0to1 | 39.85ms | 10.379 | 10.268 | 1.01x |
| comp_1to1 | 17.18ms | 24.136 | 11.815 | 2.04x |
| comp_2to1 | 20.11ms | 18.333 | 12.620 | 1.45x |
| comp_4to1 | 14.13ms | 6.547 | 24.169 | 0.27x |
| comp_1000to1 | 16μs | 0.010 | 0.008 | 1.25x |
| comp_1to2 | 45.30ms | 17.339 | 14.599 | 1.19x |
| comp_1to4 | 24.50ms | 18.655 | 10.487 | 1.78x |
| comp_1to8 | 21.32ms | 15.437 | 10.813 | 1.43x |
| comp_1to1000 | 15.27ms | 9.497 | 7.800 | 1.22x |
| update_1to1 | 26.63ms | 11.306 | 11.257 | 1.00x |
| update_2to1 | 12.91ms | 5.675 | 5.419 | 1.05x |
| update_4to1 | 7.41ms | 2.759 | 2.702 | 1.02x |
| update_1000to1 | 69μs | 0.028 | 0.034 | 0.82x |
| update_1to2 | 13.18ms | 5.834 | 5.631 | 1.04x |
| update_1to4 | 6.88ms | 2.846 | 2.852 | 1.00x |
| update_1to1000 | 161μs | 0.095 | 0.084 | 1.13x |
| cellx1000 | 71.52ms | 62.637 | 21.019 | 2.98x |
| cellx2500 | 255.99ms | 195.835 | 75.243 | 2.60x |
| cellx5000 | 552.49ms | 437.475 | 188.472 | 2.32x |
| 10x5 - 2 sources - read 20.0% (simple) | 1.94s | 1256.476 | 431.772 | 2.91x |
| 10x10 - 6 sources - dynamic - read 20.0% (dynamic) | 1.49s | 955.771 | 298.135 | 3.21x |
| 1000x12 - 4 sources - dynamic (large) | 1.90s | 1095.486 | 445.202 | 2.46x |
| 1000x5 - 25 sources (wide dense) | 3.34s | 2272.935 | 562.008 | 4.04x |
| 5x500 - 3 sources (deep) | 1.09s | 654.007 | 260.916 | 2.51x |
| 100x15 - 6 sources - dynamic (very dynamic) | 1.66s | 1025.449 | 394.452 | 2.60x |

The upstream README reports 27.00s total for MobX and 3.32s for alien_signals. Those totals combine unlike timing aggregations and cannot establish an application-wide speedup, or a new ranking for this patch. We have not rerun every competitor with the new suite. All 35 local workloads reported success in both builds, but some upstream microbenchmarks do not validate output. Their success flag means no upstream failure was reported. In particular, several `update_*` cases construct computeds without reading/observing them, so they do not measure active dependent recomputation.

## Repeated native propagation (1,000 iterations per sample)

3 samples per case; medians, milliseconds. Speedup below 1 means slower.

| Workload | Original ms | Candidate ms | Speedup |
|---|---:|---:|---:|
| avoidablePropagation | 1431.175 | 757.438 | 1.89x |
| broadPropagation | 2497.374 | 793.046 | 3.15x |
| deepPropagation | 893.712 | 360.103 | 2.48x |
| diamond | 1381.943 | 488.973 | 2.83x |
| mux | 1108.290 | 510.577 | 2.17x |
| repeatedObservers | 132.946 | 62.672 | 2.12x |
| triangle | 463.748 | 155.019 | 2.99x |
| unstable | 207.113 | 135.572 | 1.53x |

## Collection scaling and batching

3 samples per case; medians, milliseconds. Speedup below 1 means slower.

| Workload | Original ms | Candidate ms | Speedup |
|---|---:|---:|---:|
| native_remove_alternating_10000 | 0.059 | 0.062 | 0.95x |
| observable_remove_alternating_10000 | 12.432 | 0.063 | 197.33x |
| native_remove_alternating_50000 | 0.317 | 0.311 | 1.02x |
| observable_remove_alternating_50000 | 311.409 | 0.363 | 857.88x |
| native_remove_alternating_100000 | 0.693 | 0.683 | 1.01x |
| observable_remove_alternating_100000 | 1245.653 | 0.785 | 1586.82x |
| bulk_map_set_direct | 9.509 | 0.993 | 9.58x |
| bulk_map_set_outer_action | 0.927 | 0.981 | 0.94x |

## Repeated native microbenchmarks

7 samples per case; medians, milliseconds. Speedup below 1 means slower.

| Workload | Original ms | Candidate ms | Speedup |
|---|---:|---:|---:|
| create_signals | 33.695 | 25.790 | 1.31x |
| comp_0to1 | 21.911 | 14.578 | 1.50x |
| comp_1to1 | 23.492 | 21.161 | 1.11x |
| comp_2to1 | 8.383 | 13.391 | 0.63x |
| comp_4to1 | 15.910 | 11.343 | 1.40x |
| comp_1000to1 | 0.011 | 0.010 | 1.10x |
| comp_1to2 | 19.833 | 16.600 | 1.19x |
| comp_1to4 | 18.415 | 12.515 | 1.47x |
| comp_1to8 | 14.643 | 11.356 | 1.29x |
| comp_1to1000 | 9.736 | 7.883 | 1.24x |
| update_1to1 | 11.084 | 11.300 | 0.98x |
| update_2to1 | 5.464 | 5.593 | 0.98x |
| update_4to1 | 2.763 | 2.849 | 0.97x |
| update_1000to1 | 0.028 | 0.028 | 1.00x |
| update_1to2 | 5.606 | 5.670 | 0.99x |
| update_1to4 | 2.705 | 2.807 | 0.96x |
| update_1to1000 | 0.095 | 0.083 | 1.14x |

## Isolated comp_2to1 follow-up

15 samples per case; medians, milliseconds. Speedup below 1 means slower.

| Workload | Original ms | Candidate ms | Speedup |
|---|---:|---:|---:|
| comp_2to1 | 12.327 | 10.978 | 1.12x |

Microbenchmark results are noisy and not uniformly faster. The mixed-family primitive run showed a comp_2to1 regression; rerunning that case alone for 15 samples showed 1.12x improvement. Both raw datasets are retained rather than suppressing the adverse result. This requires further controlled measurement before asserting there is no small-node creation regression. Collection outer-action overhead likewise slightly regressed in the recorded native run.

## Correctness audit accompanying the optimization

The dependency regression suite fixes and covers all seven reproduced follow-up defects:

1. Cleanup no longer suspends a computed that is resubscribed inside its unobserved hook.
2. Lifecycle-hook reads do not become dependencies of the triggering reaction.
3. Cycle-limit recovery reconciles queued scheduling flags instead of replacing context state and stranding unrelated reactions.
4. Error handlers belong to their reactive context, even when contexts share configuration.
5. Computed comparer exceptions propagate as errors rather than silently returning a stale value.
6. Internal equality checks during writes do not subscribe a write-only reaction.
7. Lifecycle listeners may unregister during notification without concurrent modification errors.

Tracking, computation depth, action state, and reaction flags also restore through `finally` when error boundaries are disabled. Collection fixes include `remove(Object?)`/map lookup type compatibility, list predicate exception handling, and insertion invalidation before throwing map/set listeners. The graph regression tests include nested repeated reads, disposal, 4,000 generated graph updates, and a 1,000-step conditional diamond.

The **original 20-probe audit still has 10 failing specifications**, recorded in `../../tool/audit/current-results.txt`: supplied future context, reused AsyncAction caller zone, stream cancelOnError completion, interceptor notification value, cast-view listeners, empty range bounds, nullable empty-stream completion, delayed-reaction timer disposal, supplied context for `when`, and supplied context for scheduled effects. These are outstanding work; they are not disabled tests that used to pass. The historical audit files document the original source and intentionally remain separate from normal passing tests.

## Interpretation and remaining performance work

- Timing improvements are measured for the combined patch, not individually attributed to each optimization. An ablation study and allocation/retained-heap profiles remain undone.
- Collection reactions now observe each bulk operation coherently. Callers depending on intermediate per-item reaction executions will see changed behavior, even though direct mutation notifications remain per operation/item as implemented.
- List predicates still run in reverse order. They now see the original list until filtering is committed; predicates that inspect or mutate the list during iteration require particular care. Length changes are detected, but arbitrary same-length callback mutations are not comprehensively specified by this patch.
- Map/set dependencies remain collection-wide. Per-key/per-membership tracking with reclaimable metadata is a major remaining opportunity for sparse readers.
- Browser results measure core reactivity in release Wasm. Widget tests validate Flutter integration but do not establish frame time, scrolling smoothness, startup time, or application-level speedup.
- Full competitor rankings, release-JS performance, memory profiles, and production application traces remain unmeasured. No claim of zero undiscovered bugs or a universal speedup follows from this suite.

## Release Wasm: every upstream case and collection case

One outer sample per case, same browser and SDK, sequential baseline/candidate runs. Milliseconds. Tiny cases approach browser clock resolution; zero duration means below measurement resolution, not zero work. These single-run ratios are exploratory, especially for microsecond cases.

| Workload | Original ms | Candidate ms | Speedup |
|---|---:|---:|---:|
| avoidablePropagation (success) | 738.100 | 418.800 | 1.76x |
| broadPropagation (success) | 1727.900 | 731.000 | 2.36x |
| deepPropagation (success) | 598.701 | 274.100 | 2.18x |
| diamond (success) | 986.500 | 435.900 | 2.26x |
| mux (success) | 850.400 | 461.700 | 1.84x |
| repeatedObservers (success) | 85.599 | 41.600 | 2.06x |
| triangle (success) | 349.600 | 151.600 | 2.31x |
| unstable (success) | 140.800 | 110.800 | 1.27x |
| molBench | 224.100 | 199.900 | 1.12x |
| create_signals | 15.500 | 14.500 | 1.07x |
| comp_0to1 | 13.899 | 9.400 | 1.48x |
| comp_1to1 | 9.400 | 11.500 | 0.82x |
| comp_2to1 | 5.900 | 6.400 | 0.92x |
| comp_4to1 | 7.000 | 5.900 | 1.19x |
| comp_1000to1 | 0.000 | 0.000 | below resolution |
| comp_1to2 | 11.100 | 7.200 | 1.54x |
| comp_1to4 | 8.401 | 6.800 | 1.24x |
| comp_1to8 | 7.000 | 5.500 | 1.27x |
| comp_1to1000 | 4.800 | 4.800 | 1.00x |
| update_1to1 | 18.000 | 15.800 | 1.14x |
| update_2to1 | 9.000 | 7.900 | 1.14x |
| update_4to1 | 4.500 | 3.700 | 1.22x |
| update_1000to1 | 0.000 | 0.000 | below resolution |
| update_1to2 | 9.200 | 7.500 | 1.23x |
| update_1to4 | 4.500 | 3.900 | 1.15x |
| update_1to1000 | 0.000 | 0.100 | below resolution |
| cellx1000 (first: pass, last: pass) | 37.998 | 21.800 | 1.74x |
| cellx2500 (first: pass, last: pass) | 115.599 | 71.300 | 1.62x |
| cellx5000 (first: pass, last: pass) | 238.300 | 160.000 | 1.49x |
| 10x5 - 2 sources - read 20.0% (simple, sum: pass, count: pass) | 939.700 | 430.700 | 2.18x |
| 10x10 - 6 sources - dynamic - read 20.0% (dynamic, sum: pass, count: pass) | 810.701 | 321.700 | 2.52x |
| 1000x12 - 4 sources - dynamic (large, sum: pass, count: pass) | 768.400 | 407.500 | 1.89x |
| 1000x5 - 25 sources (wide dense, sum: pass, count: pass) | 1945.100 | 666.000 | 2.92x |
| 5x500 - 3 sources (deep, sum: pass, count: pass) | 492.399 | 239.200 | 2.06x |
| 100x15 - 6 sources - dynamic (very dynamic, sum: pass, count: pass) | 841.701 | 376.900 | 2.23x |
| native_remove_alternating_10000 | 0.201 | 0.100 | 2.01x |
| observable_remove_alternating_10000 | 0.899 | 0.100 | 8.99x |
| native_remove_alternating_50000 | 0.300 | 0.300 | 1.00x |
| observable_remove_alternating_50000 | 16.500 | 0.200 | 82.50x |
| native_remove_alternating_100000 | 0.500 | 0.500 | 1.00x |
| observable_remove_alternating_100000 | 2747.300 | 0.600 | 4578.83x |
| bulk_map_set_direct | 10.699 | 1.000 | 10.70x |
| bulk_map_set_outer_action | 1.100 | 1.000 | 1.10x |

## Repeated release-Wasm propagation

Three samples per case, 1,000 iterations per sample, one warmup. Median milliseconds.

| Workload | Original ms | Candidate ms | Speedup |
|---|---:|---:|---:|
| avoidablePropagation | 746.600 | 441.800 | 1.69x |
| broadPropagation | 1730.000 | 744.300 | 2.32x |
| deepPropagation | 601.600 | 276.400 | 2.18x |
| diamond | 991.100 | 438.800 | 2.26x |
| mux | 870.000 | 453.200 | 1.92x |
| repeatedObservers | 86.700 | 41.900 | 2.07x |
| triangle | 352.400 | 152.600 | 2.31x |
| unstable | 143.900 | 107.600 | 1.34x |

## Verification results

| Package / check | Native passed | Chrome Wasm passed |
|---|---:|---:|
| Core MobX, including new regression tests | 463, plus 1 existing skip | 463, plus 1 existing skip |
| Code generation | 99 | Not a browser workload |
| Flutter MobX | 30 | 30 |
| Example Todo models | 15 | 15 |
| Lint assist golden | 1 | Not a browser workload |
| Full upstream benchmark cases | 35/35 | 35/35 |
| Additional collection benchmark cases | 8/8 | 8/8 |

Native total: 608 passing tests and one existing skip. Browser total: 508 passing tests and one existing skip. These totals exclude intentionally failing exploratory audit probes and exclude benchmark cases. Both the core default discovery and coverage aggregator were exercised. [Verification logs](verification/) are retained alongside raw timing reports.

Flutter Wasm revealed an additional compatibility defect: Observer debug names only recognized VM-style stack frames. The parser now handles Chrome Wasm frames and skips initializer/constructor pairs, including subclass frames. Native and Wasm suites include the new regression. The two original live-stack tests now accept runtime-specific closure spelling while still requiring the caller information. The lint assist test initially failed solely because its snapshot matcher defaulted to pretty JSON while the existing golden and writer used compact JSON; passing an explicit encoder fixed it without changing expected edits.

Static analysis passed for core MobX and the changed Flutter source/tests. These are local Dart 3.13.2 / installed Flutter checks, not a completed stable/beta CI matrix. Existing resolved local path overrides point Flutter/codegen/examples at this checkout. The legacy lint package still has an outdated SDK constraint; its test was run using the repository's existing resolved dependencies. This patch does not modernize or re-enable its already-excluded CI job.

The added performance workflow runs native and Wasm core correctness, release smoke benchmarks, and optional full native/Wasm upstream measurements, with JSON artifacts. The existing Flutter CI now also runs Wasm widget tests. These workflow edits have not been executed on GitHub. Timing gates are optional on controlled hardware; shared-runner timings are informational.

## Completed correctness fixes and core integration

All ten previously unresolved specifications are now fixed. The maintained tests
live in `mobx/test/regressions/`, and benchmark smoke/harness tests live in
`mobx/test/benchmark/`. Core verification is now **505 passing tests plus one
existing skip**, on both native Dart and Chrome Wasm. Codegen remains 99 passing,
Flutter MobX 30 passing on native/Wasm, and native example tests 15 passing.
The lint assist's earlier passing result is unchanged; it was not rerun in this
follow-up. See [the resolved audit](../../tool/audit/RESOLVED.md) and
[updated verification logs](correctness-verification/).

All 35 benchmark workloads are now maintained locally in `benchmark/workloads/`,
formatted and analyzed with the rest of the package. They return typed results
instead of printing upstream tables. The runner no longer intercepts console
output or infers success from labels. Attribution and the MIT license are retained.
The older tables above describe the earlier implementation and harness snapshot.
Current full-suite reports are `integrated-native-all.json` and
`integrated-wasm-all.json`; the workload parameters remain compatible.

### Correctness-pass performance spot checks

Three-sample propagation medians, measured sequentially before the workload layout/reporting integration. Ratios compare the same-machine original MobX baseline with the correctness-fixed implementation; individual changes are not isolated.

| Workload | Native speedup | Wasm speedup |
|---|---:|---:|
| avoidablePropagation | 1.80x | 1.71x |
| broadPropagation | 3.16x | 2.38x |
| deepPropagation | 2.41x | 2.20x |
| diamond | 2.76x | 2.29x |
| mux | 2.14x | 1.89x |
| repeatedObservers | 2.07x | 2.04x |
| triangle | 3.00x | 2.26x |
| unstable | 1.53x | 1.30x |
