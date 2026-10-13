import 'dart:math';
import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

void main() {
  test(
    'generated acyclic graphs agree with a reference after branch churn',
    () {
      for (var seed = 0; seed < 20; seed++) {
        final random = Random(seed);
        final context = ReactiveContext();
        final sources = List.generate(
          8,
          (_) => Observable(random.nextInt(20), context: context),
        );
        final nodes = <ObservableValue<int>>[...sources];
        final edges = <(int, int, int)>[];
        for (var i = 8; i < 32; i++) {
          final a = random.nextInt(i),
              b = random.nextInt(i),
              c = random.nextInt(i);
          edges.add((a, b, c));
          nodes.add(
            Computed(
              () =>
                  nodes[a].value +
                  (sources[0].value.isEven ? nodes[b].value : nodes[c].value),
              context: context,
            ),
          );
        }
        var actual = <int>[];
        final errors = <Object>[];
        final dispose = autorun(
          (_) {
            actual = [for (var i = 20; i < 32; i++) nodes[i].value];
          },
          context: context,
          onError: (error, _) => errors.add(error),
        );
        try {
          for (var step = 0; step < 200; step++) {
            runInAction(() {
              for (final source in sources) {
                source.value = random.nextInt(20);
              }
            }, context: context);
            final expected = sources.map((source) => source.value).toList();
            for (final (a, b, c) in edges) {
              expected.add(
                expected[a] + (expected[0].isEven ? expected[b] : expected[c]),
              );
            }
            expect(errors, isEmpty, reason: 'seed=$seed step=$step');
            expect(
              actual,
              expected.sublist(20),
              reason: 'seed=$seed step=$step',
            );
          }
        } finally {
          dispose();
        }
        expect(sources.every((source) => !source.hasObservers), isTrue);
      }
    },
  );

  test(
    'nested and repeated reads are deduplicated and released on disposal',
    () {
      final context = ReactiveContext();
      final source = Observable(1, context: context);
      final computed = Computed(() => source.value * 2, context: context);
      final values = <int>[];
      final dispose = autorun(
        (_) => values.add(source.value + computed.value + source.value),
        context: context,
      );
      runInAction(() {
        source.value = 2;
      }, context: context);
      expect(values, [4, 8]);
      dispose();
      expect(source.hasObservers, isFalse);
      expect(computed.hasObservers, isFalse);
    },
  );

  test('G8 computed equality failures reach observing reaction', () {
    final context = ReactiveContext();
    final source = Observable(1, context: context);
    final computed = Computed(
      () => source.value,
      context: context,
      equals: (a, b) {
        if (b == 2) throw StateError('equality');
        return a == b;
      },
    );
    final errors = <Object>[];
    final dispose = autorun(
      (_) {
        computed.value;
      },
      context: context,
      onError: (error, _) => errors.add(error),
    );
    addTearDown(dispose.call);
    runInAction(() {
      source.value = 2;
    }, context: context);
    expect(errors, isNotEmpty);
  });

  test('G9 writing an observable does not subscribe to its previous value', () {
    final context = ReactiveContext();
    final target = Observable(0, context: context);
    var runs = 0;
    final dispose = autorun((_) {
      runs++;
      target.value = 5;
    }, context: context);
    addTearDown(dispose.call);
    runInAction(() {
      target.value = 6;
    }, context: context);
    expect(runs, 1);
    expect(target.value, 6);
  });

  test('G10 lifecycle handler may unregister itself during delivery', () {
    final context = ReactiveContext();
    final atom = Atom(context: context);
    final errors = <Object>[];
    var otherCalls = 0;
    late void Function() stop;
    stop = atom.onBecomeObserved(() {
      stop();
    });
    atom.onBecomeObserved(() {
      otherCalls++;
    });
    final dispose = autorun(
      (_) {
        atom.reportObserved();
      },
      context: context,
      onError: (error, _) => errors.add(error),
    );
    addTearDown(dispose.call);
    expect(errors, isEmpty);
    expect(otherCalls, 1);
  });

  test('G1 computed reports successive distinct errors', () {
    final context = ReactiveContext();
    final source = Observable(0, context: context);
    final computed = Computed<int>(
      () => throw StateError('error ${source.value}'),
      context: context,
    );
    final errors = <String>[];
    final dispose = autorun(
      (_) {
        computed.value;
      },
      context: context,
      onError: (error, _) => errors.add(error.toString()),
    );
    addTearDown(dispose.call);
    runInAction(() {
      source.value = 1;
    }, context: context);
    expect(errors.length, 2);
    expect(errors.last, contains('error 1'));
  });

  test('G2 resubscribing during computed unobserve preserves dependencies', () {
    final context = ReactiveContext();
    final source = Observable(1, context: context);
    final computed = Computed(() => source.value * 2, context: context);
    var latest = 0;
    ReactionDisposer? replacement;
    final stopHook = computed.onBecomeUnobserved(() {
      replacement ??= autorun((_) {
        latest = computed.value;
      }, context: context);
    });
    final original = autorun((_) {
      computed.value;
    }, context: context);
    original();
    runInAction(() {
      source.value = 2;
    }, context: context);
    stopHook();
    replacement?.call();
    expect(latest, 4);
  });

  test('G3 lifecycle hook reads do not become caller dependencies', () {
    final context = ReactiveContext();
    final unrelated = Observable(0, context: context);
    final atom = Atom(
      context: context,
      onObserved: () {
        unrelated.value;
      },
    );
    var runs = 0;
    final dispose = autorun((_) {
      atom.reportObserved();
      runs++;
    }, context: context);
    addTearDown(dispose.call);
    runInAction(() {
      unrelated.value = 1;
    }, context: context);
    expect(runs, 1);
  });

  test('G4 cycle recovery does not strand an unrelated scheduled reaction', () {
    final context = ReactiveContext(config: ReactiveConfig(maxIterations: 5));
    final source = Observable(0, context: context);
    final looping = Observable(0, context: context);
    var latest = 0;
    final independent = autorun((_) {
      latest = source.value;
    }, context: context);
    ReactionDisposer? cycle;
    // A cycle schedules independent work only on the final allowed wave.
    cycle = autorun((_) {
      final value = looping.value;
      if (value > 0) {
        runInAction(() {
          looping.value = value + 1;
          if (value == 4) source.value = 1;
        }, context: context);
      }
    }, context: context);
    expect(
      () => runInAction(() {
        looping.value = 1;
      }, context: context),
      throwsA(isA<MobXCyclicReactionException>()),
    );
    cycle();
    runInAction(() {
      source.value = 2;
    }, context: context);
    independent();
    expect(latest, 2);
  });

  test('G5 error handler registration is isolated per context', () {
    final a = ReactiveContext();
    final b = ReactiveContext();
    var received = 0;
    final stop = a.onReactionError((_, _) {
      received++;
    });
    final dispose = autorun((_) => throw StateError('context B'), context: b);
    stop();
    dispose();
    expect(received, 0);
  });

  test('G6 computed equality exception can recover without stale cache', () {
    final context = ReactiveContext();
    final source = Observable(1, context: context);
    final computed = Computed(
      () => source.value,
      context: context,
      equals: (a, b) {
        if (b == 2) throw StateError('equality');
        return a == b;
      },
    );
    var latest = 0;
    final dispose = autorun((_) {
      latest = computed.value;
    }, context: context);
    addTearDown(dispose.call);
    try {
      runInAction(() {
        source.value = 2;
      }, context: context);
    } catch (_) {}
    runInAction(() {
      source.value = 3;
    }, context: context);
    expect(latest, 3);
    expect(context.isWithinBatch, isFalse);
  });

  test('G7 seeded dynamic diamond graph stays consistent across batches', () {
    final random = Random(713);
    final context = ReactiveContext();
    final a = Observable(1, context: context);
    final b = Observable(2, context: context);
    final branch = Observable(true, context: context);
    final left = Computed(
      () => branch.value ? a.value * 2 : b.value * 3,
      context: context,
    );
    final right = Computed(() => a.value + b.value, context: context);
    final total = Computed(() => left.value + right.value, context: context);
    var latest = 0;
    final dispose = autorun((_) {
      latest = total.value;
    }, context: context);
    addTearDown(dispose.call);
    for (var i = 0; i < 1000; i++) {
      runInAction(() {
        a.value = random.nextInt(100);
        b.value = random.nextInt(100);
        branch.value = random.nextBool();
      }, context: context);
      expect(
        latest,
        (branch.value ? a.value * 2 : b.value * 3) + a.value + b.value,
        reason: 'step $i',
      );
    }
  });
}
