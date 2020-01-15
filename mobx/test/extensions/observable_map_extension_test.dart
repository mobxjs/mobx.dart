import 'package:mobx/src/api/extensions.dart';
import 'package:mobx/src/api/observable_collections.dart';
import 'package:test/test.dart';

import '../util.dart';

void main() {
  group('ObservableMapExtension', () {
    turnOffWritePolicy();

    test('Transform Map in ObservableMap', () async {
      final map = {};
      expect(map.asObservable(), isA<ObservableMap>());
    });
  });
}
