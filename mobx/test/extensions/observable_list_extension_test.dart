import 'package:mobx/src/api/extensions.dart';
import 'package:mobx/src/api/observable_collections.dart';
import 'package:test/test.dart';

import '../util.dart';

void main() {
  turnOffWritePolicy();

  group('ObservableListExtension', () {
    test('Transform List in ObservableList', () async {
      final list = [];
      expect(list.asObservable(), isA<ObservableList>());
    });
  });
}
