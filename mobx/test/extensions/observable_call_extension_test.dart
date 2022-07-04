import 'package:mobx/src/api/action.dart';
import 'package:mobx/src/api/extensions.dart';
import 'package:mobx/src/api/reaction.dart';
import 'package:test/test.dart';

import '../util.dart';

void main() {
  testSetup();

  group('ObservableCallExtensions', () {
    test('Use call on Observable', () {
      final x = 10.asObs;
      final y = 20.asObs;

      var executionCount = 0;
      var total = 0;

      final d = autorun((_) {
        total = x() + y();
        executionCount++;
      });

      runInAction(() {
        x(100);
        y(200);

        expect(executionCount, equals(1)); // No notifications are fired
      });

      // Notifications are fired now
      expect(executionCount, equals(2));
      expect(total, equals(300));

      d();
    });
  });
}
