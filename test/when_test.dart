import 'package:mobx/src/api/observable.dart';
import 'package:mobx/src/api/reaction.dart';
import 'package:test/test.dart';

void main() {
  test('When', () {
    var executed = false;
    final x = observable(10);
    final d = when(() {
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

  test('when with default name', () {
    final d = when(() => true, () {});

    expect(d.$mobx.name, startsWith('When@'));

    d();
  });

  test('Async When', () {
    final x = observable(10);
    asyncWhen(() => x.value > 10, name: 'Async-when').then((_) {
      expect(true, isTrue);
    });

    x.value = 11;
  });
}
