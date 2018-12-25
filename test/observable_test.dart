import 'package:mobx/src/api/observable.dart';
import 'package:mobx/src/core/computed.dart';
import 'package:mobx/src/core/observable.dart';
import "package:test/test.dart";

void main() {
  test('Basic observable<T>', () {
    var x = observable<int>(null);
    expect(x.value, equals(null));

    x.value = 100;
    expect(x.value, equals(100));

    var str = observable('hello');
    expect(str is ObservableValue<String>, equals(true));
    expect(str.value, equals('hello'));

    str.value = 'mobx';
    expect(str.value, equals('mobx'));
  });

  test('Computed value', () {
    var x = observable(20);
    var y = observable(10);
    var c = ComputedValue<int>('counter', () {
      return x.value + y.value;
    });

    x.value = 30;
    y.value = 20;
    expect(c.value, equals(50));
  });
}
