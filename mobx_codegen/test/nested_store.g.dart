// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nested_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NestedStore on _NestedStore, Store {
  late final _$nameAtom = Atom(name: '_NestedStore.name', context: context);

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  bool _nameIsInitialized = false;

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, _nameIsInitialized ? super.name : null, () {
      super.name = value;
      _nameIsInitialized = true;
    });
  }

  @override
  String toString() {
    return '''
name: ${name}
    ''';
  }
}
