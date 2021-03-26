// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_usage_test.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TestStore on _TestStore, Store {
  Computed<String>? _$fieldsComputed;

  @override
  String get fields => (_$fieldsComputed ??=
          Computed<String>(() => super.fields, name: '_TestStore.fields'))
      .value;
  Computed<String>? _$batchedItemsComputed;

  @override
  String get batchedItems =>
      (_$batchedItemsComputed ??= Computed<String>(() => super.batchedItems,
              name: '_TestStore.batchedItems'))
          .value;

  final _$field1Atom = Atom(name: '_TestStore.field1');

  @override
  String get field1 {
    _$field1Atom.reportRead();
    return super.field1;
  }

  @override
  set field1(String value) {
    _$field1Atom.reportWrite(value, super.field1, () {
      super.field1 = value;
    });
  }

  final _$field2Atom = Atom(name: '_TestStore.field2');

  @override
  String? get field2 {
    _$field2Atom.reportRead();
    return super.field2;
  }

  @override
  set field2(String? value) {
    _$field2Atom.reportWrite(value, super.field2, () {
      super.field2 = value;
    });
  }

  final _$stuffAtom = Atom(name: '_TestStore.stuff');

  @override
  String get stuff {
    _$stuffAtom.reportRead();
    return super.stuff;
  }

  @override
  set stuff(String value) {
    _$stuffAtom.reportWrite(value, super.stuff, () {
      super.stuff = value;
    });
  }

  final _$batchItem1Atom = Atom(name: '_TestStore.batchItem1');

  @override
  String get batchItem1 {
    _$batchItem1Atom.reportRead();
    return super.batchItem1;
  }

  @override
  set batchItem1(String value) {
    _$batchItem1Atom.reportWrite(value, super.batchItem1, () {
      super.batchItem1 = value;
    });
  }

  final _$batchItem2Atom = Atom(name: '_TestStore.batchItem2');

  @override
  String get batchItem2 {
    _$batchItem2Atom.reportRead();
    return super.batchItem2;
  }

  @override
  set batchItem2(String value) {
    _$batchItem2Atom.reportWrite(value, super.batchItem2, () {
      super.batchItem2 = value;
    });
  }

  final _$batchItem3Atom = Atom(name: '_TestStore.batchItem3');

  @override
  String get batchItem3 {
    _$batchItem3Atom.reportRead();
    return super.batchItem3;
  }

  @override
  set batchItem3(String value) {
    _$batchItem3Atom.reportWrite(value, super.batchItem3, () {
      super.batchItem3 = value;
    });
  }

  final _$batchItem4Atom = Atom(name: '_TestStore.batchItem4');

  @override
  String get batchItem4 {
    _$batchItem4Atom.reportRead();
    return super.batchItem4;
  }

  @override
  set batchItem4(String value) {
    _$batchItem4Atom.reportWrite(value, super.batchItem4, () {
      super.batchItem4 = value;
    });
  }

  final _$errorFieldAtom = Atom(name: '_TestStore.errorField');

  @override
  String get errorField {
    _$errorFieldAtom.reportRead();
    return super.errorField;
  }

  @override
  set errorField(String value) {
    _$errorFieldAtom.reportWrite(value, super.errorField, () {
      super.errorField = value;
    });
  }

  @override
  ObservableFuture<String> future() {
    final _$future = super.future();
    return ObservableFuture<String>(_$future);
  }

  @override
  ObservableFuture<String> asyncMethod() {
    final _$future = super.asyncMethod();
    return ObservableFuture<String>(_$future);
  }

  @override
  ObservableStream<String> asyncGenerator() {
    final _$stream = super.asyncGenerator();
    return ObservableStream<String>(_$stream);
  }

  @override
  ObservableStream<String> stream() {
    final _$stream = super.stream();
    return ObservableStream<String>(_$stream);
  }

  final _$loadStuffAsyncAction = AsyncAction('_TestStore.loadStuff');

  @override
  Future<void> loadStuff() {
    return _$loadStuffAsyncAction.run(() => super.loadStuff());
  }

  final _$loadStuff2AsyncAction = AsyncAction('_TestStore.loadStuff2');

  @override
  ObservableFuture<void> loadStuff2() {
    return ObservableFuture<void>(
        _$loadStuff2AsyncAction.run(() => super.loadStuff2()));
  }

  final _$batchedChangesAsyncAction = AsyncAction('_TestStore.batchedChanges');

  @override
  Future<void> batchedChanges() {
    return _$batchedChangesAsyncAction.run(() => super.batchedChanges());
  }

  final _$throwsErrorAsyncAction = AsyncAction('_TestStore.throwsError');

  @override
  Future<void> throwsError() {
    return _$throwsErrorAsyncAction.run(() => super.throwsError());
  }

  final _$_TestStoreActionController = ActionController(name: '_TestStore');

  @override
  void setFields(String field1, String field2) {
    final _$actionInfo =
        _$_TestStoreActionController.startAction(name: '_TestStore.setFields');
    try {
      return super.setFields(field1, field2);
    } finally {
      _$_TestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
field1: ${field1},
field2: ${field2},
stuff: ${stuff},
batchItem1: ${batchItem1},
batchItem2: ${batchItem2},
batchItem3: ${batchItem3},
batchItem4: ${batchItem4},
errorField: ${errorField},
fields: ${fields},
batchedItems: ${batchedItems}
    ''';
  }
}
