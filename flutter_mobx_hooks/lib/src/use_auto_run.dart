import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobx/mobx.dart';

// TODO: make a class instead, to allow hot-reload on `fn`
void useAutorun(
  Function(Reaction) fn, {
  String name,
  int delay,
  ReactiveContext context,
  void Function(Object, Reaction) onError,
}) {
  useEffect(() {
    return autorun(
      fn,
      name: name,
      delay: delay,
      context: context,
      onError: onError,
    );
  }, [fn, name, delay, context, onError]);
}

// TODO: make a class instead, to allow hot-reload on `predicate` and `effect`
void useWhen(
  bool Function(Reaction) predicate,
  void Function() effect, {
  String name,
  ReactiveContext context,
  int timeout,
  void Function(Object, Reaction) onError,
}) {
  useEffect(() {
    return when(
      predicate,
      effect,
      name: name,
      timeout: timeout,
      context: context,
      onError: onError,
    );
  }, [predicate, effect, name, timeout, context, onError]);
}

// TODO: make a class instead, to allow hot-reload on `predicate` and `effect`
void useReaction<T>(
  T Function(Reaction) predicate,
  void Function(T) effect, {
  String name,
  int delay,
  bool fireImmediately,
  ReactiveContext context,
  void Function(Object, Reaction) onError,
}) {
  useEffect(() {
    return reaction(
      predicate,
      effect,
      name: name,
      fireImmediately: fireImmediately,
      context: context,
      onError: onError,
    );
  }, [predicate, effect, name, fireImmediately, context, onError]);
}
