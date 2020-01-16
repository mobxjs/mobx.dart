mixin _$Item<T extends num> on _Item<T>, Store {
  final _$valueAtom = Atom(name: '_Item.value');

  @override
  T get value {
    _$valueAtom.context.enforceReadPolicy(_$valueAtom);
    _$valueAtom.reportObserved();
    return super.value;
  }

  @override
  set value(T value) {
    _$valueAtom.context.conditionallyRunInAction(() {
      super.value = value;
      _$valueAtom.reportChanged();
    }, _$valueAtom, name: '${_$valueAtom.name}_set');
  }

  final _$valuesAtom = Atom(name: '_Item.values');

  @override
  List<T> get values {
    _$valuesAtom.context.enforceReadPolicy(_$valuesAtom);
    _$valuesAtom.reportObserved();
    return super.values;
  }

  @override
  set values(List<T> value) {
    _$valuesAtom.context.conditionallyRunInAction(() {
      super.values = value;
      _$valuesAtom.reportChanged();
    }, _$valuesAtom, name: '${_$valuesAtom.name}_set');
  }
}
