part of '../async.dart';

enum StreamStatus { waiting, active, done }

/// Stream that tracks the emitted values of the provided stream and makes
/// them available as a MobX observable value.
///
/// The latest events emitted by the stream are captured an made available as
/// MobX observable values via properties such as [data], [value], [error],
/// [hasError] and [status].
///
/// If the source `stream` is a single-subscription stream, this stream will
/// also be single-subscription. Either calling [listen] or observing [value],
/// etc. in a reaction will start the stream. Both can be done at the same time.
///
/// If the observation ends, and a subscription was never created via [listen],
/// the stream will be paused. If a subscription (created via [listen]) is
/// cancelled, the stream ends, and [value] etc. can no longer be observed
/// inside a reaction.
///
/// If the source `stream` is a broadcast stream, this stream will also be a
/// broadcast stream. This means the observable stream can be listened to
/// multiple times.
class ObservableStream<T> implements Stream<T>, ObservableValue<T?> {
  /// Create a stream that tracks the emitted values of the provided stream and
  /// makes them available as a MobX observable value.
  ///
  /// If the source `stream` is a single-subscription stream, this stream will
  /// also be single-subscription. If the source `stream` is a broadcast stream,
  /// this stream will also be a broadcast stream.
  ///
  /// If `initialValue` is provided, [value] will use it as the initial value
  /// while waiting for the first item to be emitted from the source stream.
  /// If the stream is a single-subscription stream, `initialValue` will also be
  /// the first value emitted to the subscription created by [listen].
  ///
  /// If `cancelOnError` is `true`, the stream will be cancelled when an error
  /// event is emitted by the source stream. The default value is `false`.
  ///
  /// It is possible to override equality comparison of new values with [equals].
  ObservableStream(
    Stream<T> stream, {
    T? initialValue,
    bool cancelOnError = false,
    ReactiveContext? context,
    String? name,
    EqualityComparer<dynamic>? equals,
  }) : this._(
         context ?? mainContext,
         stream,
         initialValue,
         cancelOnError,
         name,
         equals,
       );

  ObservableStream._(
    ReactiveContext context,
    this._stream,
    this._initialValue,
    this._cancelOnError,
    String? name,
    EqualityComparer<dynamic>? equals,
  ) : _context = context,
      _equals = equals {
    _name = name ?? _context.nameFor('ObservableStream<$T>');
  }

  T? _initialValue;
  final bool _cancelOnError;
  final ReactiveContext _context;
  final Stream<T> _stream;

  late String _name;

  String get name => _name;

  final EqualityComparer<dynamic>? _equals;

  _ObservableStreamController<T>? _controllerField;

  _ObservableStreamController<T> get _controller {
    if (_controllerField == null) {
      _controllerField = _ObservableStreamController<T>(
        _context,
        _stream,
        _initialValue,
        cancelOnError: _cancelOnError,
        name: '$name.StreamController',
        equals: _equals,
      );
      _initialValue = null;
    }
    return _controllerField!;
  }

  // Current value or error if failed.
  dynamic get data => _controller.data;

  /// Current value or null if waiting and no initialValue, or null if data is an error.
  @override
  T? get value =>
      _controller.valueType == _ValueType.value && _controller.data != null
          ? _controller.data as T
          : null;

  /// Current error or null if not failed.
  dynamic get error =>
      _controller.valueType == _ValueType.error ? _controller.data : null;

  /// Current data is an error.
  bool get hasError => _controller.valueType == _ValueType.error;

  /// Current stream status.
  StreamStatus get status => _controller.status;

  /// Maps the current status and value or error into a value.
  ///
  /// Returns null if a callback is not provided for the active status.
  /// If [done] is null, [active] and [error] are used instead.
  R? match<R>({
    R Function()? waiting,
    R Function(T)? active,
    // ignore:avoid_annotating_with_dynamic
    R Function(dynamic)? error,
    // ignore:avoid_annotating_with_dynamic
    R Function(T?, dynamic)? done,
  }) {
    final status = _controller.status;
    if (status == StreamStatus.waiting) {
      return waiting == null ? null : waiting();
    }

    final data = _controller.data;
    final hasValue = _controller.valueType == _ValueType.value;
    final overrideDone = status == StreamStatus.done && done == null;
    final isActive = status == StreamStatus.active;

    if (isActive || overrideDone) {
      if (hasValue) {
        return active == null ? null : active(data as T);
      } else {
        return error == null ? null : error(data);
      }
    }
    return hasValue ? done!(data as T, null) : done!(null, data);
  }

  /// Create a new stream with the provided initialValue and cancelOnError.
  ObservableStream<T> configure({
    T? initialValue,
    bool cancelOnError = false,
  }) => ObservableStream._(
    _context,
    _stream,
    initialValue,
    cancelOnError,
    name,
    _equals,
  );

  ObservableStream<R> _wrap<R>(
    Stream<R> stream, {
    EqualityComparer<dynamic>? equals,
  }) => ObservableStream._(
    _context,
    stream,
    null,
    _cancelOnError,
    name,
    _equals ?? equals,
  );

  ObservableFuture<R> _wrapFuture<R>(Future<R> future) =>
      ObservableFuture._(_context, future, FutureStatus.pending, null, name);

  /// Close the observable stream, and stop any future updates to observable
  /// properties or any stream subscribers.
  ///
  /// Most of the time, this method doesn't need to be called. ObservableStream
  /// can clean-up automatically. This is always true if the original stream
  /// is a broadcast stream.
  ///
  /// However, if the original stream is a single-subscription stream and you
  /// previously observed the stream's properties ([data], [value], [error],
  /// [hasError], [status], etc.) but then stopped the observation (thereby
  /// pausing the stream), then this method can be used to ensure the original
  /// paused stream closes correctly.
  ///
  /// Note that if you [listen] to this observable stream, the observable stream
  /// will be closed automatically when you cancel the subscription.
  Future<void> close() => _controller.close();

  // Delegated methods

  @override
  ObservableFuture<bool> any(bool Function(T element) test) =>
      _wrapFuture(_controller.stream.any(test));

  @override
  ObservableStream<T> asBroadcastStream({
    void Function(StreamSubscription<T> subscription)? onListen,
    void Function(StreamSubscription<T> subscription)? onCancel,
  }) => _wrap(
    _controller.stream.asBroadcastStream(
      onListen: onListen,
      onCancel: onCancel,
    ),
  );

  @override
  ObservableStream<E> asyncExpand<E>(Stream<E>? Function(T event) convert) =>
      _wrap(_controller.stream.asyncExpand(convert));

  @override
  ObservableStream<E> asyncMap<E>(FutureOr<E> Function(T event) convert) =>
      _wrap(_controller.stream.asyncMap(convert));

  @override
  ObservableStream<R> cast<R>() => _wrap(_controller.stream.cast());

  @override
  ObservableFuture<bool> contains(Object? needle) =>
      _wrapFuture(_controller.stream.contains(needle));

  @override
  ObservableStream<T> distinct([bool Function(T previous, T next)? equals]) =>
      _wrap(_controller.stream.distinct(equals));

  @override
  ObservableFuture<E> drain<E>([E? futureValue]) =>
      _wrapFuture(_controller.stream.drain(futureValue));

  @override
  ObservableFuture<T> elementAt(int index) =>
      _wrapFuture(_controller.stream.elementAt(index));

  @override
  ObservableFuture<bool> every(bool Function(T element) test) =>
      _wrapFuture(_controller.stream.every(test));

  @override
  ObservableStream<S> expand<S>(Iterable<S> Function(T element) convert) =>
      _wrap(_controller.stream.expand(convert));

  @override
  ObservableFuture<T> get first => _wrapFuture(_controller.stream.first);

  @override
  ObservableFuture<T> firstWhere(
    bool Function(T element) test, {
    T Function()? orElse,
  }) => _wrapFuture(_controller.stream.firstWhere(test, orElse: orElse));

  @override
  ObservableFuture<S> fold<S>(
    S initialValue,
    S Function(S previous, T element) combine,
  ) => _wrapFuture(_controller.stream.fold(initialValue, combine));

  @override
  ObservableFuture forEach(void Function(T element) action) =>
      _wrapFuture(_controller.stream.forEach(action));

  @override
  ObservableStream<T> handleError(
    Function onError, {
    // ignore:avoid_annotating_with_dynamic
    bool Function(dynamic)? test,
  }) => _wrap(_controller.stream.handleError(onError, test: test));

  @override
  bool get isBroadcast => _controller.stream.isBroadcast;

  @override
  ObservableFuture<bool> get isEmpty => _wrapFuture(_controller.stream.isEmpty);

  @override
  ObservableFuture<String> join([String separator = '']) =>
      _wrapFuture(_controller.stream.join(separator));

  @override
  ObservableFuture<T> get last => _wrapFuture(_controller.stream.last);

  @override
  ObservableFuture<T> lastWhere(
    bool Function(T element) test, {
    T Function()? orElse,
  }) => _wrapFuture(_controller.stream.lastWhere(test, orElse: orElse));

  @override
  ObservableFuture<int> get length => _wrapFuture(_controller.stream.length);

  @override
  StreamSubscription<T> listen(
    void Function(T value)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    if (_controller.isCancelled) {
      throw StateError(
        'Tried to observe or listen to an observable stream '
        'after the stream has already ended / closed.',
      );
    }
    return _controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  ObservableStream<S> map<S>(S Function(T event) convert) =>
      _wrap(_controller.stream.map(convert));

  @override
  ObservableFuture pipe(StreamConsumer<T> streamConsumer) =>
      _wrapFuture(_controller.stream.pipe(streamConsumer));

  @override
  ObservableFuture<T> reduce(T Function(T previous, T element) combine) =>
      _wrapFuture(_controller.stream.reduce(combine));

  @override
  ObservableFuture<T> get single => _wrapFuture(_controller.stream.single);

  @override
  ObservableFuture<T> singleWhere(
    bool Function(T element) test, {
    T Function()? orElse,
  }) => _wrapFuture(_controller.stream.singleWhere(test, orElse: orElse));

  @override
  ObservableStream<T> skip(int count) => _wrap(_controller.stream.skip(count));

  @override
  ObservableStream<T> skipWhile(bool Function(T element) test) =>
      _wrap(_controller.stream.skipWhile(test));

  @override
  ObservableStream<T> take(int count) => _wrap(_controller.stream.take(count));

  @override
  ObservableStream<T> takeWhile(bool Function(T element) test) =>
      _wrap(_controller.stream.takeWhile(test));

  @override
  ObservableStream<T> timeout(
    Duration timeLimit, {
    void Function(EventSink<T> sink)? onTimeout,
  }) => _wrap(_controller.stream.timeout(timeLimit, onTimeout: onTimeout));

  @override
  ObservableFuture<List<T>> toList() =>
      _wrapFuture(_controller.stream.toList());

  @override
  ObservableFuture<Set<T>> toSet() => _wrapFuture(_controller.stream.toSet());

  @override
  ObservableStream<S> transform<S>(StreamTransformer<T, S> streamTransformer) =>
      _wrap(_controller.stream.transform(streamTransformer));

  @override
  ObservableStream<T> where(bool Function(T event) test) =>
      _wrap(_controller.stream.where(test));
}

enum _ValueType { value, error }

class _ObservableStreamController<T> {
  _ObservableStreamController(
    ReactiveContext context,
    this.origStream,
    T? initialValue, {
    required this.cancelOnError,
    required this.name,
    EqualityComparer<dynamic>? equals,
  }) : _initialStreamValue = origStream.isBroadcast ? null : initialValue,
       _actions = ActionController(
         context: context,
         name: '$name.ActionController',
       ),
       _status = Observable(
         initialValue == null ? StreamStatus.waiting : StreamStatus.active,
         context: context,
         name: '$name.status',
       ),
       _valueType = Observable(
         _ValueType.value,
         context: context,
         name: '$name.valueType',
       ),
       _data = Observable<dynamic>(
         initialValue,
         context: context,
         name: '$name.data',
         equals: equals,
       ) {
    _status
      ..onBecomeObserved(_listen)
      ..onBecomeUnobserved(_unsubscribe);
    _valueType
      ..onBecomeObserved(_listen)
      ..onBecomeUnobserved(_unsubscribe);
    _data
      ..onBecomeObserved(_listen)
      ..onBecomeUnobserved(_unsubscribe);
    _controller =
        origStream.isBroadcast
            ? StreamController<T>.broadcast(
              onListen: _listen,
              onCancel: _unsubscribe,
              sync: true,
            )
            : StreamController<T>(
              onListen: _listen,
              onPause: _unsubscribe,
              onResume: _listen,
              onCancel: _onCancel,
              sync: true,
            );
  }

  final String name;
  final bool cancelOnError;
  final Stream<T> origStream;
  StreamSubscription<T>? _subscription;
  T? _initialStreamValue;

  final ActionController _actions;

  final Observable<_ValueType> _valueType;

  _ValueType get valueType => _valueType.value;

  final Observable _data;

  dynamic get data => _data.value;

  final Observable<StreamStatus> _status;

  StreamStatus get status => _status.value;

  late final Stream<T> stream = _controller.stream;
  late final StreamController<T> _controller;

  int _listenCount = 0;
  bool _isCancelled = false;

  bool get isCancelled => _isCancelled;

  Future<void> _onCancel() async {
    _unsubscribe();
    await close();
  }

  Future<void> close() async {
    _isCancelled = true;

    await _subscription?.cancel();
    _subscription = null;

    // controller.close() never completes if it's a non-broadcast stream
    // with no listeners. Avoid this case.
    if (origStream.isBroadcast || _controller.hasListener) {
      await _controller.close();
    }
  }

  void _listen() {
    _listenCount++;
    if (_subscription == null) {
      if (_isCancelled) {
        throw StateError(
          'Tried to observe or listen to an observable stream '
          'after the stream has already ended / closed.',
        );
      }
      _subscription = origStream.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: cancelOnError,
      );

      scheduleMicrotask(_tryInsertInitialValue);
    } else if (_subscription!.isPaused) {
      _subscription!.resume();
    }
  }

  void _unsubscribe() {
    if (_isCancelled) {
      return;
    }

    _listenCount--;
    if (_listenCount == 0 && !(_subscription?.isPaused ?? true)) {
      if (origStream.isBroadcast) {
        _subscription!.cancel();
        _subscription = null;
      } else {
        _subscription!.pause();
      }
    }
  }

  void _onData(T data) {
    final actionInfo = _actions.startAction();
    try {
      _status.value = StreamStatus.active;
      _valueType.value = _ValueType.value;
      _data.value = data;
    } finally {
      _actions.endAction(actionInfo);
      _tryInsertInitialValue();
      _controller.add(data);
    }
  }

  void _onError(Object error) {
    final actionInfo = _actions.startAction();
    try {
      _status.value = StreamStatus.active;
      _valueType.value = _ValueType.error;
      _data.value = error;
    } finally {
      _actions.endAction(actionInfo);
      _tryInsertInitialValue();
      _controller.addError(error);
    }
  }

  void _onDone() {
    final actionInfo = _actions.startAction();
    try {
      _status.value = StreamStatus.done;
    } finally {
      _actions.endAction(actionInfo);
      _tryInsertInitialValue();
      _controller.close();
    }
  }

  void _tryInsertInitialValue() {
    final initialStreamValue = _initialStreamValue;
    if (initialStreamValue != null) {
      _initialStreamValue = null;
      _controller.add(initialStreamValue);
    }
  }
}
