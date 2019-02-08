import 'dart:async';

import 'package:mobx/src/api/async.dart';
import 'package:mobx/src/api/reaction.dart';
import 'package:test/test.dart';

void main() {
  group('ObservableStream', () {
    test('match works', () async {
      // ignore:close_sinks
      final ctrl = StreamController<int>.broadcast();
      final stream = ObservableStream(ctrl.stream);

      final values = <String>[];
      autorun((_) {
        values.add(stream.match(
          waiting: () => 'waiting',
          active: (i) => 'value',
          done: (_, __) => 'done',
          error: (err) => 'error',
        ));
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
        values.add(stream.match(
            waiting: () => 'waiting', active: (i) => 'value/done'));
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
        values.add(stream.match(
          waiting: () => 'waiting',
          error: (i) => 'error/done',
        ));
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
        values.add(stream.value);
      });

      await asyncWhen((_) => stream.status == StreamStatus.done);

      expect(values, equals(['0', '2', '3']));
    });

    test('pauses and unpauses when starting/stopping observation', () async {
      // ignore:close_sinks
      final ctrl = StreamController<int>();
      final stream = ObservableStream(ctrl.stream, initialValue: 0);

      final future = asyncWhen(
          (_) => stream.status == StreamStatus.done || stream.value == 2);
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

    test('cancelOnError cancels the stream on first error', () async {
      final ctrl = StreamController<int>();
      final stream =
          ObservableStream(ctrl.stream, initialValue: 0, cancelOnError: true);

      final values = <int>[];
      autorun((_) {
        values.add(stream.data);
      });

      ctrl
        ..add(1)
        ..addError(2)
        ..add(3)
        ..add(4);

      await ctrl.close();

      expect(values, equals([0, 1, 2]));
    });

    <String, StreamTestBody>{
      'asBroadcastStream': (s) => s.asBroadcastStream(),
      'asyncExpand': (s) =>
          s.asyncExpand((n) => Stream.fromIterable(Iterable<int>.generate(n))),
      'asyncMap': (s) => s.asyncMap((n) => Future.value(n + 1)),
      'cast': (s) => s.cast<num>(),
      'distinct': (s) => s.distinct(),
      'expand': (s) => s.expand((n) => Iterable<int>.generate(n)),
      'skip': (s) => s.skip(2),
      'skipWhile': (s) => s.skipWhile((n) => n > 3),
      'take': (s) => s.take(5),
      'takeWhile': (s) => s.takeWhile((n) => n < 4),
      'where': (s) => s.where((n) => n != 2)
    }.forEach(testStreamCombinator);
  });

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
        (s) => s.pipe(StreamController.broadcast()), null as dynamic),
    'reduce': futureCase((s) => s.reduce((a, b) => a + b), 45),
    'single': futureCase((s) => s.single, 0, length: 1),
    'singleWhere': futureCase((s) => s.singleWhere((n) => n == 8), 8),
    'toList': futureCase((s) => s.toList(), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
    'toSet':
        futureCase((s) => s.toSet(), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].toSet()),
  }.forEach(testStreamToFutureCombinator);
}

Case<F> futureCase<
        R,
        F extends ObservableFuture<R> Function(
            ObservableStream<int>)>(F body, R result, {int length = 10}) =>
    Case(body, result, length);

class Case<F extends Function> {
  Case(this.body, this.result, this.length);

  final int length;
  final F body;
  final dynamic result;
}

typedef FutureTestBody = ObservableFuture Function(ObservableStream<int>);

typedef StreamTestBody = ObservableStream Function(ObservableStream<int>);

void testStreamCombinator<T>(String description, StreamTestBody body) {
  test(description, () async {
    final stream =
        ObservableStream(Stream.fromIterable(Iterable<int>.generate(10)));
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
        Stream.fromIterable(Iterable<int>.generate(testCase.length)));
    final ObservableFuture future = testCase.body(stream);
    expect(future.value, isNull);

    autorun((_) => future.value);

    await future;
    expect(future.value, equals(testCase.result));
  });
}
