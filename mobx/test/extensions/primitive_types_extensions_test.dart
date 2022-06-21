import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

import '../util.dart';

void main() {
  testSetup();

  group('PrimitiveTypesExtensions', () {
    test('Transform Int into ObsInt', () {
      final count = 0;
      expect(count.obs(), isA<ObsInt>());
    });

    test('Transform Double into ObsDouble', () {
      final count = 0.0;
      expect(count.obs(), isA<ObsDouble>());
    });

    test('Transform Bool into ObsBool', () {
      final flag = false;
      expect(flag.obs(), isA<ObsBool>());
    });

    test('Transform String into ObsString', () {
      final str = '';
      expect(str.obs(), isA<ObsString>());
    });

    test('Toggles ObservableBool', () {
      final flag = false.obs();
      flag.toggle();
      expect(flag.value, equals(true));
    });

  });

  group('Typedefs', () {
    test('ObsInt is Observable<int>', () {      
      expect(ObsInt, isA<Observable<int>>());
    });

    test('ObsBool is Observable<bool>', () {      
      expect(ObsBool, isA<Observable<bool>>());
    });

    test('ObsDouble is Observable<double>', () {      
      expect(ObsDouble, isA<Observable<double>>());
    });

    test('ObsString is Observable<String>', () {      
      expect(ObsString, isA<Observable<String>>());
    });

  });
}
