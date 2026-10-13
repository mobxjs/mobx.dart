// Audit regressions: intentionally assert desired behavior, outside test/.
import 'dart:async';
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
}
