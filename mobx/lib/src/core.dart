import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx/src/utils.dart';

part 'core/action.dart';
part 'core/atom.dart';
part 'core/computed.dart';
part 'core/context.dart';
part 'core/derivation.dart';
part 'core/notification_handlers.dart';
part 'core/observable.dart';
part 'core/reaction.dart';
part 'core/reaction_helper.dart';
part 'interceptable.dart';
part 'listenable.dart';

class MobXException implements Exception {
  MobXException(this.message);

  String message;
}

class MobXCaughtException implements Exception {
  MobXCaughtException(exception) : _exception = exception;

  final Object _exception;
  Object get exception => _exception;

  @override
  String toString() => 'MobXCaughtException: $exception';
}

typedef Dispose = void Function();
