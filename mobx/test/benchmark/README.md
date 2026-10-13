# Benchmark correctness tests

These tests run as part of the ordinary core test suite:

- `workloads_test.dart`: short executions of the eight propagation graph workloads
  and validation of typed workload failure reporting.
- `benchmark_harness_test.dart`: rejects failed, incomplete, or incompatible
  measurement reports.

The full 35 workloads are owned by `benchmark/workloads/`. Timing entry points
are `benchmark/run.dart` (native) and `benchmark/web.dart` (Wasm), sharing
`benchmark/suite.dart`. Use those entry points to measure performance; test-runner
timings and assertion-enabled test builds are not performance measurements.
