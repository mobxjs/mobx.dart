import 'cellx_bench.dart';
import 'dynamic_bench.dart';
import 'kairo_bench.dart';
import 'mol_bench.dart';
import 'reactive_framework.dart';
import 's_bench.dart';
import 'results.dart';

Future<List<WorkloadResult>> runFrameworkBench(
  ReactiveFramework framework,
) async => [
  ...await kairoBench(framework),
  await molBench(framework),
  ...sbench(framework),
  ...cellxBench(framework),
  ...await dynamicBench(framework),
];
