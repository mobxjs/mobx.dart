import 'package:mobx/src/api/observable.dart';
import 'package:mobx/src/api/reaction.dart';
import 'package:test/test.dart';

void main() {
  test('When', () {
    var executed = false;
    var x = observable(10);
    var d = when(() {
      return x.value > 10;
    }, () {
      executed = true;
    }, name: 'Basic when');

    expect(executed, isFalse);
    expect(d.$mobx.name, 'Basic when');

    x.value = 11;

    expect(executed, isTrue);
    expect(d.$mobx.isDisposed, isTrue);
    executed = false;

    x.value = 12;
    expect(executed, isFalse); // No more effects as its disposed
  });

  test('Async When', () {
    var x = observable(10);
    asyncWhen(() => x.value > 10, name: 'Async-when').then((_) {
      expect(true, isTrue);
    });

    x.value = 11;
  });
}
