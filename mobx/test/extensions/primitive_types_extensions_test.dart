import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

import '../util.dart';

void main() {
  testSetup();

  group('PrimitiveTypesExtensions', () {
    test('Transform Int into ObservableInt', () {
      final count = 0;
      expect(count.asObservable(), isA<ObservableInt>());
    });

    test('Transform Double into ObservableDouble', () {
      final count = 0.0;
      expect(count.asObservable(), isA<ObservableDouble>());
    });

    test('Transform Bool into ObservableBool', () {
      final flag = false;
      expect(flag.asObservable(), isA<ObservableBool>());
    });

    test('Transform String into ObservableString', () {
      final str = '';
      expect(str.asObservable(), isA<ObservableString>());
    });

    test('Toggles ObservableBool', () {
      final flag = false.asObservable();
      flag.toggle();
      expect(flag.value, equals(true));
    });
  });
}
