// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nested_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$NestedStore on _NestedStore, Store {
  final _$nameAtom = Atom(name: '_NestedStore.name');

  @override
  String get name {
    _$nameAtom.context.enforceReadPolicy(_$nameAtom);
    _$nameAtom.reportObserved();
    return super.name;
  }

  @override
  set name(String value) {
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    _$nameAtom.context.conditionallyRunInAction(() {
      super.name = value;
      _$nameAtom.reportChanged();
    }, name: '${_$nameAtom.name}_set');
  }
}
