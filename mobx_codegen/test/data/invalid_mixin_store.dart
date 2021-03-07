library generator_sample;

import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

class NonAbstractUser = NonAbstractUserBase with _$NonAbstractUserBase;

// ignore: unused_element
class NonAbstractUserBase with Store {}
