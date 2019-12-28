import 'package:mobx/src/api/extensions.dart';
import 'package:mobx/src/api/observable_collections.dart';
import 'package:test/test.dart';

void main() {
  group('ObservableListExtension', () {
    test('Transform List in ObservableList', () async {
      final list = [];
      expect(list.asObservable(), isA<ObservableList>());
    });
  });
}
