// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobx_base.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MobxBase on _MobxBase, Store {
  Computed<StoreState> _$stateComputed;

  @override
  StoreState get state =>
      (_$stateComputed ??= Computed<StoreState>(() => super.state)).value;

  final _$_stateAtom = Atom(name: '_MobxBase._state');

  @override
  StoreState get _state {
    _$_stateAtom.context.enforceReadPolicy(_$_stateAtom);
    _$_stateAtom.reportObserved();
    return super._state;
  }

  @override
  set _state(StoreState value) {
    _$_stateAtom.context.conditionallyRunInAction(() {
      super._state = value;
      _$_stateAtom.reportChanged();
    }, _$_stateAtom, name: '${_$_stateAtom.name}_set');
  }

  final _$_MobxBaseActionController = ActionController(name: '_MobxBase');

  @override
  void changeState(StoreState state) {
    final _$actionInfo = _$_MobxBaseActionController.startAction();
    try {
      return super.changeState(state);
    } finally {
      _$_MobxBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toLoadingState() {
    final _$actionInfo = _$_MobxBaseActionController.startAction();
    try {
      return super.toLoadingState();
    } finally {
      _$_MobxBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toErrorState() {
    final _$actionInfo = _$_MobxBaseActionController.startAction();
    try {
      return super.toErrorState();
    } finally {
      _$_MobxBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toSuccessState() {
    final _$actionInfo = _$_MobxBaseActionController.startAction();
    try {
      return super.toSuccessState();
    } finally {
      _$_MobxBaseActionController.endAction(_$actionInfo);
    }
  }
}
