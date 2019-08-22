class Car extends _Car {
  Car(Engine engine) : super(engine);

  final _$paintColorAtom = Atom(name: '_Car.paintColor');

  @override
  ui.Color get paintColor {
    _$paintColorAtom.context.enforceReadPolicy(_$paintColorAtom);
    _$paintColorAtom.reportObserved();
    return super.paintColor;
  }

  @override
  set paintColor(ui.Color value) {
    _$paintColorAtom.context.conditionallyRunInAction(() {
      super.paintColor = value;
      _$paintColorAtom.reportChanged();
    }, _$paintColorAtom, name: '${_$paintColorAtom.name}_set');
  }

  final _$engineAtom = Atom(name: '_Car.engine');

  @override
  Engine get engine {
    _$engineAtom.context.enforceReadPolicy(_$engineAtom);
    _$engineAtom.reportObserved();
    return super.engine;
  }

  @override
  set engine(Engine value) {
    _$engineAtom.context.conditionallyRunInAction(() {
      super.engine = value;
      _$engineAtom.reportChanged();
    }, _$engineAtom, name: '${_$engineAtom.name}_set');
  }

  final _$tiresAtom = Atom(name: '_Car.tires');

  @override
  ObservableList<Tire> get tires {
    _$tiresAtom.context.enforceReadPolicy(_$tiresAtom);
    _$tiresAtom.reportObserved();
    return super.tires;
  }

  @override
  set tires(ObservableList<Tire> value) {
    _$tiresAtom.context.conditionallyRunInAction(() {
      super.tires = value;
      _$tiresAtom.reportChanged();
    }, _$tiresAtom, name: '${_$tiresAtom.name}_set');
  }

  final _$windshieldAtom = Atom(name: '_Car.windshield');

  @override
  Windshield get windshield {
    _$windshieldAtom.context.enforceReadPolicy(_$windshieldAtom);
    _$windshieldAtom.reportObserved();
    return super.windshield;
  }

  @override
  set windshield(Windshield value) {
    _$windshieldAtom.context.conditionallyRunInAction(() {
      super.windshield = value;
      _$windshieldAtom.reportChanged();
    }, _$windshieldAtom, name: '${_$windshieldAtom.name}_set');
  }

  final _$changeTiresIfRequiredAsyncAction =
      AsyncAction('changeTiresIfRequired');

  @override
  Future<List<Tire>> changeTiresIfRequired() {
    return _$changeTiresIfRequiredAsyncAction
        .run(() => super.changeTiresIfRequired());
  }

  final _$changeCarPartsIfRequiredAsyncAction =
      AsyncAction('changeCarPartsIfRequired');

  @override
  Future<List<T>> changeCarPartsIfRequired<T extends CarPart>() {
    return _$changeCarPartsIfRequiredAsyncAction
        .run(() => super.changeCarPartsIfRequired<T>());
  }
}

class CarPart extends _CarPart {
  CarPart() : super();
}

class Engine extends _Engine {
  Engine() : super();
}

class Tire extends _Tire {
  Tire() : super();
}

class Windshield extends _Windshield {
  Windshield() : super();

  @override
  ObservableStream<List<Bug>> squashedBugs() {
    final _$stream = super.squashedBugs();
    return ObservableStream<List<Bug>>(_$stream);
  }
}

class Bug extends _Bug {
  Bug() : super();
}
