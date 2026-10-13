# MobX benchmark workloads

These local Dart sources belong to the core MobX performance suite. They follow
its formatting and analysis rules, and return typed `WorkloadResult` records.
There is no table rendering, console-output parsing, or external package loading.

| Family | Source | Cases |
|---|---|---:|
| Propagation graphs | `kairo/`, `kairo_bench.dart` | 8 |
| Mol | `mol_bench.dart` | 1 |
| Primitive creation/computation/update | `s_bench.dart` | 17 |
| Cellx | `cellx_bench.dart` | 3 |
| Dynamic graph configurations | `dynamic_bench.dart`, `config.dart` | 6 |

`run_framework_bench.dart` assembles all 35 cases. `results.dart` defines the
measurement contract. The MobX adapter and native/Wasm runners live one directory
up. Core smoke tests live in `test/benchmark/`.

See [ATTRIBUTION.md](ATTRIBUTION.md) and [LICENSE](LICENSE) for source provenance.
Workload parameters retain compatibility with the recorded baseline; aggregation
methods still differ by family, so do not sum them into an application speedup.
