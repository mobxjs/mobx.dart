# Core correctness regressions

These are normal `package:test` tests against this checkout's MobX implementation.
They run with `dart test` and through `test/all_tests.dart` for coverage and Wasm.

- `audit_correctness_test.dart`: async context/zone ownership, stream terminal
  behavior, nullable values, timer disposal, interception, and collection views.
- `dependency_propagation_test.dart`: dependency changes, lifecycle reentrancy,
  error recovery, duplicate reads, disposal, and generated graph checks.
- `collection_mutation_test.dart`: filtering, coherent batching, notifications,
  and mutation error paths.

Historical audit notes and before-fix outputs live in `tool/audit/`; the maintained
regression tests live here.
