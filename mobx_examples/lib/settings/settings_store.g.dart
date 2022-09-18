// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SettingsStore on _SettingsStore, Store {
  late final _$useDarkModeAtom =
      Atom(name: '_SettingsStore.useDarkMode', context: context);

  @override
  bool get useDarkMode {
    _$useDarkModeAtom.reportRead();
    return super.useDarkMode;
  }

  @override
  set useDarkMode(bool value) {
    _$useDarkModeAtom.reportWrite(value, super.useDarkMode, () {
      super.useDarkMode = value;
    });
  }

  late final _$setDarkModeAsyncAction =
      AsyncAction('_SettingsStore.setDarkMode', context: context);

  @override
  Future<void> setDarkMode({required bool value}) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(value: value));
  }

  @override
  String toString() {
    return '''
useDarkMode: ${useDarkMode}
    ''';
  }
}
