import 'dart:async';

import 'package:mobx/src/api/async.dart';
import 'package:mobx/src/api/extensions.dart';
import 'package:test/test.dart';

void main() {
  group('ObservableFutureExtension', () {
    test('Transform Future in ObservableFuture', () async {
      final future = Future.value(1);
      expect(future.asObservable(), isA<ObservableFuture>());
    });
  });
}
