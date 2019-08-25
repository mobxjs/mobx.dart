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
}

class BoxModel extends _BoxModel {
  BoxModel({Rect boundingRect, Size padding, Size margin, Color color})
      : super(
            boundingRect: boundingRect,
            padding: padding,
            margin: margin,
            color: color);

  final _$boundingRectAtom = Atom(name: '_BoxModel.boundingRect');

  @override
  Rect get boundingRect {
    _$boundingRectAtom.context.enforceReadPolicy(_$boundingRectAtom);
    _$boundingRectAtom.reportObserved();
    return super.boundingRect;
  }

  @override
  set boundingRect(Rect value) {
    _$boundingRectAtom.context.conditionallyRunInAction(() {
      super.boundingRect = value;
      _$boundingRectAtom.reportChanged();
    }, _$boundingRectAtom, name: '${_$boundingRectAtom.name}_set');
  }

  final _$paddingAtom = Atom(name: '_BoxModel.padding');

  @override
  Size get padding {
    _$paddingAtom.context.enforceReadPolicy(_$paddingAtom);
    _$paddingAtom.reportObserved();
    return super.padding;
  }

  @override
  set padding(Size value) {
    _$paddingAtom.context.conditionallyRunInAction(() {
      super.padding = value;
      _$paddingAtom.reportChanged();
    }, _$paddingAtom, name: '${_$paddingAtom.name}_set');
  }

  final _$marginAtom = Atom(name: '_BoxModel.margin');

  @override
  Size get margin {
    _$marginAtom.context.enforceReadPolicy(_$marginAtom);
    _$marginAtom.reportObserved();
    return super.margin;
  }

  @override
  set margin(Size value) {
    _$marginAtom.context.conditionallyRunInAction(() {
      super.margin = value;
      _$marginAtom.reportChanged();
    }, _$marginAtom, name: '${_$marginAtom.name}_set');
  }

  final _$colorAtom = Atom(name: '_BoxModel.color');

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
