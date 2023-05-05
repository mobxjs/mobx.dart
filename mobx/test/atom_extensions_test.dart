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

  test(
      'when write to @alwaysNotify field with unchanged value, should trigger notifications for downstream',
      () {
    final store = _ExampleStore();

    final autorunResults = <String>[];
    autorun((_) => autorunResults.add(store.value2));

    expect(autorunResults, ['first']);

    store.value2 = store.value2;

    expect(autorunResults, ['first', 'first']);
  });

  test(
      'when write to @MakeObservable(equals: "a?.length == b?.length") field with changed value and not equals, should trigger notifications for downstream',
      () {
    final store = _ExampleStore();

    final autorunResults = <String>[];
    autorun((_) => autorunResults.add(store.value3));

    expect(autorunResults, ['first']); // length: 5

    // length: 5, should not trigger
    store.value3 = 'third';

    expect(autorunResults, ['first']);

    // length: 6, should trigger
    store.value3 = 'second';

    expect(autorunResults, ['first', 'second']);
  });
}

class _ExampleStore = __ExampleStore with _$_ExampleStore;

bool _equals(String? oldValue, String? newValue) => (oldValue == newValue);

abstract class __ExampleStore with Store {
  @observable
  String value = 'first';

  @alwaysNotify
  String value2 = 'first';

  @MakeObservable(equals: _equals)
  String value3 = 'first';
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

  // ignore: non_constant_identifier_names
  late final _$value2Atom =
      Atom(name: '__ExampleStore.value2', context: context);

  @override
  String get value2 {
    _$value2Atom.reportRead();
    return super.value2;
  }

  @override
  set value2(String value) {
    _$value2Atom.reportWrite(value, super.value2, () {
      super.value2 = value;
    }, equals: (String? oldValue, String? newValue) => false);
  }

  // ignore: non_constant_identifier_names
  late final _$value3Atom =
      Atom(name: '__ExampleStore.value3', context: context);

  @override
  String get value3 {
    _$value3Atom.reportRead();
    return super.value3;
  }

  @override
  set value3(String value) {
    _$value3Atom.reportWrite(value, super.value3, () {
      super.value3 = value;
    },
        equals: (String? oldValue, String? newValue) =>
            oldValue?.length == newValue?.length);
  }
}
