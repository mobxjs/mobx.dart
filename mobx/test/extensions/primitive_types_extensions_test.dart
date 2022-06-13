import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

import '../util.dart';

void main() {
  testSetup();

  group('PrimitiveTypesExtensions', () {
    test('Transform Int into ObservableInt', () {
      final count = 0;
      expect(count.obs(), isA<ObservableInt>());
    });

    test('Transform Double into ObservableDouble', () {
      final count = 0.0;
      expect(count.obs(), isA<ObservableDouble>());
    });

    test('Transform Bool into ObservableBool', () {
      final flag = false;
      expect(flag.obs(), isA<ObservableBool>());
    });

    test('Transform String into ObservableString', () {
      final str = '';
      expect(str.obs(), isA<ObservableString>());
    });

    test('Toggles ObservableBool', () {
      final flag = false.obs();
      flag.toggle();
      expect(flag.value, equals(true));
    });

  });
}
