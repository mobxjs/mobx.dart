mixin _$Item<T extends num> on _Item<T>, Store {
  static const _reportOnEqualSet = false;

  final _$valueAtom = Atom(name: '_Item.value');

  @override
  T get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(T value) {
    final oldValue = super.value;
    if (_reportOnEqualSet || value != oldValue) {
      _$valueAtom.reportWrite(value, super.value, () {
        super.value = value;
      });
    }
  }

  final _$valuesAtom = Atom(name: '_Item.values');

  @override
  List<T> get values {
    _$valuesAtom.reportRead();
    return super.values;
  }

  @override
  set values(List<T> value) {
    final oldValue = super.values;
    if (_reportOnEqualSet || value != oldValue) {
      _$valuesAtom.reportWrite(value, super.values, () {
        super.values = value;
      });
    }
  }
}
