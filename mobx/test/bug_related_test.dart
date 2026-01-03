import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  testSetup();

  test(
    'reaction should work with a map operation on list. Github Issue #211',
    () {
      final list = ObservableList<int>()..add(1);

      var count = 0;
      final d = reaction(
        (_) {
          final tmp = list.map((item) => item).toList(growable: false);
          return tmp[0];
        },
        (msg) {
          count++;
        },
      );

      list[0] = 2;
      d();

      expect(count, equals(1));
    },
  );

  test('Should expose the library\'s version. Github Issue #213', () {
    expect(version, isNotNull);
  });
}
