import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

void main() {
  test(
      'when write to @observable field with changed value, should trigger notifications for downstream',
      () {
    final store = _ExampleStore();

    final autorunResults = <String>[];
    autorun((_) => autorunResults.add(store.value));

    expect(autorunResults, ['first']);

    store.value = 'second';

    expect(autorunResults, ['first', 'second']);
  });

  // fixed by #855
  test(
      'when write to @observable field with unchanged value, should not trigger notifications for downstream',
      () {
    final store = _ExampleStore();

    final autorunResults = <String>[];
    autorun((_) => autorunResults.add(store.value));

    expect(autorunResults, ['first']);

    store.value = store.value;

    expect(autorunResults, ['first']);
  });
}

class _ExampleStore = __ExampleStore with _$_ExampleStore;

abstract class __ExampleStore with Store {
  @observable
  String value = 'first';
}

// This is what typically a mobx codegen will generate.
mixin _$_ExampleStore on __ExampleStore, Store {
  // ignore: non_constant_identifier_names
  late final _$valueAtom = Atom(name: '__ExampleStore.value', context: context);

  @override
  String get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(String value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }
}
