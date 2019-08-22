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
  Engine engine;

  @observable
  ObservableList<Tire> tires = ObservableList<Tire>();

  @observable
  Windshield windshield = Windshield();

  @action
  Future<List<Tire>> changeTiresIfRequired() async => [];

  @action
  Future<List<T>> changeCarPartsIfRequired<T extends CarPart>() async => [];
}

@store
class _CarPart {}

@store
class _Engine extends CarPart {}

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
class _Bug {}
