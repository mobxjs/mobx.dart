import 'dart:async';

import 'package:mobx/src/api/async.dart';
import 'package:mobx/src/api/extensions.dart';
import 'package:test/test.dart';

import '../util.dart';

void main() {
  testSetup();

  group('ObservableFutureExtension', () {
    test('Transform Future in ObservableFuture', () async {
      final future = Future.value(1);
      expect(future.asObservable(), isA<ObservableFuture>());
    });

    test('Transform Future in ObservableFuture (Use .asObs)', () async {
      final future = Future.value(1);
      expect(future.asObs, isA<ObservableFuture>());
    });
  });
}
