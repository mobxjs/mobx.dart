library generator_sample;

import 'dart:ui' as ui;

import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

@store
class _Car {
  _Car(this.engine);

  @observable
  ui.Color paintColor;

  @observable
  Engine _engine;
  Engine get engine => _engine;
  set engine(Engine value) => _engine = engine;

  @observable
  ObservableList<Tire> tires = ObservableList<Tire>();

  @observable
  Windshield windshield = Windshield();

  @computed
  Set<Tire> get flatTires() => {};

  @action
  Future<List<Tire>> changeTiresIfRequired() async => [];

  @action
  Future<List<T>> changeCarPartsIfRequired<T extends CarPart>() async => [];
}

@store
class _CarPart {}

@store
class _Engine extends CarPart {
  @action
  void swapInParts({Engine from}) {}
}

@store
class _Tire extends CarPart {}

@store
class _Windshield extends CarPart {
  @observable
  Stream<List<Bug>> squashedBugs() async* {
    yield <Bug>[];
  }
}

@store
class _Bug {
  @action
  T sizeInMillimeters<T extends num>() => null;
}
