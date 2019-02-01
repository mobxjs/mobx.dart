import 'dart:async';

import 'package:mobx/src/api/observable_future.dart';
import 'package:test/test.dart';

void main() {
  group('ObservableFuture', () {
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
      }
      // ignore:avoid_catches_without_on_clauses
      catch (error) {
        expect(error, equals('ERROR'));
      }
      expect(future.status, equals(FutureStatus.rejected));
      expect(future.value, isNull);
      expect(future.error, equals('ERROR'));
    });
  });
}
