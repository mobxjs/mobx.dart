// Inspired by https://github.com/solidjs/solid/blob/main/packages/solid/bench/bench.cjs
import 'reactive_framework.dart';
import 'results.dart';

const count = 100000;

// Common type definitions
typedef Reader = int Function();
typedef SignalCreator =
    List<Signal<int>> Function(
      int n,
      List<Signal<int>> sources,
      ReactiveFramework framework,
    );

typedef ComputationCreator =
    void Function(
      int n,
      List<ISignal<int>> sources,
      ReactiveFramework framework,
    );

typedef UpdateTest =
    void Function(
      int n,
      List<Signal<int>> sources,
      ReactiveFramework framework,
    );

// Test cases organized by type
final createTests = <String, (SignalCreator, int, int)>{
  'create_signals': (createDataSignals, count, count),
};

final computeTests = <String, (ComputationCreator, int, int)>{
  'comp_0to1': (createComputations0to1, count, 0),
  'comp_1to1': (createComputations1to1, count, count),
  'comp_2to1': (createComputations2to1, count ~/ 2, count),
  'comp_4to1': (createComputations4to1, count ~/ 4, count),
  'comp_1000to1': (createComputations1000to1, count ~/ 1000, count),
  'comp_1to2': (createComputations1to2, count, count ~/ 2),
  'comp_1to4': (createComputations1to4, count, count ~/ 4),
  'comp_1to8': (createComputations1to8, count, count ~/ 8),
  'comp_1to1000': (createComputations1to1000, count, count ~/ 1000),
};

final updateTests = <String, (UpdateTest, int, int)>{
  'update_1to1': (updateComputations1to1, count * 4, 1),
  'update_2to1': (updateComputations2to1, count * 2, 2),
  'update_4to1': (updateComputations4to1, count, 4),
  'update_1000to1': (updateComputations1000to1, count ~/ 100, 1000),
  'update_1to2': (updateComputations1to2, count * 4, 1),
  'update_1to4': (updateComputations1to4, count * 4, 1),
  'update_1to1000': (updateComputations1to1000, count * 4, 1),
};

List<WorkloadResult> sbench(ReactiveFramework framework) {
  final results = <WorkloadResult>[];
  // Run create tests
  for (final entry in createTests.entries) {
    final name = entry.key;
    final (test, testCount, sourceCount) = entry.value;
    final time = runCreateTest(test, testCount, sourceCount, framework);
    results.add(WorkloadResult(name: name, elapsedMicroseconds: time));
  }

  // Run compute tests
  for (final entry in computeTests.entries) {
    final name = entry.key;
    final (test, testCount, sourceCount) = entry.value;
    final time = runComputeTest(test, testCount, sourceCount, framework);
    results.add(WorkloadResult(name: name, elapsedMicroseconds: time));
  }

  // Run update tests
  for (final entry in updateTests.entries) {
    final name = entry.key;
    final (test, testCount, sourceCount) = entry.value;
    final time = runUpdateTest(test, testCount, sourceCount, framework);
    results.add(WorkloadResult(name: name, elapsedMicroseconds: time));
  }
  return results;
}

int runCreateTest(
  SignalCreator fn,
  int n,
  int scount,
  ReactiveFramework framework,
) {
  final stopwatch = Stopwatch();

  framework.withBuild(() {
    var sources = <Signal<int>>[];
    // Warm up
    sources = fn(scount, [], framework);
    fn(n ~/ 100, sources, framework);
    sources = fn(scount, [], framework);
    fn(n ~/ 100, sources, framework);
    sources = fn(scount, [], framework);
    fn(n ~/ 100, sources, framework);
    sources = fn(scount, [], framework);

    stopwatch
      ..reset()
      ..start();
    fn(n, sources, framework);
    stopwatch.stop();
  });

  return stopwatch.elapsedMicroseconds;
}

int runComputeTest(
  ComputationCreator fn,
  int n,
  int scount,
  ReactiveFramework framework,
) {
  final stopwatch = Stopwatch();

  framework.withBuild(() {
    var sources = createDataSignals(scount, [], framework);
    // Warm up
    fn(n ~/ 100, sources, framework);
    sources = createDataSignals(scount, [], framework);
    fn(n ~/ 100, sources, framework);
    sources = createDataSignals(scount, [], framework);
    fn(n ~/ 100, sources, framework);
    sources = createDataSignals(scount, [], framework);

    stopwatch
      ..reset()
      ..start();
    fn(n, sources, framework);
    stopwatch.stop();
  });

  return stopwatch.elapsedMicroseconds;
}

int runUpdateTest(
  UpdateTest fn,
  int n,
  int scount,
  ReactiveFramework framework,
) {
  final stopwatch = Stopwatch();

  framework.withBuild(() {
    var sources = createDataSignals(scount, [], framework);
    // Warm up
    fn(n ~/ 100, sources, framework);
    sources = createDataSignals(scount, [], framework);
    fn(n ~/ 100, sources, framework);
    sources = createDataSignals(scount, [], framework);
    fn(n ~/ 100, sources, framework);
    sources = createDataSignals(scount, [], framework);

    stopwatch
      ..reset()
      ..start();
    fn(n, sources, framework);
    stopwatch.stop();
  });

  return stopwatch.elapsedMicroseconds;
}

List<Signal<int>> createDataSignals(
  int n,
  List<Signal<int>> sources,
  ReactiveFramework framework,
) {
  for (var i = 0; i < n; i++) {
    sources.add(framework.signal(i));
  }
  return sources;
}

void createComputations0to1(
  int n,
  List<ISignal<int>> sources,
  ReactiveFramework framework,
) {
  for (var i = 0; i < n; i++) {
    createComputation0(i, framework);
  }
}

void createComputations1to1000(
  int n,
  List<ISignal<int>> sources,
  ReactiveFramework framework,
) {
  for (var i = 0; i < n ~/ 1000; i++) {
    int Function() get = sources[i].read;
    for (var j = 0; j < 1000; j++) {
      createComputation1(get, framework);
    }
  }
}

void createComputations1to8(
  int n,
  List<ISignal<int>> sources,
  ReactiveFramework framework,
) {
  for (var i = 0; i < n ~/ 8; i++) {
    int Function() get = sources[i].read;
    createComputation1(get, framework);
    createComputation1(get, framework);
    createComputation1(get, framework);
    createComputation1(get, framework);
    createComputation1(get, framework);
    createComputation1(get, framework);
    createComputation1(get, framework);
    createComputation1(get, framework);
  }
}

void createComputations1to4(
  int n,
  List<ISignal<int>> sources,
  ReactiveFramework framework,
) {
  for (var i = 0; i < n ~/ 4; i++) {
    int Function() get = sources[i].read;
    createComputation1(get, framework);
    createComputation1(get, framework);
    createComputation1(get, framework);
    createComputation1(get, framework);
  }
}

void createComputations1to2(
  int n,
  List<ISignal<int>> sources,
  ReactiveFramework framework,
) {
  for (var i = 0; i < n ~/ 2; i++) {
    int Function() get = sources[i].read;
    createComputation1(get, framework);
    createComputation1(get, framework);
  }
}

void createComputations1to1(
  int n,
  List<ISignal<int>> sources,
  ReactiveFramework framework,
) {
  for (var i = 0; i < n; i++) {
    int Function() get = sources[i].read;
    createComputation1(get, framework);
  }
}

void createComputations2to1(
  int n,
  List<ISignal<int>> sources,
  ReactiveFramework framework,
) {
  for (var i = 0; i < n; i++) {
    createComputation2(sources[i * 2].read, sources[i * 2 + 1].read, framework);
  }
}

void createComputations4to1(
  int n,
  List<ISignal<int>> sources,
  ReactiveFramework framework,
) {
  for (var i = 0; i < n; i++) {
    createComputation4(
      sources[i * 4].read,
      sources[i * 4 + 1].read,
      sources[i * 4 + 2].read,
      sources[i * 4 + 3].read,
      framework,
    );
  }
}

void createComputations1000to1(
  int n,
  List<ISignal<int>> sources,
  ReactiveFramework framework,
) {
  for (var i = 0; i < n; i++) {
    createComputation1000(sources, i * 1000, framework);
  }
}

void createComputation0(int i, ReactiveFramework framework) {
  framework.computed(() => i);
}

void createComputation1(Reader s1, ReactiveFramework framework) {
  framework.computed(() => s1());
}

void createComputation2(Reader s1, Reader s2, ReactiveFramework framework) {
  framework.computed(() => s1() + s2());
}

void createComputation4(
  Reader s1,
  Reader s2,
  Reader s3,
  Reader s4,
  ReactiveFramework framework,
) {
  framework.computed(() => s1() + s2() + s3() + s4());
}

void createComputation1000(
  List<ISignal<int>> ss,
  int offset,
  ReactiveFramework framework,
) {
  framework.computed(() {
    var sum = 0;
    for (var i = 0; i < 1000; i++) {
      sum += ss[offset + i].read();
    }
    return sum;
  });
}

void updateComputations1to1(
  int n,
  List<Signal<int>> sources,
  ReactiveFramework framework,
) {
  int Function() get1 = sources[0].read;
  void Function(int) set1 = sources[0].write;
  framework.computed(() => get1());
  for (var i = 0; i < n; i++) {
    set1(i);
  }
}

void updateComputations2to1(
  int n,
  List<Signal<int>> sources,
  ReactiveFramework framework,
) {
  int Function() get1 = sources[0].read;
  void Function(int) set1 = sources[0].write;
  int Function() get2 = sources[1].read;
  framework.computed(() => get1() + get2());
  for (var i = 0; i < n; i++) {
    set1(i);
  }
}

void updateComputations4to1(
  int n,
  List<Signal<int>> sources,
  ReactiveFramework framework,
) {
  int Function() get1 = sources[0].read;
  void Function(int) set1 = sources[0].write;
  int Function() get2 = sources[1].read;
  int Function() get3 = sources[2].read;
  int Function() get4 = sources[3].read;
  framework.computed(() => get1() + get2() + get3() + get4());
  for (var i = 0; i < n; i++) {
    set1(i);
  }
}

void updateComputations1000to1(
  int n,
  List<Signal<int>> sources,
  ReactiveFramework framework,
) {
  void Function(int) set1 = sources[0].write;
  framework.computed(() {
    var sum = 0;
    for (var i = 0; i < 1000; i++) {
      sum += sources[i].read();
    }
    return sum;
  });
  for (var i = 0; i < n; i++) {
    set1(i);
  }
}

void updateComputations1to2(
  int n,
  List<Signal<int>> sources,
  ReactiveFramework framework,
) {
  int Function() get1 = sources[0].read;
  void Function(int) set1 = sources[0].write;
  framework.computed(() => get1());
  framework.computed(() => get1());
  for (var i = 0; i < n ~/ 2; i++) {
    set1(i);
  }
}

void updateComputations1to4(
  int n,
  List<Signal<int>> sources,
  ReactiveFramework framework,
) {
  int Function() get1 = sources[0].read;
  void Function(int) set1 = sources[0].write;
  framework.computed(() => get1());
  framework.computed(() => get1());
  framework.computed(() => get1());
  framework.computed(() => get1());
  for (var i = 0; i < n ~/ 4; i++) {
    set1(i);
  }
}

void updateComputations1to1000(
  int n,
  List<Signal<int>> sources,
  ReactiveFramework framework,
) {
  int Function() get1 = sources[0].read;
  void Function(int) set1 = sources[0].write;
  for (var i = 0; i < 1000; i++) {
    framework.computed(() => get1());
  }
  for (var i = 0; i < n ~/ 1000; i++) {
    set1(i);
  }
}
