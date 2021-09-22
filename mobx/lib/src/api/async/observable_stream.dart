part of '../async.dart';

enum StreamStatus { waiting, active, done }

class ObservableStream<T> extends StreamView<T> implements ObservableValue<T?> {
  ObservableStream(
    Stream<T> stream, {
    T? initialValue,
    bool cancelOnError = false,
    ReactiveContext? context,
    String? name,
  }) : this._(
          context ?? mainContext,
          stream,
          initialValue,
          cancelOnError,
          name,
        );

  ObservableStream._(
    ReactiveContext context,
    Stream<T> stream,
    T? initialValue,
    bool cancelOnError,
    String? name,
  ) : this._controller(
          context,
          _ObservableStreamController<T>(
            context,
            stream,
            initialValue,
            cancelOnError: cancelOnError,
            name: '${name ?? context.nameFor('ObservableStream<$T>')}'
                '.StreamController',
          ),
          name,
        );

  ObservableStream._controller(
    ReactiveContext context,
    this._controller,
    String? name,
  )   : _context = context,
        _name = name ?? context.nameFor('ObservableStream<$T>'),
        _stream = _controller.origStream,
        _cancelOnError = _controller.cancelOnError,
        super(_controller.stream);

  final bool _cancelOnError;
  final ReactiveContext _context;
  final Stream<T> _stream;

  late String _name;
  String get name => _name;

  final _ObservableStreamController<T> _controller;

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
  R? match<R>(
      {R Function()? waiting,
      R Function(T)? active,
      // ignore:avoid_annotating_with_dynamic
      R Function(dynamic)? error,
      // ignore:avoid_annotating_with_dynamic
      R Function(T?, dynamic)? done}) {
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
  ObservableStream<T> configure(
          {T? initialValue, bool cancelOnError = false}) =>
      ObservableStream._(_context, _stream, initialValue, cancelOnError, name);

  ObservableStream<R> _wrap<R>(Stream<R> stream) =>
      ObservableStream._(_context, stream, null, _cancelOnError, name);

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
  /// observed the stream's properties ([data], [value], [error], [hasError],
  /// [status], etc.), then this method can be used to stop the observation and
  /// ensure the original stream closes.
  ///
  /// Note that if you [listen] to this observable stream, the observable stream
  /// will be closed automatically when you cancel the subscription.
  Future<void> close() => _controller.close();

  // Delegated methods

  @override
  ObservableFuture<bool> any(bool Function(T element) test) =>
      _wrapFuture(super.any(test));

  @override
  ObservableStream<T> asBroadcastStream(
          {void Function(StreamSubscription<T> subscription)? onListen,
          void Function(StreamSubscription<T> subscription)? onCancel}) =>
      _wrap(super.asBroadcastStream(onListen: onListen, onCancel: onCancel));

  @override
  ObservableStream<E> asyncExpand<E>(Stream<E>? Function(T event) convert) =>
      _wrap(super.asyncExpand(convert));

  @override
  ObservableStream<E> asyncMap<E>(FutureOr<E> Function(T event) convert) =>
      _wrap(super.asyncMap(convert));

  @override
  ObservableStream<R> cast<R>() => _wrap(super.cast());

  @override
  ObservableFuture<bool> contains(Object? needle) =>
      _wrapFuture(super.contains(needle));

  @override
  ObservableStream<T> distinct([bool Function(T previous, T next)? equals]) =>
      _wrap(super.distinct(equals));

  @override
  ObservableFuture<E> drain<E>([E? futureValue]) =>
      _wrapFuture(super.drain(futureValue));

  @override
  ObservableFuture<T> elementAt(int index) =>
      _wrapFuture(super.elementAt(index));

  @override
  ObservableFuture<bool> every(bool Function(T element) test) =>
      _wrapFuture(super.every(test));

  @override
  ObservableStream<S> expand<S>(Iterable<S> Function(T element) convert) =>
      _wrap(super.expand(convert));

  @override
  ObservableFuture<T> get first => _wrapFuture(super.first);

  @override
  ObservableFuture<T> firstWhere(bool Function(T element) test,
          {T Function()? orElse}) =>
      _wrapFuture(super.firstWhere(test, orElse: orElse));

  @override
  ObservableFuture<S> fold<S>(
          S initialValue, S Function(S previous, T element) combine) =>
      _wrapFuture(super.fold(initialValue, combine));

  @override
  ObservableFuture forEach(void Function(T element) action) =>
      _wrapFuture(super.forEach(action));

  @override
  ObservableStream<T> handleError(Function onError,
          // ignore:avoid_annotating_with_dynamic
          {bool Function(dynamic)? test}) =>
      _wrap(super.handleError(onError, test: test));

  @override
  bool get isBroadcast => super.isBroadcast;

  @override
  ObservableFuture<bool> get isEmpty => _wrapFuture(super.isEmpty);

  @override
  ObservableFuture<String> join([String separator = '']) =>
      _wrapFuture(super.join(separator));

  @override
  ObservableFuture<T> get last => _wrapFuture(super.last);

  @override
  ObservableFuture<T> lastWhere(bool Function(T element) test,
          {T Function()? orElse}) =>
      _wrapFuture(super.lastWhere(test, orElse: orElse));

  @override
  ObservableFuture<int> get length => _wrapFuture(super.length);

  @override
  StreamSubscription<T> listen(
    void Function(T value)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    if (_controller.isCancelled) {
      throw StateError('Tried to observe or listen to an observable stream '
          'after the stream has already ended / closed.');
    }
    return super.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  ObservableStream<S> map<S>(S Function(T event) convert) =>
      _wrap(super.map(convert));

  @override
  ObservableFuture pipe(StreamConsumer<T> streamConsumer) =>
      _wrapFuture(super.pipe(streamConsumer));

  @override
  ObservableFuture<T> reduce(T Function(T previous, T element) combine) =>
      _wrapFuture(super.reduce(combine));

  @override
  ObservableFuture<T> get single => _wrapFuture(super.single);

  @override
  ObservableFuture<T> singleWhere(bool Function(T element) test,
          {T Function()? orElse}) =>
      _wrapFuture(super.singleWhere(test, orElse: orElse));

  @override
  ObservableStream<T> skip(int count) => _wrap(super.skip(count));

  @override
  ObservableStream<T> skipWhile(bool Function(T element) test) =>
      _wrap(super.skipWhile(test));

  @override
  ObservableStream<T> take(int count) => _wrap(super.take(count));

  @override
  ObservableStream<T> takeWhile(bool Function(T element) test) =>
      _wrap(super.takeWhile(test));

  @override
  ObservableStream<T> timeout(Duration timeLimit,
          {void Function(EventSink<T> sink)? onTimeout}) =>
      _wrap(super.timeout(timeLimit, onTimeout: onTimeout));

  @override
  ObservableFuture<List<T>> toList() => _wrapFuture(super.toList());

  @override
  ObservableFuture<Set<T>> toSet() => _wrapFuture(super.toSet());

  @override
  ObservableStream<S> transform<S>(StreamTransformer<T, S> streamTransformer) =>
      _wrap(super.transform(streamTransformer));

  @override
  ObservableStream<T> where(bool Function(T event) test) =>
      _wrap(super.where(test));
}

enum _ValueType { value, error }

class _ObservableStreamController<T> {
  _ObservableStreamController(
    ReactiveContext context,
    this.origStream,
    T? initialValue, {
    required this.cancelOnError,
    required this.name,
  })  : _initialStreamValue = origStream.isBroadcast ? null : initialValue,
        _actions =
            ActionController(context: context, name: '$name.ActionController'),
        _status = Observable(
            initialValue == null ? StreamStatus.waiting : StreamStatus.active,
            context: context,
            name: '$name.status'),
        _valueType = Observable(_ValueType.value,
            context: context, name: '$name.valueType'),
        _data = Observable(initialValue, context: context, name: '$name.data') {
    _status
      ..onBecomeObserved(_listen)
      ..onBecomeUnobserved(_unsubscribe);
    _valueType
      ..onBecomeObserved(_listen)
      ..onBecomeUnobserved(_unsubscribe);
    _data
      ..onBecomeObserved(_listen)
      ..onBecomeUnobserved(_unsubscribe);
    _controller = origStream.isBroadcast
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
  StreamSubscription<T>? _broadcastSubscription;
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

    await _broadcastSubscription?.cancel();
    _broadcastSubscription = null;

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
        throw StateError('Tried to observe or listen to an observable stream '
            'after the stream has already ended / closed.');
      }
      _subscription = origStream.listen(_onData,
          onError: _onError, onDone: _onDone, cancelOnError: cancelOnError);

      if (origStream.isBroadcast) {
        void _noop(error) {}
        _broadcastSubscription = origStream.listen(null,
            onError: _noop, onDone: _onCancel, cancelOnError: cancelOnError);
      }

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
    if (_listenCount == 0 && !_subscription!.isPaused) {
      _subscription?.pause();
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
