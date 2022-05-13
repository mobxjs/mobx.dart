import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

part 'store_with_custom_context.g.dart';

// ignore: library_private_types_in_public_api
class CustomContextStore = _CustomContextStore with _$CustomContextStore;

final ReactiveContext customContext = ReactiveContext();

abstract class _CustomContextStore with Store {
  @observable
  late String name;

  @override
  ReactiveContext get context => customContext;
}

void main() {
  test('use custom context', () {
    final store = CustomContextStore();

    expect(store._$nameAtom.context, equals(customContext));
  });
}
