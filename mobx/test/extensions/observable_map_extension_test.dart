import 'package:mobx/src/api/extensions.dart';
import 'package:mobx/src/api/observable_collections.dart';
import 'package:test/test.dart';

import '../util.dart';

void main() {
  testSetup();

  group('ObservableMapExtension', () {
    test('Transform Map in ObservableMap', () async {
      final map = {};
      expect(map.asObservable(), isA<ObservableMap>());
    });

    test('Transform Map in ObservableMap (Use .asObs)', () async {
      final map = {};
      expect(map.asObs, isA<ObservableMap>());
    });
  });
}
