import 'dart:async';
import 'dart:mirrors';

import 'package:mobx/src/core/reaction.dart';

const ms = const Duration(milliseconds: 1);

Timer Function(Function) createDelayedScheduler(int delayMs) {
  return (Function fn) {
    return Timer(ms * delayMs, fn);
  };
}

Function(Reaction) prepareTrackingFunction(Function fn) {
  var mirror = reflect(fn);
  if (mirror is ClosureMirror) {
    var fnMirror = mirror as ClosureMirror;
    if (fnMirror.function.parameters.length >= 1) {
      var param = fnMirror.function.parameters.first;
      if (param.type.reflectedType == Reaction) {
        return (Reaction rxn) {
          return fn(rxn);
        };
      }
    }
  }

  return (Reaction rxn) => fn();
}
