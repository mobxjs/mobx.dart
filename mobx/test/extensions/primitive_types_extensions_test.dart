import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

import '../util.dart';

void main() {
  testSetup();

  group('PrimitiveTypesExtensions', () {
    test('Transform Int into ObsInt', () {
      final count = 0;
      expect(count.obs(), isA<Observable<int>>());
    });

    test('Transform Double into ObsDouble', () {
      final count = 0.0;
      expect(count.obs(), isA<Observable<double>>());
    });

    test('Transform Bool into ObsBool', () {
      final flag = false;
      expect(flag.obs(), isA<Observable<bool>>());
    });

    test('Transform String into ObsString', () {
      final str = '';
      expect(str.obs(), isA<Observable<String>>());
    });

    test('Toggles ObservableBool', () {
      final flag = false.obs();
      flag.toggle();
      expect(flag.value, equals(true));
    });
  });
}
