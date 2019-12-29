library generator_sample;

import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

class CircleModel = _CircleModel with _$CircleModel;

abstract class _CircleModel with Store {
  _CircleModel({this.origin, this.radius, this.color});

  @observable
  Offset origin;

  @observable
  Radius radius;

  @observable
  Color color;
}
