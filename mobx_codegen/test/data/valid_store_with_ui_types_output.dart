mixin _$CircleModel on _CircleModel, Store {
  final _$originAtom = Atom(name: '_CircleModel.origin');

  @override
  Offset get origin {
    _$originAtom.context.enforceReadPolicy(_$originAtom);
    _$originAtom.reportObserved();
    return super.origin;
  }

  @override
  set origin(Offset value) {
    _$originAtom.context.conditionallyRunInAction(() {
      super.origin = value;
      _$originAtom.reportChanged();
    }, _$originAtom, name: '${_$originAtom.name}_set');
  }

  final _$radiusAtom = Atom(name: '_CircleModel.radius');

  @override
  Radius get radius {
    _$radiusAtom.context.enforceReadPolicy(_$radiusAtom);
    _$radiusAtom.reportObserved();
    return super.radius;
  }

  @override
  set radius(Radius value) {
    _$radiusAtom.context.conditionallyRunInAction(() {
      super.radius = value;
      _$radiusAtom.reportChanged();
    }, _$radiusAtom, name: '${_$radiusAtom.name}_set');
  }

  final _$colorAtom = Atom(name: '_CircleModel.color');

  @override
  Color get color {
    _$colorAtom.context.enforceReadPolicy(_$colorAtom);
    _$colorAtom.reportObserved();
    return super.color;
  }

  @override
  set color(Color value) {
    _$colorAtom.context.conditionallyRunInAction(() {
      super.color = value;
      _$colorAtom.reportChanged();
    }, _$colorAtom, name: '${_$colorAtom.name}_set');
  }
}
