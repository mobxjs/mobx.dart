import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  testSetup();

  group('ObservableValue', () {
    test('basics work', () {
      final ObservableValue<int> x1 = Observable(1);
      final ObservableValue<int> x2 = Computed(() => x1.value * 2);
      final ObservableValue<int?> x3 = ObservableFuture.value(3);
      final ObservableValue<int?> x4 = ObservableStream(
        const Stream<int>.empty(),
        initialValue: 4,
      );

      expect(x1.value, equals(1));
      expect(x2.value, equals(2));
      expect(x3.value, equals(3));
      expect(x4.value, equals(4));
    });
  });
}
