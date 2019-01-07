import 'package:mobx/src/framework.dart';

/// Current Mobx context.
/// At the moment it is a singleton, but in the future
/// it might be replaced with a Zone specific value.
final ReactiveContext currentContext = ReactiveContext();
