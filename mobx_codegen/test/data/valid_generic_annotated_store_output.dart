class Item<T> extends _Item<T> {
  Item(T aThing, [T value, T anotherThing])
      : super(aThing, value, anotherThing);

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
}
