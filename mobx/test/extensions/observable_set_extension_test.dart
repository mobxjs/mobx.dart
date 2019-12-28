import 'package:mobx/src/api/extensions.dart';
import 'package:mobx/src/api/observable_collections.dart';
import 'package:test/test.dart';

void main() {
  group('ObservableSetExtension', () {
    test('Transform Set in ObservableSet', () async {
      final set = <dynamic>{};
      expect(set.asObservable(), isA<ObservableSet>());
    });
  });
}
