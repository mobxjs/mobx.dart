import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

class TestStore with Store {}

final customContext = ReactiveContext();

class CustomStore with Store {
  @override
  ReactiveContext get context => customContext;
}

void main() {
  group('Store', () {
    test('can get context', () {
      final store = TestStore();
      expect(store.context, mainContext);
    });

    test('Store with custom context', () {
      final store = CustomStore();
      expect(store.context, customContext);
    });
  });
}
