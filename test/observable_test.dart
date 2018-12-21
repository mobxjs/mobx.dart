import 'package:mobx/src/observable.dart';
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
    expect(c.value, equals(30));
  });

  test('Derivation', (){

    var x =
  });
}
