import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

void main() {
  group('DerivationTracker', () {
    test('reacts to changes to reactive values between begin and end', () {
      var i = 0;

      final tracker = DerivationTracker(mainContext, () {
        i++;
      });

      final var1 = observable(0);
      final var2 = observable(0);

      tracker.start();
      final var3 = observable(0);
      var1.value;
      tracker.end();

      // No changes, no calls to onInvalidate
      expect(i, equals(0));

      // Change outside tracking, no onInvalidate call
      var2.value += 1;
      expect(i, equals(0));

      // Change outside tracking to an observable created inside tracking
      // no onInvalidate call
      var3.value += 1;
      expect(i, equals(0));

      // Changing a value that was read when tracking was active
      // calls onInvalidate
      var1.value += 1;
      expect(i, equals(1));

      // No calls to onInvalidate after first change
      var1.value += 1;
      expect(i, equals(1));
    });

    test('can be used multiple times', () {
      var i = 0;
      final tracker = DerivationTracker(mainContext, () {
        i++;
      });
      final var1 = observable(0);

      tracker.start();
      var1.value;
      tracker.end();

      expect(i, equals(0));

      var1.value += 1;
      expect(i, equals(1));

      tracker.start();
      var1.value;
      tracker.end();

      var1.value += 1;
      expect(i, equals(2));

      final var2 = observable(0);
      tracker.start();
      var2.value;
      tracker.end();

      var2.value += 1;
      expect(i, equals(3));
    });

    test("when disposed, doesn't call onInvalidate", () {
      var i = 0;
      final tracker = DerivationTracker(mainContext, () {
        i++;
      });
      final var1 = observable(0);

      tracker.start();
      var1.value;
      tracker
        ..end()
        ..dispose();

      var1.value += 1;
      expect(i, equals(0));
    });

    test('calling start multiple times before calling end does nothing', () {
      var i = 0;
      final tracker = DerivationTracker(mainContext, () {
        i++;
      });
      final var1 = observable(0);

      tracker..start()..start()..start();

      var1.value;

      tracker
        ..start()
        ..end();

      expect(i, equals(0));

      var1.value += 1;
      expect(i, equals(1));
    });

    test('calling end multiple times after start does nothing', () {
      var i = 0;
      final tracker = DerivationTracker(mainContext, () {
        i++;
      });
      final var1 = observable(0);

      tracker.start();
      var1.value;
      tracker..end()..end()..end();

      expect(i, equals(0));

      var1.value += 1;
      expect(i, equals(1));
    });

    test('calling dispose multiple times does nothing', () {
      var i = 0;
      final tracker = DerivationTracker(mainContext, () {
        i++;
      });
      final var1 = observable(0);

      tracker.start();
      var1.value;
      tracker..dispose()..dispose()..dispose();

      expect(i, equals(0));

      var1.value += 1;
      expect(i, equals(0));
    });

    test('autorun works inside tracking', () {
      var i = 0;
      var autoVar = 0;
      final tracker = DerivationTracker(mainContext, () {
        i++;
      });
      final var1 = observable(0);

      tracker.start();
      var1.value;
      autorun((_) {
        autoVar += var1.value;
      });
      tracker.end();

      var1.value = 1;

      expect(i, equals(1));
      expect(autoVar, equals(1));
    });
  });
}
