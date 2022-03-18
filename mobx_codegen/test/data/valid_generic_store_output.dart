mixin _$Item<T extends num> on _Item<T>, Store {
  late final _$value1Atom = Atom(name: '_Item.value1', context: context);

  @override
  T get value1 {
    _$value1Atom.reportRead();
    return super.value1;
  }

  @override
  set value1(T value) {
    _$value1Atom.reportWrite(value, super.value1, () {
      super.value1 = value;
    });
  }

  late final _$value2Atom = Atom(name: '_Item.value2', context: context);

  @override
  T? get value2 {
    _$value2Atom.reportRead();
    return super.value2;
  }

  @override
  set value2(T? value) {
    _$value2Atom.reportWrite(value, super.value2, () {
      super.value2 = value;
    });
  }

  late final _$values1Atom = Atom(name: '_Item.values1', context: context);

  @override
  List<T> get values1 {
    _$values1Atom.reportRead();
    return super.values1;
  }

  @override
  set values1(List<T> value) {
    _$values1Atom.reportWrite(value, super.values1, () {
      super.values1 = value;
    });
  }

  late final _$values2Atom = Atom(name: '_Item.values2', context: context);

  @override
  List<T> get values2 {
    _$values2Atom.reportRead();
    return super.values2;
  }

  @override
  set values2(List<T> value) {
    _$values2Atom.reportWrite(value, super.values2, () {
      super.values2 = value;
    });
  }
}
