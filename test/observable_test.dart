import 'package:mobx/src/computed.dart';
import 'package:mobx/src/observable.dart';
import 'package:mobx/src/reaction.dart';
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

    Reaction('reaction', () {
      nextValue = c.value + 1;
    }).schedule();

    expect(nextValue, equals(1));

    c.value = 10;
    expect(nextValue, equals(11));
  });
}
