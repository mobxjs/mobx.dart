library mobx_utils;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' hide Action;
import 'package:mobx/mobx.dart' hide Listenable;
import 'package:rxdart/rxdart.dart';

class MobxUtils {
  /// converts observable changes to [BehaviorSubject] of events
  /// in getter you should read observable value whether it is [Observable]
  /// or [@observable] field
  /// example: ```
  /// fromGetter(() => obs.value);
  /// // or
  /// fromGetter(() => obsField);
  /// ```
  static Stream<T> fromGetter<T>(T Function() getter) {
    BehaviorSubject<T>? controller;
    ReactionDisposer? disposer;
    return controller = BehaviorSubject<T>(
      onListen: () => disposer = autorun((_) => controller!.add(getter())),
      onCancel: () => disposer?.call(),
    );
  }

  static WithDisposer<Observable<T>> fromListenable<T extends Listenable>(
      T listenable) {
    final obs = Observable<T>(listenable);
    final cb = Action(() => obs
      ..value = listenable
      ..reportManualChange());
    listenable.addListener(cb);
    return WithDisposer(
      obs,
      () => listenable.removeListener(cb),
    );
  }

  static WithDisposer<Observable<T>> fromVnValue<T>(
    ValueNotifier<T> vn, {
    bool? dispose,
  }) {
    final obs = Observable<T>(vn.value);
    final cb = Action(() => obs
      ..value = vn.value
      ..reportManualChange());
    vn.addListener(cb);
    return WithDisposer(
      obs,
      () {
        vn.removeListener(cb);
        if (dispose ?? false) {
          vn.dispose();
        }
      },
    );
  }

  static WithDisposer<Observable<T>> fromCN<T extends ChangeNotifier>(
    T vn, {
    bool? dispose,
  }) {
    final obs = Observable<T>(vn);
    final cb = Action(() => obs
      ..value = vn
      ..reportManualChange());
    vn.addListener(cb);
    return WithDisposer(
      obs,
      () {
        vn.removeListener(cb);
        if (dispose ?? false) {
          vn.dispose();
        }
      },
    );
  }

  MobxUtils._();
}

class WithDisposer<T> {
  final T value;
  final FutureOr Function()? disposer;

  const WithDisposer(this.value, [this.disposer]);

  FutureOr<void> dispose() async {
    await disposer?.call();
  }

  /// use it to attach disposer to disposers list
  /// late final obsValueListenable = MobxUtils.fromVn(valueListenable)
  ///     .handleDispose((disposer) => addDisposer(disposer));
  T handleDispose(Function(FutureOr Function() disposer) f) {
    f(dispose);
    return value;
  }
}

extension ObservableToStream<T> on Observable<T> {
  Stream<T> toStream() => MobxUtils.fromGetter(() => value);

  ObservableStream<T> toObsStream() => toStream().asObservable();
}
