import 'package:mobx/src/api/reaction.dart';
import 'package:mobx/src/core/observable.dart';
import "package:test/test.dart";

void main() {
  test('Reaction', () {
    var c = ObservableValue.of('counter', 0);
    int nextValue;

    var dispose = autorun(() {
      nextValue = c.value + 1;
    });

    expect(nextValue, equals(1));

    c.value = 10;
    expect(nextValue, equals(11));

    dispose();
  });

  test('Reaction with 2 observables', () {
    var x = ObservableValue.of('greeting', 'Hello');
    var y = ObservableValue.of('name', 'Pavan');
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

  test('Reaction with changing observables', () {
    var x = ObservableValue.of('x', 10);
    var y = ObservableValue.of('y', 20);
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
