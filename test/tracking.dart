import 'package:mobx/mobx.dart';
import 'package:mobx/src/api/context.dart';
import 'package:mobx/src/core/tracking.dart';
import 'package:test/test.dart';

void main() {
  test('Tracking reacts to changes to reactive values between begin and end',
      () {
    final var1 = observable(0);
    final var2 = observable(0);
    var i = 0;

    final tracking = Tracking.begin(currentContext, () {
      i++;
    });
    final var3 = observable(0);
    var1.value;
    tracking.end();

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

  test("disposed Tracking doesn't call onInvalidate", () {
    final var1 = observable(0);

    var i = 0;
    final tracking = Tracking.begin(currentContext, () {
      i++;
    });
    var1.value;
    tracking
      ..end()
      ..dispose();

    var1.value += 1;
    expect(i, equals(0));
  });
}
