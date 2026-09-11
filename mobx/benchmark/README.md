# MobX performance suite

This suite runs against the MobX package in this checkout. It includes all 35
workloads from `medz/dart-reactivity-benchmark`, a median-based propagation
runner, and collection scaling/batching workloads. No external benchmark package
or network checkout is needed after the normal `dart pub get`.

The workloads are part of this repository under [workloads/](workloads/).
They follow the package's Dart formatting and static analysis, and return typed
results directly to the runner. Source attribution and the original license are
retained in [workloads/ATTRIBUTION.md](workloads/ATTRIBUTION.md).

Core tests are organized under `test/regressions/` and `test/benchmark/`.
The normal test command includes short correctness runs of all eight propagation
graphs. Full timing runs use the commands below and are separate from test timing.

From the `mobx/` package directory:

```sh
dart pub get
dart test
dart compile exe benchmark/run.dart -o /tmp/mobx-perf

# Eight graph workloads: one warmup, three samples, median plus raw samples.
/tmp/mobx-perf --suite=propagation --samples=3 --iterations=1000 --output=/tmp/propagation.json

# Native/observable list filtering at 10k/50k/100k and map/set bulk writes.
/tmp/mobx-perf --suite=collections --samples=3 --output=/tmp/collections.json

# All 35 integrated workloads; iteration counts and inner timing methods are upstream's.
/tmp/mobx-perf --suite=upstream --samples=1 --output=/tmp/upstream.json

# Upstream plus collections in one report.
/tmp/mobx-perf --suite=all --samples=1 --output=/tmp/all.json
```

`--suite=propagation --samples=1 --iterations=5` is a short correctness smoke
run, not a reliable timing result. Failures in workload output/counters produce a
nonzero exit. JSON contains the SDK, OS, processor count, workload parameters,
raw samples, medians, and success status. Progress goes to stderr. Adapters
dispose reactions outside the timed propagation sections.

**Comparing changes**

Compile a baseline executable before editing, then compile the candidate. Run
them sequentially on the same machine, with the same SDK and options, while the
machine is otherwise idle. Preserve both JSON reports:

```sh
dart benchmark/compare.dart /tmp/baseline.json /tmp/candidate.json

# Optional controlled-runner gate: fail if any case takes over 10% longer.
dart benchmark/compare.dart /tmp/baseline.json /tmp/candidate.json 10
```

Comparison rejects failed cases, missing cases, incompatible parameters, and
incompatible recorded SDK/OS metadata. It does not prove that two machines with
the same metadata have identical hardware or load. Do not use a laptop baseline
as a timing threshold on shared GitHub runners. Inspect individual workloads;
do not sum unlike workloads into a claimed application speedup.

The workload algorithms retain the baseline timing methods: best-of-ten for
some families, single measurements for others, and accumulated times for cellx.
Outer `--samples` repeat those reported measurements. Not every upstream case
asserts output correctness; status means no reported upstream failure. Use the
dedicated regression suite alongside it. Use the separate Wasm runner below for
browser measurements; Flutter frame latency is not measured by either runner.

**Correctness and CI**

The normal `dart test` suite includes:

- `regressions/dependency_propagation_test.dart`: lifecycle reentrancy, false
  dependencies, cycle recovery, comparer failures, nested duplicate reads,
  disposal, and 4,000 generated-graph mutations plus a 1,000-step diamond case.
- `regressions/collection_mutation_test.dart`: batching, original-index
  notification payloads, predicate exceptions, and listener failures.
- `benchmark/benchmark_harness_test.dart`: rejects fast-but-invalid or incomparable reports.

The `Performance suite` workflow runs native and Wasm tests and smoke checks on relevant PRs and can
run the full upstream suite through `workflow_dispatch` with `full=true`.
It uploads reports; shared-runner timings are informational. Existing core CI
continues to run the complete test suite and static analysis.

All original audit specifications now pass. The regular suite includes `regressions/audit_correctness_test.dart`, with 33 async, stream, disposal, context, interceptor, and cast-view checks. Historical failures remain documented in `tool/audit/`; see [the resolved audit](../tool/audit/RESOLVED.md).

Measured local before/after reports and their limitations are recorded in
[`results/`](results/README.md).

**Release Wasm and browser correctness**

```sh
dart test test/all_tests.dart --platform chrome --compiler dart2wasm
mkdir -p .dart_tool/mobx-wasm
dart compile wasm benchmark/web.dart -o .dart_tool/mobx-wasm/run.wasm
dart benchmark/run_wasm.dart --suite=propagation --samples=3 --iterations=1000 --output=/tmp/wasm-propagation.json
dart benchmark/run_wasm.dart --suite=all --samples=1 --output=/tmp/wasm-all.json
```

The Wasm runner serves the build on loopback, launches a fresh headless Chrome
profile, waits for a JSON result, then removes the temporary profile. Set
`CHROME_EXECUTABLE` if Chrome is not at the default macOS location or available
as `google-chrome` on Linux. `--build=/path` selects a separately compiled build;
compile the baseline using the original package source and the same harness.
Compare Wasm reports with `compare.dart`, just like native reports. Browser/runtime
metadata must match. Reports containing zero durations are rejected by the
comparison tool: some tiny upstream cases fall below browser clock resolution.
Use the longer propagation cases for reliable browser comparisons. These measure core reactive operations, not Flutter frame
rendering or application startup. Test-runner Wasm enables assertions; the separate
benchmark build above does not.

For Flutter integration, from `flutter_mobx/` run `flutter test`, then
`flutter test --platform chrome --wasm` after resolving its package dependencies.

To investigate primitive microbenchmark variance, native and Wasm runners also
support `--suite=primitives --samples=7`, and isolating one case with
`--suite=primitives --case=comp_2to1 --samples=15`.
