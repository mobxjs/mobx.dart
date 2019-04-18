import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

void main() {
  group('ObservableFuture', () {
    test('value constructor creates an immediately fulfilled future', () {
      final future = ObservableFuture.value('success');
      expect(future.value, equals('success'));
    });

    test('status should be pending while running and fulfilled when completed',
        () async {
      final completer = Completer<String>();
      final future = ObservableFuture(completer.future);
      expect(future.status, equals(FutureStatus.pending));
      expect(future.value, isNull);
      expect(future.error, isNull);
      completer.complete('FULFILLED');
      await future;
      expect(future.status, equals(FutureStatus.fulfilled));
      expect(future.value, equals('FULFILLED'));
      expect(future.error, isNull);
    });

    test('status should be pending while running and rejected when failed',
        () async {
      final completer = Completer();
      final future = ObservableFuture(completer.future);
      expect(future.status, equals(FutureStatus.pending));
      expect(future.value, isNull);
      expect(future.error, isNull);
      completer.completeError('ERROR');
      try {
        await future;
        // ignore:avoid_catches_without_on_clauses
      } catch (error) {
        expect(error, equals('ERROR'));
      }
      expect(future.status, equals(FutureStatus.rejected));
      expect(future.value, isNull);
      expect(future.error, equals('ERROR'));
    });

    test('replace should update value and status after new promise completes',
        () async {
      var future = ObservableFuture<String>.error('ERROR');
      expect(future.status, FutureStatus.rejected);
      expect(future.result, equals('ERROR'));

      final completer = Completer<String>();

      future = future.replace(completer.future);
      expect(future.status, FutureStatus.rejected);
      expect(future.result, equals('ERROR'));

      completer.complete('success');
      await future;

      expect(future.status, equals(FutureStatus.fulfilled));
      expect(future.value, equals('success'));
    });

    test('match works for future completing with a value', () async {
      final future = ObservableFuture<int>(Future(() => 0));

      String getResult() => future.match(
            fulfilled: (i) => 'fulfilled',
            pending: () => 'pending',
            rejected: (error) => 'rejected',
          );

      expect(getResult(), equals('pending'));
      expect(future.status, equals(FutureStatus.pending));

      await future;

      expect(getResult(), equals('fulfilled'));
      expect(future.status, equals(FutureStatus.fulfilled));
    });

    test('match works for future completing with an error', () async {
      final completer = Completer<int>();
      final future = ObservableFuture<int>(completer.future);

      String getResult() => future.match(
            fulfilled: (i) => 'fulfilled',
            pending: () => 'pending',
            rejected: (error) => 'rejected',
          );

      expect(getResult(), equals('pending'));
      expect(future.status, equals(FutureStatus.pending));

      completer.completeError('ERROR');
      try {
        await future;
        // ignore:avoid_catches_without_on_clauses
      } catch (_) {}

      expect(getResult(), equals('rejected'));
      expect(future.status, equals(FutureStatus.rejected));
    });

    test(
        'match return null if state is pending and no pending matcher is provided',
        () async {
      final future = ObservableFuture<int>(Future(() => 0));

      String getResult() => future.match(
            fulfilled: (i) => 'fulfilled',
            rejected: (error) => 'rejected',
          );

      expect(getResult(), equals(null));

      await future;
      expect(getResult(), equals('fulfilled'));
    });

    test(
        'match return null if state is fulfilled and no fulfilled matcher is provided',
        () async {
      final future = ObservableFuture<int>(Future(() => 0));

      String getResult() => future.match(
            pending: () => 'pending',
            rejected: (error) => 'rejected',
          );

      expect(getResult(), equals('pending'));

      await future;
      expect(getResult(), equals(null));
    });

    test(
        'match return null if state is rejected and no rejected matcher is provided',
        () async {
      final completer = Completer<int>();
      final future = ObservableFuture<int>(completer.future);

      String getResult() => future.match(
            pending: () => 'pending',
            fulfilled: (i) => 'fulfilled',
          );

      expect(getResult(), equals('pending'));

      completer.completeError('ERROR');
      try {
        await future;
        // ignore:avoid_catches_without_on_clauses
      } catch (_) {}
      expect(getResult(), equals(null));
    });

    test('stream should work', () async {
      final future = ObservableFuture(Future(() => 1));

      final value = await future.asStream().first;
      expect(value, equals(1));
    });

    test('observing stream should work', () async {
      final future = ObservableFuture(Future(() => 1));
      final stream = future.asStream();

      await asyncWhen((_) => stream.value == 1);
      expect(stream.value, equals(1));
      expect(future.value, equals(1));
    });

    test('then works', () async {
      final future = ObservableFuture(Future(() => 1)).then((i) => i + 1);

      expect(await future, equals(2));
    });

    test('catchError works', () async {
      final future = ObservableFuture(Future(() {
        // ignore:only_throw_errors
        throw 'Error';
      })).catchError((error) => 1);

      expect(await future, equals(1));
    });

    test('timeout works', () async {
      final completer = Completer<int>();
      final future =
          ObservableFuture(completer.future).timeout(Duration(milliseconds: 1));

      expect(() async => await future,
          throwsA(const TypeMatcher<TimeoutException>()));
    });

    test('whenComplete works', () async {
      var called = false;
      await ObservableFuture(Future(() => 1)).whenComplete(() => called = true);

      expect(called, isTrue);
    });
  });
}
