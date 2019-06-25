// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_usage_test.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$TestStore on _TestStore, Store {
  Computed<String> _$fieldsComputed;

  @override
  String get fields =>
      (_$fieldsComputed ??= Computed<String>(() => super.fields)).value;
  Computed<String> _$batchedItemsComputed;

  @override
  String get batchedItems =>
      (_$batchedItemsComputed ??= Computed<String>(() => super.batchedItems))
          .value;

  final _$field1Atom = Atom(name: '_TestStore.field1');

  @override
  String get field1 {
    _$field1Atom.context.enforceReadPolicy(_$field1Atom);
    _$field1Atom.reportObserved();
    return super.field1;
  }

  @override
  set field1(String value) {
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    _$field1Atom.context.conditionallyRunInAction(() {
      super.field1 = value;
      _$field1Atom.reportChanged();
    }, name: '${_$field1Atom.name}_set');
  }

  final _$field2Atom = Atom(name: '_TestStore.field2');

  @override
  String get field2 {
    _$field2Atom.context.enforceReadPolicy(_$field2Atom);
    _$field2Atom.reportObserved();
    return super.field2;
  }

  @override
  set field2(String value) {
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    _$field2Atom.context.conditionallyRunInAction(() {
      super.field2 = value;
      _$field2Atom.reportChanged();
    }, name: '${_$field2Atom.name}_set');
  }

  final _$stuffAtom = Atom(name: '_TestStore.stuff');

  @override
  String get stuff {
    _$stuffAtom.context.enforceReadPolicy(_$stuffAtom);
    _$stuffAtom.reportObserved();
    return super.stuff;
  }

  @override
  set stuff(String value) {
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    _$stuffAtom.context.conditionallyRunInAction(() {
      super.stuff = value;
      _$stuffAtom.reportChanged();
    }, name: '${_$stuffAtom.name}_set');
  }

  final _$batchItem1Atom = Atom(name: '_TestStore.batchItem1');

  @override
  String get batchItem1 {
    _$batchItem1Atom.context.enforceReadPolicy(_$batchItem1Atom);
    _$batchItem1Atom.reportObserved();
    return super.batchItem1;
  }

  @override
  set batchItem1(String value) {
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    _$batchItem1Atom.context.conditionallyRunInAction(() {
      super.batchItem1 = value;
      _$batchItem1Atom.reportChanged();
    }, name: '${_$batchItem1Atom.name}_set');
  }

  final _$batchItem2Atom = Atom(name: '_TestStore.batchItem2');

  @override
  String get batchItem2 {
    _$batchItem2Atom.context.enforceReadPolicy(_$batchItem2Atom);
    _$batchItem2Atom.reportObserved();
    return super.batchItem2;
  }

  @override
  set batchItem2(String value) {
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    _$batchItem2Atom.context.conditionallyRunInAction(() {
      super.batchItem2 = value;
      _$batchItem2Atom.reportChanged();
    }, name: '${_$batchItem2Atom.name}_set');
  }

  final _$batchItem3Atom = Atom(name: '_TestStore.batchItem3');

  @override
  String get batchItem3 {
    _$batchItem3Atom.context.enforceReadPolicy(_$batchItem3Atom);
    _$batchItem3Atom.reportObserved();
    return super.batchItem3;
  }

  @override
  set batchItem3(String value) {
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    _$batchItem3Atom.context.conditionallyRunInAction(() {
      super.batchItem3 = value;
      _$batchItem3Atom.reportChanged();
    }, name: '${_$batchItem3Atom.name}_set');
  }

  final _$batchItem4Atom = Atom(name: '_TestStore.batchItem4');

  @override
  String get batchItem4 {
    _$batchItem4Atom.context.enforceReadPolicy(_$batchItem4Atom);
    _$batchItem4Atom.reportObserved();
    return super.batchItem4;
  }

  @override
  set batchItem4(String value) {
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    _$batchItem4Atom.context.conditionallyRunInAction(() {
      super.batchItem4 = value;
      _$batchItem4Atom.reportChanged();
    }, name: '${_$batchItem4Atom.name}_set');
  }

  final _$errorFieldAtom = Atom(name: '_TestStore.errorField');

  @override
  String get errorField {
    _$errorFieldAtom.context.enforceReadPolicy(_$errorFieldAtom);
    _$errorFieldAtom.reportObserved();
    return super.errorField;
  }

  @override
  set errorField(String value) {
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    _$errorFieldAtom.context.conditionallyRunInAction(() {
      super.errorField = value;
      _$errorFieldAtom.reportChanged();
    }, name: '${_$errorFieldAtom.name}_set');
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

  final _$loadStuffAsyncAction = AsyncAction('loadStuff');

  @override
  Future<void> loadStuff() {
    return _$loadStuffAsyncAction.run(() => super.loadStuff());
  }

  final _$loadStuff2AsyncAction = AsyncAction('loadStuff2');

  @override
  ObservableFuture<void> loadStuff2() {
    return ObservableFuture<void>(
        _$loadStuff2AsyncAction.run(() => super.loadStuff2()));
  }

  final _$batchedChangesAsyncAction = AsyncAction('batchedChanges');

  @override
  Future<void> batchedChanges() {
    return _$batchedChangesAsyncAction.run(() => super.batchedChanges());
  }

  final _$throwsErrorAsyncAction = AsyncAction('throwsError');

  @override
  Future<void> throwsError() {
    return _$throwsErrorAsyncAction.run(() => super.throwsError());
  }

  final _$_TestStoreActionController = ActionController(name: '_TestStore');

  @override
  void setFields(String field1, String field2) {
    final _$actionInfo = _$_TestStoreActionController.startAction();
    try {
      return super.setFields(field1, field2);
    } finally {
      _$_TestStoreActionController.endAction(_$actionInfo);
    }
  }
}
