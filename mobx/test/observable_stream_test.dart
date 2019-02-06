import 'dart:async';

import 'package:mobx/src/api/observable_stream.dart';
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

    <String, ObservableStream Function(ObservableStream<int>)>{
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
}

void testStreamCombinator<T>(
    String description, ObservableStream Function(ObservableStream<int>) body) {
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
