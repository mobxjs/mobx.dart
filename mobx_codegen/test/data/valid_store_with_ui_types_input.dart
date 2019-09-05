library generator_sample;

import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

class CircleModel = _CircleModel with _$CircleModel;

abstract class _CircleModel with Store {
  _CircleModel({this.origin, this.radius});

  @observable
  Offset origin;

  @observable
  Radius radius;
}

@store
class _BoxModel {
  _BoxModel({
    @required this.boundingRect,
    this.padding = Size.zero,
    this.margin = Size.zero,
    this.color,
    Paragraph paragraph,
  });

  @observable
  Rect boundingRect;

  @observable
  Size padding;

  @observable
  Size margin;

  @observable
  Color color;
}
