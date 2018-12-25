import 'package:mobx/src/api/observable.dart';
import 'package:mobx/src/api/reaction.dart';
import "package:test/test.dart";

void main() {
  test('autorun', () {
    var c = observable(0);
    int nextValue;

    var dispose = autorun(() {
      nextValue = c.value + 1;
    });

    expect(nextValue, equals(1));

    c.value = 10;
    expect(nextValue, equals(11));

    dispose(); // reaction should not run after this, even as dependent observables change

    c.value = 100;
    expect(nextValue, isNot(equals(101))); // Should not change
    expect(nextValue, equals(11)); // Remains the same as last value
  });

  test('autorun with 2 observables', () {
    var x = observable('Hello');
    var y = observable('Pavan');
    String message;

    var dispose = autorun(() {
      message = "${x.value} ${y.value}";
    });

    expect(message, equals("Hello Pavan"));

    x.value = "Hey";
    expect(message, equals("Hey Pavan"));
    y.value = "MobX";
    expect(message, equals("Hey MobX"));

    dispose();
  });

  test('autorun with changing observables', () {
    var x = observable(10);
    var y = observable(20);
    int value;

    var dispose = autorun(() {
      value = (value == null) ? x.value : y.value;
    });

    expect(value, equals(10));
    x.value = 30;

    expect(value, equals(20)); // Should use y now

    dispose();
  });
}
