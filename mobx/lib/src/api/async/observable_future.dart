part of '../async.dart';

@experimental
enum FutureStatus { pending, rejected, fulfilled }

class FutureResult<T> {
  FutureResult(ReactiveContext context, Future<T> _future, initialResult,
      FutureStatus initialStatus)
      : _actions = ActionController(
            context: context, name: context.nameFor('ObservableFuture<$T>')),
        _status = Observable(initialStatus),
        _result = Observable(initialResult) {
    _future.then(_fulfill, onError: _reject);
  }

  final ActionController _actions;

  final Observable<FutureStatus> _status;
  FutureStatus get status => _status.value;

  final Observable _result;
  dynamic get result => _result.value;

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
}

@experimental
class ObservableFuture<T> implements Future<T> {
  /// Create a new observable future that tracks the state of the provided future.
  ObservableFuture(Future<T> future, {ReactiveContext context})
      : this._(context ?? mainContext, future, FutureStatus.pending, null);

  /// Create a new future that is completed with a value.
  ///
  /// [status] is immediately [FutureStatus.fulfilled].
  ObservableFuture.value(T value, {ReactiveContext context})
      : this._(context ?? mainContext, Future.value(value),
            FutureStatus.fulfilled, value);

  /// Create a new future that is completed with an error.
  ///
  /// [status] is immediately [FutureStatus.rejected].
  ObservableFuture.error(error, {ReactiveContext context})
      : this._(context ?? mainContext, Future.error(error),
            FutureStatus.rejected, error);

  ObservableFuture._(
      this._context, this._future, this._initialStatus, this._initialResult)
      : assert(_context != null),
        assert(_future != null);

  final ReactiveContext _context;
  Future<T> _future;
  FutureStatus _initialStatus;
  dynamic _initialResult;

  FutureResult<T> _resultField;

  FutureResult<T> get _result {
    if (_resultField == null) {
      _resultField =
          FutureResult(_context, _future, _initialResult, _initialStatus);
      _initialResult = null;
      _initialStatus = null;
    }
    return _resultField;
  }

  /// Observable status of this.
  FutureStatus get status => _result.status;

  /// Value if this completed with a value.
  ///
  /// Null otherwise.
  T get value => status == FutureStatus.fulfilled ? _result.result : null;

  /// Error value if this completed with an error
  ///
  /// Null otherwise.
  T get error => status == FutureStatus.rejected ? _result.result : null;

  /// Error or value of this.
  ///
  /// Null if this hasn't yet completed.
  dynamic get result => _result.result;

  /// Maps the current state of this.
  ///
  /// Returns null if a handler for the current state is not provided.
  R match<R>(
      {R Function(T) fulfilled,
      // ignore:avoid_annotating_with_dynamic
      R Function(dynamic) rejected,
      R Function() pending}) {
    final status = this.status;

    if (status == FutureStatus.fulfilled) {
      return fulfilled == null ? null : fulfilled(result);
    } else if (status == FutureStatus.rejected) {
      return rejected == null ? null : rejected(result);
    }
    return pending == null ? null : pending();
  }

  /// Returns a new future that starts with the [status] and [result] of this.
  ///
  /// The [status] and [result] changes when the provided future completes.
  /// Useful when you don't want to clear the result of the previous operation while
  /// executing the new operation.
  ObservableFuture<T> replace(Future<T> nextFuture) =>
      ObservableFuture<T>._(_context, nextFuture, status, result);

  @override
  ObservableStream<T> asStream() =>
      ObservableStream._(_context, _future.asStream(), value, false);

  @override
  ObservableFuture<T> catchError(Function onError,
          {bool Function(Object error) test}) =>
      ObservableFuture._(_context, _future.catchError(onError, test: test),
          FutureStatus.pending, null);

  @override
  ObservableFuture<R> then<R>(FutureOr<R> Function(T value) onValue,
          {Function onError}) =>
      ObservableFuture._(_context, _future.then(onValue, onError: onError),
          FutureStatus.pending, null);

  @override
  ObservableFuture<T> timeout(Duration timeLimit,
          {FutureOr<T> Function() onTimeout}) =>
      ObservableFuture._(
          _context,
          _future.timeout(timeLimit, onTimeout: onTimeout),
          FutureStatus.pending,
          null);

  @override
  ObservableFuture<T> whenComplete(FutureOr Function() action) =>
      ObservableFuture._(
          _context, _future.whenComplete(action), FutureStatus.pending, null);
}
