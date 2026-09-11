// Reproductions promoted from the original correctness audit.
import 'dart:async';
import 'package:fake_async/fake_async.dart';
import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

Future<void> tick() => Future<void>.delayed(Duration.zero);

void main() {
  test('F1 future uses supplied context', () async {
    final context = ReactiveContext();
    final completer = Completer<int>();
    final future = ObservableFuture(completer.future, context: context);
    final states = <FutureStatus>[];
    final dispose = autorun((_) => states.add(future.status), context: context);
    addTearDown(dispose.call);
    completer.complete(42);
    await tick();
    expect(states, [FutureStatus.pending, FutureStatus.fulfilled]);
  });

  test('F2 reused async action preserves caller zone', () async {
    final action = AsyncAction('reused');
    Future<Object?> call(String id) => runZoned(
      () => action.run(() async {
        await tick();
        return Zone.current[#request];
      }),
      zoneValues: {#request: id},
    );
    expect(await call('A'), 'A');
    expect(await call('B'), 'B');
  });

  test('F3 binary error callback executes inside action', () async {
    final context = ReactiveContext();
    final action = AsyncAction('binary', context: context);
    var batched = false;
    await action.run(
      () => Future<void>.error(StateError('source')).catchError((
        Object e,
        StackTrace s,
      ) {
        batched = context.isWithinBatch;
      }),
    );
    expect(batched, isTrue);
  });

  test('F4 stream forwards original error stack', () async {
    final source = StreamController<int>();
    final stream = ObservableStream(source.stream);
    final stack = StackTrace.fromString('original source stack');
    StackTrace? received;
    final subscription = stream.listen(
      null,
      onError: (Object e, StackTrace s) {
        received = s;
      },
    );
    source.addError(StateError('source'), stack);
    await tick();
    await subscription.cancel();
    await source.close();
    expect(received.toString(), stack.toString());
  });

  test('F5 cancelOnError finishes downstream', () async {
    final source = StreamController<int>();
    final stream = ObservableStream(source.stream, cancelOnError: true);
    var done = false;
    final subscription = stream.listen(
      null,
      onError: (Object e) {},
      onDone: () {
        done = true;
      },
    );
    source.addError(StateError('source'));
    await tick();
    await tick();
    final status = stream.status;
    await subscription.cancel();
    await source.close();
    expect(done, isTrue);
    expect(status, StreamStatus.done);
  });

  test('F6 throwing map listener does not hide committed mutation', () {
    final map = ObservableMap<String, int>.of({'a': 1});
    var seen = 0;
    final dispose = autorun((_) {
      seen = map['a']!;
    });
    addTearDown(dispose.call);
    map.observe((_) => throw StateError('listener'));
    expect(() => map['a'] = 2, throwsStateError);
    expect(map['a'], 2);
    expect(seen, 2);
  });

  test('F7 throwing list predicate does not hide partial mutation', () {
    final list = ObservableList.of([1, 2, 3, 4]);
    var seen = <int>[];
    final dispose = autorun((_) {
      seen = list.toList();
    });
    addTearDown(dispose.call);
    expect(
      () => list.removeWhere((v) {
        if (v == 2) throw StateError('predicate');
        return v.isEven;
      }),
      throwsStateError,
    );
    expect(seen, list.toList());
  });

  test('F8 list remove accepts unrelated Object', () {
    // Deliberately exercise the Object? contract with an unrelated type.
    // ignore: collection_methods_unrelated_type
    expect(ObservableList<int>.of([1]).remove('x'), isFalse);
  });

  test('F9 map lookup accepts unrelated Object', () {
    // Deliberately exercise the Object? contract with an unrelated type.
    // ignore: collection_methods_unrelated_type
    expect(ObservableMap<String, int>.of({'a': 1})[42], isNull);
  });

  test('F10 interceptor notification reports committed value', () {
    final value = Observable(1);
    value.intercept(
      (change) => WillChangeNotification(
        object: value,
        newValue: 10,
        type: OperationType.update,
      ),
    );
    int? seen;
    value.observe((change) {
      seen = change.newValue;
    });
    runInAction(() {
      value.value = 2;
    });
    expect(value.value, 10);
    expect(seen, 10);
  });

  test('F11 computed exception restores context with boundaries disabled', () {
    final context = ReactiveContext(
      config: ReactiveConfig(disableErrorBoundaries: true),
    );
    final computed = Computed<int>(
      () => throw StateError('compute'),
      context: context,
    );
    expect(() => computed.value, throwsStateError);
    expect(context.isWithinBatch, isFalse);
  });

  test('F12 list cast shares change listeners', () {
    final list = ObservableList<num>.of([1]);
    var events = 0;
    list.observe((_) {
      events++;
    });
    list.cast<int>().add(2);
    expect(list, [1, 2]);
    expect(events, 1);
  });

  test('F13 empty range still validates bounds', () {
    final list = ObservableList.of([1]);
    expect(() => list.removeRange(5, 5), throwsRangeError);
  });

  test('F14 throwing set listener does not hide committed mutation', () {
    final set = ObservableSet<int>();
    var seen = 0;
    final dispose = autorun((_) {
      seen = set.length;
    });
    addTearDown(dispose.call);
    set.observe((_) => throw StateError('listener'));
    expect(() => set.add(1), throwsStateError);
    expect(seen, 1);
  });

  test('F15 empty stream match supports nullable done value', () async {
    final stream = ObservableStream<int>(const Stream<int>.empty());
    final dispose = autorun((_) {
      stream.status;
    });
    await tick();
    final status = stream.status;
    dispose();
    await stream.close();
    expect(status, StreamStatus.done);
    expect(stream.match(done: (value, error) => value), isNull);
  });

  test('F16 disposed delayed reaction cancels its timer', () {
    Timer? timer;
    final dispose = autorun(
      (_) {},
      scheduler: (fn) => timer = Timer(const Duration(hours: 1), fn),
    );
    dispose();
    final active = timer!.isActive;
    timer!.cancel();
    expect(active, isFalse);
  });

  test('F17 when effect uses supplied context', () {
    final context = ReactiveContext();
    var batched = false;
    when((_) => true, () {
      batched = context.isWithinBatch;
    }, context: context);
    // Inspect action ownership using spy, since autorun itself also batches.
    final events = <SpyEvent>[];
    context.config = ReactiveConfig(isSpyEnabled: true);
    final stop = context.spy(events.add);
    when((_) => true, () {}, context: context, name: 'localWhen');
    stop();
    expect(batched, isTrue);
    expect(
      events.whereType<ActionSpyEvent>().any(
        (event) => event.name == 'localWhen-effect',
      ),
      isTrue,
    );
  });

  test('F18 scheduled reaction effect batches supplied context', () async {
    final context = ReactiveContext();
    final source = Observable(0, context: context);
    bool? batched;
    final dispose = reaction(
      (_) => source.value,
      (_) {
        batched = context.isWithinBatch;
      },
      context: context,
      delay: 0,
    );
    addTearDown(dispose.call);
    runInAction(() {
      source.value = 1;
    }, context: context);
    await tick();
    expect(batched, isTrue);
  });

  test('P4 observation-only single stream retains historical events', () async {
    final source = StreamController<int>();
    final stream = ObservableStream(source.stream);
    final dispose = autorun((_) {
      stream.value;
    });
    for (var i = 0; i < 10000; i++) {
      source.add(i);
    }
    await tick();
    expect(stream.value, 9999);
    var delivered = 0;
    final subscription = stream.listen((_) {
      delivered++;
    });
    await tick();
    dispose();
    await subscription.cancel();
    await source.close();
    // Characterization, not a regression assertion: all old events were queued.
    expect(delivered, 10000);
  });

  test(
    'F19 throwing reaction error handler restores default-boundary context',
    () {
      final context = ReactiveContext();
      expect(
        () => autorun(
          (_) => throw StateError('body'),
          context: context,
          onError: (error, reaction) => throw StateError('handler'),
        ),
        throwsStateError,
      );
      expect(context.isWithinBatch, isFalse);
    },
  );

  group('async ownership and completion', () {
    test('overlapping calls on one AsyncAction keep separate zones', () async {
      final action = AsyncAction('overlap');
      final a = Completer<void>();
      final b = Completer<void>();
      Future<Object?> call(String id, Future<void> gate) => runZoned(
        () => action.run(() async {
          expect(Zone.current[#request], id);
          await gate;
          await tick();
          return Zone.current[#request];
        }),
        zoneValues: {#request: id},
      );
      final first = call('first', a.future);
      final second = call('second', b.future);
      b.complete();
      expect(await second, 'second');
      a.complete();
      expect(await first, 'first');
    });

    test('binary zone callbacks batch and restore after throwing', () async {
      final context = ReactiveContext();
      final action = AsyncAction('binary zone', context: context);
      final error = StateError('callback');
      await action.run(() async {
        await tick();
        expect(
          () => Zone.current.runBinary(
            (Object e, StackTrace s) {
              expect(context.isWithinBatch, isTrue);
              throw e;
            },
            error,
            StackTrace.current,
          ),
          throwsA(same(error)),
        );
      });
      expect(context.isWithinBatch, isFalse);
    });

    test(
      'future rejection and derived completion use their supplied context',
      () async {
        final context = ReactiveContext();
        final completer = Completer<int>();
        final source = ObservableFuture(completer.future, context: context);
        final derived = source.catchError((Object _) => 7).then((v) => v * 2);
        final statuses = <FutureStatus>[];
        final results = <Object?>[];
        addTearDown(
          autorun((_) {
            statuses.add(source.status);
            results.add(source.result);
          }, context: context).call,
        );
        final derivedValues = <int?>[];
        addTearDown(
          autorun(
            (_) => derivedValues.add(derived.value),
            context: context,
          ).call,
        );
        final error = StateError('source');
        completer.completeError(error);
        expect(await derived, 14);
        await tick();
        expect(statuses, [FutureStatus.pending, FutureStatus.rejected]);
        expect(results, [null, same(error)]);
        expect(derivedValues, [null, 14]);
      },
    );

    test(
      'an empty completed stream does not invoke active or error fallbacks',
      () async {
        final stream = ObservableStream<int>(const Stream<int>.empty());
        final done = Completer<void>();
        stream.listen(null, onDone: done.complete);
        await done.future;
        expect(
          stream.match(
            active: (_) => fail('no value'),
            error: (_) => fail('no error'),
          ),
          isNull,
        );
        await stream.close();
      },
    );

    test('a real null event is distinct from an empty stream', () async {
      final stream = ObservableStream<int?>(Stream.value(null));
      await stream.toList();
      var called = false;
      expect(
        stream.match(
          active: (value) {
            called = true;
            return value;
          },
        ),
        isNull,
      );
      expect(called, isTrue);
      await stream.close();
    });

    test('cancelOnError broadcasts error and done exactly once', () async {
      final source = StreamController<int>.broadcast();
      final stream = ObservableStream(source.stream, cancelOnError: true);
      final error = StateError('source');
      final stack = StackTrace.fromString('explicit-stack');
      final results = <String>[];
      final done = Completer<void>();
      var finished = 0;
      for (var i = 0; i < 2; i++) {
        stream.listen(
          (_) => fail('event after terminal error'),
          onError: (Object e, StackTrace s) {
            expect(e, same(error));
            expect(s.toString(), stack.toString());
            results.add('error');
          },
          onDone: () {
            results.add('done');
            if (++finished == 2) done.complete();
          },
        );
      }
      source.addError(error, stack);
      source.add(1);
      await done.future;
      expect(results.where((e) => e == 'error'), hasLength(2));
      expect(results.where((e) => e == 'done'), hasLength(2));
      expect(stream.status, StreamStatus.done);
      expect(stream.error, same(error));
      await source.close();
      await stream.close();
    });

    test('completed broadcast properties can be observed again', () async {
      final source = StreamController<int>.broadcast();
      final stream = ObservableStream(source.stream, cancelOnError: true);
      final first = autorun((_) {
        stream.status;
      });
      source.addError(StateError('stop'));
      await tick();
      first();
      final statuses = <StreamStatus>[];
      final second = autorun((_) => statuses.add(stream.status));
      expect(statuses, [StreamStatus.done]);
      second();
      await source.close();
      await stream.close();
    });
  });

  group('reaction timer ownership', () {
    test('disposing a scheduled reaction directly cancels pending work', () {
      fakeAsync((async) {
        final value = Observable(0);
        var effects = 0;
        final dispose = reaction(
          (_) => value.value,
          (_) => effects++,
          delay: 1000,
        );
        runInAction(() => value.value = 1);
        expect(async.pendingTimers, hasLength(1));
        dispose.reaction.dispose();
        expect(async.pendingTimers, isEmpty);
        async.elapse(const Duration(seconds: 2));
        expect(effects, 0);
      });
    });

    test(
      'disposing when cancels its timeout and cannot report a later error',
      () {
        fakeAsync((async) {
          final dispose = when(
            (_) => false,
            () => fail('effect'),
            timeout: 1000,
            onError: (_, _) => fail('timeout after disposal'),
          );
          expect(async.pendingTimers, hasLength(1));
          dispose.reaction.dispose();
          expect(async.pendingTimers, isEmpty);
          async.elapse(const Duration(seconds: 2));
        });
      },
    );

    test(
      'a synchronous scheduler cannot retain a timer after self-disposal',
      () {
        fakeAsync((async) {
          final dispose = autorun(
            (reaction) => reaction.dispose(),
            scheduler: (run) {
              run();
              return Timer(const Duration(hours: 1), () {});
            },
          );
          expect(dispose.reaction.isDisposed, isTrue);
          expect(async.pendingTimers, isEmpty);
        });
      },
    );
  });

  group('collection view and range contracts', () {
    test(
      'casts created before listeners share mutations in both directions',
      () {
        final root = ObservableList<num>.of([1]);
        final view = root.cast<int>() as ObservableList<int>;
        final nested = view.cast<num>() as ObservableList<num>;
        final rootEvents = <ListChange<num>>[];
        final viewEvents = <ListChange<int>>[];
        final nestedEvents = <ListChange<num>>[];
        addTearDown(root.observe(rootEvents.add));
        final stopView = view.observe(viewEvents.add);
        addTearDown(stopView);
        addTearDown(nested.observe(nestedEvents.add));
        view.add(2);
        root.addAll([3]);
        expect(rootEvents, hasLength(2));
        expect(viewEvents, hasLength(2));
        expect(nestedEvents, hasLength(2));
        expect(rootEvents.first.list, same(root));
        expect(viewEvents.first.list, same(view));
        expect(nestedEvents.first.list, same(nested));
        expect(viewEvents.first.elementChanges!.single.newValue, 2);
        expect(viewEvents.last.rangeChanges!.single.newValues, [3]);
        stopView();
        nested.removeLast();
        expect(viewEvents, hasLength(2));
        expect(rootEvents, hasLength(3));
        expect(nestedEvents, hasLength(3));
      },
    );

    test('a narrow view checks event values lazily', () {
      final root = ObservableList<num>.of([1]);
      final view = root.cast<int>() as ObservableList<int>;
      late ListChange<int> event;
      addTearDown(view.observe((change) => event = change));
      root.add(2.5);
      expect(event.elementChanges!.single.index, 1);
      expect(
        () => event.elementChanges!.single.newValue,
        throwsA(isA<TypeError>()),
      );
      root.addAll([3.5]);
      expect(event.rangeChanges!.single.index, 2);
      expect(
        () => event.rangeChanges!.single.newValues!.single,
        throwsA(isA<TypeError>()),
      );
    });

    test('invalid empty and reversed ranges throw without notifications', () {
      final list = ObservableList.of([1]);
      var changes = 0;
      addTearDown(list.observe((_) => changes++));
      for (final range in [(-1, -1), (5, 5), (1, 0), (0, 2)]) {
        expect(() => list.removeRange(range.$1, range.$2), throwsRangeError);
        expect(() => list.fillRange(range.$1, range.$2, 2), throwsRangeError);
        expect(() => list.setRange(range.$1, range.$2, []), throwsRangeError);
        expect(
          () => list.replaceRange(range.$1, range.$2, []),
          throwsRangeError,
        );
      }
      expect(() => list.setAll(-1, []), throwsRangeError);
      expect(() => list.setAll(2, []), throwsRangeError);
      list.removeRange(1, 1);
      list.fillRange(1, 1, 2);
      list.setRange(1, 1, []);
      list.replaceRange(1, 1, []);
      list.setAll(1, []);
      expect(list, [1]);
      expect(changes, 0);
    });
  });
}
