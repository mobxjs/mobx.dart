part of '../async.dart';

enum FutureStatus { pending, rejected, fulfilled }

class FutureResult<T> {
  FutureResult(
    ReactiveContext context,
    Future<T> future,
    dynamic initialResult,
    FutureStatus initialStatus,
    String name,
  ) : _axnController = ActionController(
        context: context,
        name: '$name.ActionController',
      ),
      _status = Observable(initialStatus, name: '$name.status'),
      _result = Observable<dynamic>(initialResult, name: '$name.result') {
    future.then(_fulfill, onError: _reject);
  }

  final ActionController _axnController;

  final Observable<FutureStatus> _status;
  FutureStatus get status => _status.value;

  final Observable _result;
  dynamic get result => _result.value;

  void _fulfill(T value) {
    final prevDerivation = _axnController.startAction();
    try {
      _status.value = FutureStatus.fulfilled;
      _result.value = value;
    } finally {
      _axnController.endAction(prevDerivation);
    }
  }

  void _reject(dynamic error) {
    final prevDerivation = _axnController.startAction();
    try {
      _status.value = FutureStatus.rejected;
      _result.value = error;
    } finally {
      _axnController.endAction(prevDerivation);
    }
  }
}

class ObservableFuture<T> implements Future<T>, ObservableValue<T?> {
  /// Create a new observable future that tracks the state of the provided future.
  ObservableFuture(Future<T> future, {ReactiveContext? context, String? name})
    : this._(context ?? mainContext, future, FutureStatus.pending, null, name);

  /// Create a new future that is completed with a value.
  ///
  /// [status] is immediately [FutureStatus.fulfilled].
  ObservableFuture.value(T value, {ReactiveContext? context, String? name})
    : this._(
        context ?? mainContext,
        Future.value(value),
        FutureStatus.fulfilled,
        value,
        name,
      );

  /// Create a new future that is completed with an error.
  ///
  /// [status] is immediately [FutureStatus.rejected].
  ObservableFuture.error(Object error, {ReactiveContext? context, String? name})
    : this._(
        context ?? mainContext,
        Future.error(error),
        FutureStatus.rejected,
        error,
        name,
      );

  ObservableFuture._(
    this._context,
    this._future,
    FutureStatus initialStatus,
    dynamic initialResult,
    String? name,
  ) {
    _name = name ?? _context.nameFor('ObservableFuture<$T>');
    // create the result up-front instead of being lazy
    _result = FutureResult(
      _context,
      _future,
      initialResult,
      initialStatus,
      _name,
    );
  }

  final ReactiveContext _context;
  Future<T> _future;

  late FutureResult<T> _result;

  late String _name;
  String get name => _name;

  /// Observable status of this.
  FutureStatus get status => _result.status;

  /// Value if this completed with a value.
  ///
  /// Null otherwise.
  @override
  T? get value => status == FutureStatus.fulfilled ? _result.result as T : null;

  /// Error value if this completed with an error
  ///
  /// Null otherwise.
  dynamic get error => status == FutureStatus.rejected ? _result.result : null;

  /// Error or value of this.
  ///
  /// Null if this hasn't yet completed.
  dynamic get result => _result.result;

  /// Maps the current state of this.
  ///
  /// Returns null if a handler for the current state is not provided.
  R? match<R>({
    R Function(T)? fulfilled,
    // ignore:avoid_annotating_with_dynamic
    R Function(dynamic)? rejected,
    R Function()? pending,
  }) {
    final status = this.status;

    if (status == FutureStatus.fulfilled) {
      return fulfilled == null ? null : fulfilled(result as T);
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
      ObservableFuture<T>._(_context, nextFuture, status, result, name);

  @override
  ObservableStream<T> asStream() => ObservableStream._(
    _context,
    _future.asStream(),
    value,
    false,
    '${name}_asStream',
    null,
  );

  @override
  ObservableFuture<T> catchError(
    Function onError, {
    bool Function(Object error)? test,
  }) => ObservableFuture._(
    _context,
    _future.catchError(onError, test: test),
    FutureStatus.pending,
    null,
    name,
  );

  @override
  ObservableFuture<R> then<R>(
    FutureOr<R> Function(T value) onValue, {
    Function? onError,
  }) => ObservableFuture._(
    _context,
    _future.then(onValue, onError: onError),
    FutureStatus.pending,
    null,
    name,
  );

  @override
  ObservableFuture<T> timeout(
    Duration timeLimit, {
    FutureOr<T> Function()? onTimeout,
  }) => ObservableFuture._(
    _context,
    _future.timeout(timeLimit, onTimeout: onTimeout),
    FutureStatus.pending,
    null,
    name,
  );

  @override
  ObservableFuture<T> whenComplete(FutureOr Function() action) =>
      ObservableFuture._(
        _context,
        _future.whenComplete(action),
        FutureStatus.pending,
        null,
        name,
      );
}
