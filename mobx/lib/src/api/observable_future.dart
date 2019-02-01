import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mobx/src/api/context.dart';
import 'package:mobx/src/core.dart';

@experimental
enum FutureStatus { pending, rejected, fulfilled }

@experimental
class ObservableFuture<T> implements Future<T> {
  ObservableFuture(Future<T> future, {ReactiveContext context})
      : this._(context ?? mainContext, future, FutureStatus.pending);

  ObservableFuture._(
      ReactiveContext context, this._future, FutureStatus initialStatus)
      : _context = context,
        _status = Observable(initialStatus, context: context),
        _actions = ActionController(
            context: context, name: context.nameFor('ObservableFuture<$T>')),
        _result = Observable(null) {
    _future.then(_fulfill, onError: _reject);
  }

  final ReactiveContext _context;
  final ActionController _actions;
  final Future<T> _future;
  final Observable<FutureStatus> _status;
  final Observable _result;

  FutureStatus get status => _status.value;

  T get value => status == FutureStatus.fulfilled ? _result.value : null;

  T get error => status == FutureStatus.rejected ? _result.value : null;

  void _fulfill(T value) {
    final prevDerivation = _actions.startAction();
    try {
      _status.value = FutureStatus.fulfilled;
      _result.value = value;
    } finally {
      _actions.endAction(prevDerivation);
    }
  }

  void _reject(error) {
    final prevDerivation = _actions.startAction();
    try {
      _status.value = FutureStatus.rejected;
      _result.value = error;
    } finally {
      _actions.endAction(prevDerivation);
    }
  }

  R match<R>(
      {R Function(T) fulfilled,
      // ignore:avoid_annotating_with_dynamic
      R Function(dynamic) rejected,
      R Function() pending}) {
    final status = _status.value;

    if (status == FutureStatus.fulfilled) {
      return fulfilled == null ? null : fulfilled(_result.value);
    } else if (status == FutureStatus.rejected) {
      return rejected == null ? null : rejected(_result.value);
    }
    return pending == null ? null : pending();
  }

  @override
  Stream<T> asStream() => _future.asStream();

  @override
  ObservableFuture<T> catchError(Function onError,
          {bool Function(Object error) test}) =>
      ObservableFuture._(_context, _future.catchError(onError, test: test),
          FutureStatus.pending);

  @override
  ObservableFuture<R> then<R>(FutureOr<R> Function(T value) onValue,
          {Function onError}) =>
      ObservableFuture._(_context, _future.then(onValue, onError: onError),
          FutureStatus.pending);

  @override
  ObservableFuture<T> timeout(Duration timeLimit,
          {FutureOr<T> Function() onTimeout}) =>
      ObservableFuture._(
          _context,
          _future.timeout(timeLimit, onTimeout: onTimeout),
          FutureStatus.pending);

  @override
  ObservableFuture<T> whenComplete(FutureOr Function() action) =>
      ObservableFuture._(
          _context, _future.whenComplete(action), FutureStatus.pending);
}
