import 'package:mobx/src/core/computed.dart';
import 'package:mobx/src/core/observable.dart';
import 'package:mobx/src/core/reaction.dart';
import "package:test/test.dart";

void main() {
  test('can create', () {
    var x = ObservableValue<int>('counter');
    expect(x.value, equals(null));

    x.value = 100;
    expect(x.value, equals(100));
  });

  test('Computed value', () {
    var x = ObservableValue.of('x', 20);
    var y = ObservableValue.of('y', 10);
    var c = ComputedValue<int>('counter', () {
      return x.value + y.value;
    });

    x.value = 30;
    y.value = 20;
    expect(c.value, equals(50));
  });

  test('Reaction', () {
    var c = ObservableValue.of('counter', 0);
    int nextValue;

    var r = Reaction(() {
      nextValue = c.value + 1;
    });

    r.schedule();

    expect(nextValue, equals(1));

    c.value = 10;
    expect(nextValue, equals(11));

    r.dispose();
  });

  test('Reaction with 2 observables', () {
    var x = ObservableValue.of('greeting', 'Hello');
    var y = ObservableValue.of('name', 'Pavan');
    String message;

    var reaction = Reaction(() {
      message = "${x.value} ${y.value}";
    });

    reaction.schedule();

    expect(message, equals("Hello Pavan"));

    x.value = "Hey";
    expect(message, equals("Hey Pavan"));
    y.value = "MobX";
    expect(message, equals("Hey MobX"));

    reaction.dispose();
  });

  test('Reaction with changing observables', () {
    var x = ObservableValue.of('x', 10);
    var y = ObservableValue.of('y', 20);
    int value;

    var reaction = Reaction(() {
      value = (value == null) ? x.value : y.value;
    });

    reaction.schedule();

    expect(value, equals(10));
    x.value = 30;

    expect(value, equals(20)); // Should use y now

    reaction.dispose();
  });
}
