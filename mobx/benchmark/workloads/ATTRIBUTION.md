# Workload attribution

These workloads are maintained as part of the MobX repository. They were adapted
from https://github.com/medz/dart-reactivity-benchmark at revision
`03663d64413a84c3449b932dac10f576b6314dd0`, retrieved 2026-09-11.

The original MIT license is retained in `LICENSE`, along with attribution
comments in the sources for workloads originating in other benchmark projects.

Local adaptations:

- Repository Dart formatting and static analysis apply to every workload.
- Workloads return typed `WorkloadResult` values directly. They do not print
  upstream tables, and the runner does not intercept or parse console output.
- Dynamic graph success checks use numeric sum/count comparisons, avoiding the
  original misspelled textual sum-failure marker.
- The local MobX adapter owns reaction disposal. Native and Wasm runners share
  the same workload implementations.
- Workload parameters and timing methods remain compatible with the imported
  35-case benchmark baseline; timings retain the original family-specific methods.

There is no external benchmark dependency, checkout step, or vendored package
wrapper. Upstream provenance does not imply that this adapted copy is unmodified.
