mixin _$Foo on _Foo, Store {
  late final _$nameAtom = Atom(name: '_Foo.name', context: context);

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
