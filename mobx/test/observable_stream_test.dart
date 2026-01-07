import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  testSetup();

  group('ObservableStream', () {
    test('generates a name if not given', () {
      final ctrl = StreamController<int>.broadcast();
      final stream = ObservableStream(ctrl.stream);

      expect(stream.name, matches(RegExp(r'ObservableStream<.*>@')));

      ctrl.close();
    });

    test('uses the name if given', () {
      final ctrl = StreamController<int>.broadcast();
      final stream = ObservableStream(ctrl.stream, name: 'test');

      expect(stream.name, equals('test'));

      ctrl.close();
    });

    test('listening to a stream gives back a subscription', () async {
      final ctrl = StreamController<int>.broadcast();
      final stream = ObservableStream(ctrl.stream);

      var arrived = false;
      final sub = stream.listen((data) {
        arrived = data == 100;
      });

      ctrl.add(100);

      await ctrl.close();

      expect(arrived, isTrue);

      await ctrl.close();
      await sub.cancel();
    });

    test('match works', () async {
      // ignore:close_sinks
      final ctrl = StreamController<int>.broadcast();
      // ignore: omit_local_variable_types
      final ObservableStream<int> stream = ObservableStream(ctrl.stream);

      final values = <String>[];
      autorun((_) {
        values.add(
          stream.match(
            waiting: () => 'waiting',
            active: (i) => 'value',
            done: (_, __) => 'done',
            error: (err) => 'error',
          )!,
        );
      });

      ctrl
        ..add(1)
        ..addError('ERROR');

      await ctrl.close();
      expect(values, equals(['waiting', 'value', 'error', 'done']));
    });

    test('omitting done in match uses value instead for values', () async {
      // ignore:close_sinks
      final ctrl = StreamController<int>.broadcast();
      final stream = ObservableStream(ctrl.stream);

      final values = <String>[];

      autorun((_) {
        values.add(
          stream.match(waiting: () => 'waiting', active: (i) => 'value/done')!,
        );
      });

      ctrl.add(1);
      await ctrl.close();

      expect(values, equals(['waiting', 'value/done', 'value/done']));
    });

    test('omitting done in match uses error instead for errors', () async {
      // ignore:close_sinks
      final ctrl = StreamController<int>.broadcast();
      final stream = ObservableStream(ctrl.stream);

      final values = <String>[];

      autorun((_) {
        values.add(
          stream.match(waiting: () => 'waiting', error: (i) => 'error/done')!,
        );
      });

      ctrl.addError('ERROR');
      await ctrl.close();

      expect(values, equals(['waiting', 'error/done', 'error/done']));
    });

    test('providing no initialValue sets initial status to waiting', () async {
      final stream = ObservableStream(() async* {
        yield 1;
      }());

      expect(stream.status, equals(StreamStatus.waiting));
      expect(stream.value, equals(null));
    });

    test('providing initialValue sets initial status to value', () async {
      final stream = ObservableStream(() async* {
        yield 1;
      }(), initialValue: 0);

      expect(stream.status, equals(StreamStatus.active));
      expect(stream.value, equals(0));
    });

    test('transforming the stream works', () async {
      final stream = ObservableStream(() async* {
            yield 1;
            yield 2;
            yield 3;
          }())
          .where((i) => i > 1)
          .map((i) => i.toString())
          .configure(initialValue: '0');

      final values = <String>[];
      autorun((_) {
        values.add(stream.value!);
      });

      await asyncWhen((_) => stream.status == StreamStatus.done);

      expect(values, equals(['0', '2', '3']));
    });

    test('pauses and unpauses when starting/stopping observation', () async {
      // ignore:close_sinks
      final ctrl = StreamController<int>();
      final stream = ObservableStream(ctrl.stream, initialValue: 0);

      final future = asyncWhen(
        (_) => stream.status == StreamStatus.done || stream.value == 2,
      );
      expect(ctrl.isPaused, isFalse);

      ctrl.add(2);
      await future;
      expect(ctrl.isPaused, isTrue);

      final future2 = asyncWhen((_) => stream.value == 3);
      expect(ctrl.isPaused, isFalse);

      ctrl.add(3);
      await future2;
      expect(ctrl.isPaused, isTrue);
    });

    test('listen() subscription keeps observable values updated', () async {
      // ignore: close_sinks
      final ctrl = StreamController<int>();
      final stream = ObservableStream(ctrl.stream, initialValue: 0);

      ctrl.add(1);
      await pumpEventQueue();
      expect(ctrl.isPaused, isTrue);
      expect(stream.value, equals(0), reason: 'no subscription, not updated');

      final subscription = stream.listen(null);

      ctrl.add(2);
      await pumpEventQueue();
      expect(ctrl.isPaused, isFalse);
      expect(stream.value, equals(2), reason: 'with subscription, updated');

      ctrl.add(3);
      await pumpEventQueue();
      expect(ctrl.isPaused, isFalse);
      expect(stream.value, equals(3));

      subscription.pause();

      ctrl.add(4);
      await pumpEventQueue();
      expect(ctrl.isPaused, isTrue);
      expect(stream.value, equals(3), reason: 'respects subscription pause');

      subscription.resume();

      ctrl.add(5);
      await pumpEventQueue();
      expect(ctrl.isPaused, isFalse);
      expect(stream.value, equals(5), reason: 'respects subscription resume');

      await subscription.cancel();

      ctrl.add(6);
      await pumpEventQueue();
      expect(stream.value, equals(5), reason: 'no sub, no longer updated');
    });

    test('listen() receives all events if source is non-broadcast', () async {
      // ignore: close_sinks
      final ctrl = StreamController<int>();
      final stream = ObservableStream(ctrl.stream, initialValue: 0);

      ctrl.add(1);
      await pumpEventQueue();

      final subValues = <int>[];
      final subscription = stream.listen(subValues.add);

      ctrl.add(2);
      await pumpEventQueue();
      expect(
        subValues,
        equals([0, 1, 2]),
        reason: 'non-broadcast streams buffer events',
      );

      ctrl.add(3);
      await pumpEventQueue();

      subscription.pause();

      ctrl.add(4);
      await pumpEventQueue();
      expect(
        subValues,
        equals([0, 1, 2, 3]),
        reason: 'subscription itself is paused, does not receive events',
      );

      subscription.resume();

      ctrl.add(5);
      await pumpEventQueue();
      expect(
        subValues,
        equals([0, 1, 2, 3, 4, 5]),
        reason: 'receives all events emitted during pause',
      );

      await subscription.cancel();

      ctrl.add(6);
      await pumpEventQueue();
      expect(
        subValues,
        equals([0, 1, 2, 3, 4, 5]),
        reason: 'sub cancelled, no longer receives events',
      );
    });

    test('listen() and observation both keep values updated', () async {
      // ignore: close_sinks
      final ctrl = StreamController<int>();
      final stream = ObservableStream(ctrl.stream, initialValue: 0);

      ctrl.add(1);
      await pumpEventQueue();
      expect(ctrl.isPaused, isTrue);
      expect(stream.value, equals(0));

      final reactionValues = <int>[];
      final dispose = autorun((_) {
        reactionValues.add(stream.value!);
      });

      ctrl.add(2);
      await pumpEventQueue();
      expect(ctrl.isPaused, isFalse);
      expect(stream.value, equals(2));

      final subValues = <int>[];
      final sub = stream.listen(subValues.add);

      ctrl.add(3);
      await pumpEventQueue();
      expect(ctrl.isPaused, isFalse);
      expect(stream.value, equals(3));
      expect(reactionValues, equals([0, 1, 2, 3]));
      expect(
        subValues,
        equals([0, 1, 2, 3]),
        reason: 'non-broadcast streams buffer events',
      );

      dispose();

      ctrl.add(4);
      await pumpEventQueue();
      expect(ctrl.isPaused, isFalse);
      expect(stream.value, equals(4));
      expect(reactionValues, equals([0, 1, 2, 3]));
      expect(subValues, equals([0, 1, 2, 3, 4]));

      await sub.cancel();

      ctrl.add(5);
      await pumpEventQueue();
      expect(ctrl.hasListener, isFalse);
      expect(
        ctrl.isPaused,
        isFalse,
        reason:
            'per docs, when controller has no more listeners, '
            'it is no longer paused',
      );
      expect(stream.value, equals(4));
      expect(reactionValues, equals([0, 1, 2, 3]));
      expect(subValues, equals([0, 1, 2, 3, 4]));
    });

    test('listen() also keeps values updated for broadcast streams', () async {
      // ignore: close_sinks
      final ctrl = StreamController<int>.broadcast();
      final stream = ObservableStream(ctrl.stream, initialValue: 0);

      ctrl.add(1);
      await pumpEventQueue();
      expect(
        ctrl.isPaused,
        isFalse,
        reason: 'broadcast ctrl itself does not pause',
      );
      expect(stream.value, equals(0));

      final sub1Values = <int>[];
      final sub1 = stream.listen(sub1Values.add);

      ctrl.add(2);
      await pumpEventQueue();
      expect(stream.value, equals(2));
      expect(
        sub1Values,
        equals([2]),
        reason: 'broadcast streams do not buffer events',
      );

      final sub2Values = <int>[];
      final sub2 = stream.listen(sub2Values.add);

      ctrl.add(3);
      await pumpEventQueue();
      expect(stream.value, equals(3));
      expect(sub1Values, equals([2, 3]));
      expect(sub2Values, equals([3]));

      sub1.pause();

      ctrl.add(4);
      await pumpEventQueue();
      expect(stream.value, equals(4));
      expect(sub1Values, equals([2, 3]));
      expect(sub2Values, equals([3, 4]));

      sub2.pause();

      ctrl.add(5);
      await pumpEventQueue();
      expect(
        stream.value,
        equals(5),
        reason:
            'all subs are paused, but pause is on a subscription level, '
            'broadcast stream still emits',
      );
      expect(sub1Values, equals([2, 3]));
      expect(sub2Values, equals([3, 4]));

      sub1.resume();

      ctrl.add(6);
      await pumpEventQueue();
      expect(stream.value, equals(6));
      expect(sub1Values, equals([2, 3, 4, 5, 6]));
      expect(sub2Values, equals([3, 4]));

      sub2.resume();

      ctrl.add(7);
      await pumpEventQueue();
      expect(stream.value, equals(7));
      expect(sub1Values, equals([2, 3, 4, 5, 6, 7]));
      expect(sub2Values, equals([3, 4, 5, 6, 7]));

      await sub2.cancel();

      ctrl.add(8);
      await pumpEventQueue();
      expect(stream.value, equals(8));
      expect(sub1Values, equals([2, 3, 4, 5, 6, 7, 8]));
      expect(sub2Values, equals([3, 4, 5, 6, 7]));

      await sub1.cancel();

      ctrl.add(9);
      await pumpEventQueue();
      expect(stream.value, equals(8), reason: 'no subs, no longer updated');
      expect(sub1Values, equals([2, 3, 4, 5, 6, 7, 8]));
      expect(sub2Values, equals([3, 4, 5, 6, 7]));
    });

    test('listen() can be used multiple times for broadcast streams', () async {
      final ctrl = StreamController<int>.broadcast();
      final stream = ObservableStream(ctrl.stream, initialValue: 0);

      final sub1Values = <int>[];
      final sub1 = stream.listen(sub1Values.add);

      ctrl.add(1);
      await pumpEventQueue();
      expect(stream.value, equals(1));
      expect(sub1Values, equals([1]));

      await sub1.cancel();

      ctrl.add(2);
      await pumpEventQueue();
      expect(stream.value, equals(1), reason: 'no subs, no updates');
      expect(sub1Values, equals([1]));

      final sub2Values = <int>[];
      final sub2 = stream.listen(sub2Values.add);

      ctrl.add(3);
      await pumpEventQueue();
      expect(stream.value, equals(3), reason: 'with subs, with updates again');
      expect(sub1Values, equals([1]));
      expect(sub2Values, equals([3]));

      await sub2.cancel();

      ctrl.add(4);
      await pumpEventQueue();
      expect(stream.value, equals(3));
      expect(sub1Values, equals([1]));
      expect(sub2Values, equals([3]));

      await ctrl.close();
    });

    test('implicit subscriptions keep observable values updated', () async {
      // ignore: close_sinks
      final ctrl = StreamController<int>();
      final stream = ObservableStream(ctrl.stream, initialValue: 0);

      ctrl.add(1);
      await pumpEventQueue();
      expect(ctrl.isPaused, isTrue);
      expect(stream.value, equals(0));

      // firstWhere implicitly subscribes to stream, ends when value is 4
      // ignore: unawaited_futures
      stream.firstWhere((value) => value == 4);

      ctrl.add(2);
      await pumpEventQueue();
      expect(ctrl.isPaused, isFalse);
      expect(stream.value, equals(2));

      ctrl.add(3);
      await pumpEventQueue();
      expect(ctrl.isPaused, isFalse);
      expect(stream.value, equals(3));

      ctrl.add(4); // Implicit sub should stop here, with value at 4
      await pumpEventQueue();
      expect(ctrl.hasListener, isFalse);
      expect(
        ctrl.isPaused,
        isFalse,
        reason: 'no more listeners, no longer paused',
      );
      expect(stream.value, equals(4));

      ctrl.add(5);
      await pumpEventQueue();
      expect(ctrl.isPaused, isFalse);
      expect(stream.value, equals(4)); // not updated
    });

    test('cancelOnError cancels the stream on first error', () async {
      final ctrl = StreamController<int>();
      final stream = ObservableStream(
        ctrl.stream,
        initialValue: 0,
        cancelOnError: true,
      );

      final values = <int>[];
      autorun((_) {
        values.add(stream.data as int);
      });

      ctrl
        ..add(1)
        ..addError(2)
        ..add(3)
        ..add(4);

      await ctrl.close();

      expect(values, equals([0, 1, 2]));
      expect(stream.error, equals(2));
      expect(stream.hasError, isTrue);
    });

    test('cancelOnError in listen() cancels observation on error', () async {
      // ignore: close_sinks
      final ctrl = StreamController<int>();
      final stream = ObservableStream(
        ctrl.stream,
        initialValue: 0,
        cancelOnError: false, // cancelOnError here doesn't affect subscription
      );

      final sub = stream.listen(null, onError: (_) {}, cancelOnError: true);

      ctrl.add(1);
      await pumpEventQueue();
      expect(ctrl.isPaused, isFalse);
      expect(stream.value, equals(1));

      ctrl.addError(2);
      await pumpEventQueue();
      expect(ctrl.hasListener, isFalse);
      expect(
        ctrl.isPaused,
        isFalse,
        reason: 'no more listeners, no longer paused',
      );
      expect(stream.value, isNull);
      expect(stream.error, equals(2));

      ctrl.add(3);
      await pumpEventQueue();
      expect(stream.value, isNull);
      expect(stream.error, equals(2));

      await sub.cancel();
    });

    test(
      '.close() can be used to close stream correctly',
      () async {
        final ctrl = StreamController<int>();
        final stream = ObservableStream(ctrl.stream, initialValue: 0);

        final future = asyncWhen((_) => stream.value == 2);
        ctrl.add(2);
        await future; // reaction should be disposed, no longer observing value

        await stream.close();
        expect(ctrl.close(), completes);
      },
      timeout: const Timeout(Duration(seconds: 3)),
    );

    test(
      '.close() can close broadcast streams correctly',
      () async {
        final ctrl = StreamController<int>.broadcast();
        final stream = ObservableStream(ctrl.stream, initialValue: 0);

        final future = asyncWhen((_) => stream.value == 2);
        ctrl.add(2);
        await future; // reaction should be disposed, no longer observing value

        await stream.close();
        expect(ctrl.close(), completes);
      },
      timeout: const Timeout(Duration(seconds: 3)),
    );

    test('trying to listen or observe after close throws', () async {
      final ctrl = StreamController<int>();
      final stream = ObservableStream(ctrl.stream, initialValue: 0);

      final future = asyncWhen((_) => stream.value == 2);
      ctrl.add(2);
      await expectLater(future, completes);

      await stream.close();

      final future2 = asyncWhen((_) => stream.value == 3);
      ctrl.add(3);
      await expectLater(future2, throwsA(isA<MobXCaughtException>()));

      expect(() => stream.listen(null), throwsA(isStateError));

      await ctrl.close();
    });

    test(
      'closes correctly when all subscriptions are cancelled',
      () async {
        final ctrl = StreamController<int>();
        final stream = ObservableStream(ctrl.stream, initialValue: 0);

        final sub = stream.listen(null);
        await sub.cancel();

        expect(ctrl.close(), completes);
      },
      timeout: const Timeout(Duration(seconds: 3)),
    );

    test(
      'closes correctly even if broadcast stream',
      () async {
        final ctrl = StreamController<int>.broadcast();
        final stream = ObservableStream(ctrl.stream, initialValue: 0);

        final sub = stream.listen(null);
        await sub.cancel();

        final sub2 = stream.listen(null);
        await sub2.cancel();

        expect(ctrl.close(), completes);
      },
      timeout: const Timeout(Duration(seconds: 3)),
    );

    test('cannot observe non-broadcast stream once sub is cancelled', () async {
      // ignore: close_sinks
      final ctrl = StreamController<int>();
      final stream = ObservableStream(ctrl.stream, initialValue: 0);

      final future = asyncWhen((_) => stream.value == 2);

      final sub = stream.listen(null);

      ctrl.add(2);
      await expectLater(future, completes, reason: 'sub not yet cancelled');

      await sub.cancel();

      final future2 = asyncWhen((_) => stream.value == 3);
      expect(
        future2,
        throwsA(isA<MobXCaughtException>()),
        reason: 'sub on non-broadcast stream already cancelled',
      );
    });

    test('can observe value with custom equals', () async {
      final ctrl = StreamController<int>();
      final stream = ObservableStream(
        ctrl.stream,
        initialValue: 3,
        equals: (_, __) => false,
      );

      final subValues = <int>[];
      final sub = stream.listen(subValues.add);

      ctrl.add(3);
      ctrl.add(3);
      ctrl.add(3);
      await pumpEventQueue();
      expect(stream.value, equals(3), reason: 'with subs, with updates again');
      expect(subValues, equals([3, 3, 3, 3]));

      await sub.cancel();
    });

    <String, StreamTestBody>{
      'asBroadcastStream': (s) {
        final stream = s.asBroadcastStream();

        expect(stream.isBroadcast, isTrue);
        return stream;
      },
      'asyncExpand':
          (s) => s.asyncExpand(
            (n) => Stream.fromIterable(Iterable<int>.generate(n)),
          ),
      'asyncMap': (s) => s.asyncMap((n) => Future.value(n + 1)),
      'cast': (s) => s.cast<num>(),
      'distinct': (s) => s.distinct(),
      'expand': (s) => s.expand((n) => Iterable<int>.generate(n)),
      'skip': (s) => s.skip(2),
      'skipWhile': (s) => s.skipWhile((n) => n > 3),
      'take': (s) => s.take(5),
      'takeWhile': (s) => s.takeWhile((n) => n < 4),
      'handleError': (s) => s.handleError((_) {}),
      'timeout':
          (s) => s.timeout(const Duration(seconds: 0), onTimeout: (n) => true),
      'transform':
          (s) => s.transform(
            StreamTransformer.fromHandlers(
              handleData: (data, sink) {
                sink.add(data);
              },
            ),
          ),
      'where': (s) => s.where((n) => n != 2),
    }.forEach(testStreamCombinator);

    <String, Case>{
      'any': futureCase((s) => s.any((v) => v > 3), true),
      'contains': futureCase((s) => s.contains(3), true),
      'drain': futureCase((s) => s.drain<int>(3), 3),
      'elementAt': futureCase((s) => s.elementAt(2), 2),
      'every': futureCase((s) => s.every((n) => n < 100), true),
      'first': futureCase((s) => s.first, 0),
      'firstWhere': futureCase((s) => s.firstWhere((n) => n == 2), 2),
      'fold': futureCase((s) => s.fold<int>(0, (a, b) => a + b), 45),
      'forEach': futureCase((s) => s.forEach((n) {}), null as dynamic),
      'isEmpty': futureCase((s) => s.isEmpty, false),
      'join': futureCase((s) => s.join(' '), '0 1 2 3 4 5 6 7 8 9'),
      'last': futureCase((s) => s.last, 9),
      'lastWhere': futureCase((s) => s.lastWhere((n) => n <= 8), 8),
      'length': futureCase((s) => s.length, 10),
      'pipe': futureCase(
        (s) => s.pipe(StreamController.broadcast()),
        null as dynamic,
      ),
      'reduce': futureCase((s) => s.reduce((a, b) => a + b), 45),
      'single': futureCase((s) => s.single, 0, length: 1),
      'singleWhere': futureCase((s) => s.singleWhere((n) => n == 8), 8),
      'toList': futureCase((s) => s.toList(), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
      'toSet': futureCase((s) => s.toSet(), {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}),
    }.forEach(testStreamToFutureCombinator);
  });
}

Case<F, R> futureCase<
  R,
  F extends ObservableFuture<R> Function(ObservableStream<int>)
>(F body, R result, {int length = 10}) => Case(body, result, length);

class Case<F extends Function, R> {
  Case(this.body, this.result, this.length);

  final int length;
  final F body;
  final R result;
}

typedef FutureTestBody = ObservableFuture Function(ObservableStream<int>);

typedef StreamTestBody = ObservableStream Function(ObservableStream<int>);

void testStreamCombinator<T>(String description, StreamTestBody body) {
  test(description, () async {
    final stream = ObservableStream(
      Stream.fromIterable(Iterable<int>.generate(10)),
    );
    final transformed = body(stream);

    dynamic value;
    autorun((_) {
      value = transformed.value;
    });
    await asyncWhen((_) => transformed.status == StreamStatus.done);
    expect(value, isNotNull);
  });
}

void testStreamToFutureCombinator<T>(String description, Case testCase) {
  test(description, () async {
    final stream = ObservableStream(
      Stream.fromIterable(Iterable<int>.generate(testCase.length)),
    );
    final future = testCase.body(stream) as ObservableFuture;
    expect(future.value, isNull);

    autorun((_) => future.value);

    await future;
    expect(future.value, equals(testCase.result));
  });
}
