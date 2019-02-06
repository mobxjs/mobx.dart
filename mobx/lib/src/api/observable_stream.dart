import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mobx/src/api/context.dart';
import 'package:mobx/src/core.dart';

@experimental
enum StreamStatus { waiting, active, done }

@experimental
class ObservableStream<T> implements Stream<T> {
  ObservableStream(Stream<T> stream,
      {T initialValue, bool cancelOnError = false, ReactiveContext context})
      : this._(context ?? mainContext, stream, initialValue, cancelOnError);

  ObservableStream._(ReactiveContext context, this._stream, this._initialValue,
      this._cancelOnError)
      : _context = context;

  T _initialValue;
  final bool _cancelOnError;
  final ReactiveContext _context;
  final Stream<T> _stream;

  _ObservableStreamController<T> _controllerField;
  _ObservableStreamController<T> get _controller {
    if (_controllerField == null) {
      _controllerField = _ObservableStreamController<T>(
          _context, _stream, _initialValue,
          cancelOnError: _cancelOnError);
      _initialValue = null;
    }
    return _controllerField;
  }

  // Current value or error if failed.
  dynamic get data => _controller.data;

  /// Current value or null if waiting and no initialValue, or null if data is an error.
  T get value =>
      _controller.valueType == _ValueType.value ? _controller.data : null;

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
  R match<R>(
      {R Function() waiting,
      R Function(T) active,
      // ignore:avoid_annotating_with_dynamic
      R Function(dynamic) error,
      // ignore:avoid_annotating_with_dynamic
      R Function(T, dynamic) done}) {
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
        return active == null ? null : active(data);
      } else {
        return error == null ? null : error(data);
      }
    }
    return hasValue ? done(data, null) : done(null, data);
  }

  /// Create a new stream with the provided initialValue and cancelOnError.
  ObservableStream<T> configure({T initialValue, bool cancelOnError = false}) =>
      ObservableStream._(_context, _stream, initialValue, cancelOnError);

  ObservableStream<R> _wrap<R>(Stream<R> stream) =>
      ObservableStream._(_context, stream, null, _cancelOnError);

  // Delegated methods

  @override
  Future<bool> any(bool Function(T element) test) => _stream.any(test);

  @override
  ObservableStream<T> asBroadcastStream(
          {void Function(StreamSubscription<T> subscription) onListen,
          void Function(StreamSubscription<T> subscription) onCancel}) =>
      _wrap(_stream.asBroadcastStream(onListen: onListen, onCancel: onCancel));

  @override
  ObservableStream<E> asyncExpand<E>(Stream<E> Function(T event) convert) =>
      _wrap(_stream.asyncExpand(convert));

  @override
  ObservableStream<E> asyncMap<E>(FutureOr<E> Function(T event) convert) =>
      _wrap(_stream.asyncMap(convert));

  @override
  ObservableStream<R> cast<R>() => _wrap(_stream.cast());

  @override
  Future<bool> contains(Object needle) => _stream.contains(needle);

  @override
  ObservableStream<T> distinct([bool Function(T previous, T next) equals]) =>
      _wrap(_stream.distinct(equals));

  @override
  Future<E> drain<E>([E futureValue]) => _stream.drain(futureValue);

  @override
  Future<T> elementAt(int index) => _stream.elementAt(index);

  @override
  Future<bool> every(bool Function(T element) test) => _stream.every(test);

  @override
  ObservableStream<S> expand<S>(Iterable<S> Function(T element) convert) =>
      _wrap(_stream.expand(convert));

  @override
  Future<T> get first => _stream.first;

  @override
  Future<T> firstWhere(bool Function(T element) test, {T Function() orElse}) =>
      _stream.firstWhere(test, orElse: orElse);

  @override
  Future<S> fold<S>(
          S initialValue, S Function(S previous, T element) combine) =>
      _stream.fold(initialValue, combine);

  @override
  Future forEach(void Function(T element) action) => _stream.forEach(action);

  @override
  ObservableStream<T> handleError(Function onError,
          // ignore:avoid_annotating_with_dynamic
          {bool Function(dynamic) test}) =>
      _wrap(_stream.handleError(onError, test: test));

  @override
  bool get isBroadcast => _stream.isBroadcast;

  @override
  Future<bool> get isEmpty => _stream.isEmpty;

  @override
  Future<String> join([String separator = '']) => _stream.join(separator);

  @override
  Future<T> get last => _stream.last;

  @override
  Future<T> lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _stream.lastWhere(test, orElse: orElse);

  @override
  Future<int> get length => _stream.length;

  @override
  StreamSubscription<T> listen(void Function(T event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    final sub = _stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
    return sub;
  }

  @override
  ObservableStream<S> map<S>(S Function(T event) convert) =>
      _wrap(_stream.map(convert));

  @override
  Future pipe(StreamConsumer<T> streamConsumer) => _stream.pipe(streamConsumer);

  @override
  Future<T> reduce(T Function(T previous, T element) combine) =>
      _stream.reduce(combine);

  @override
  Future<T> get single => _stream.single;

  @override
  Future<T> singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      _stream.singleWhere(test, orElse: orElse);

  @override
  ObservableStream<T> skip(int count) => _wrap(_stream.skip(count));

  @override
  ObservableStream<T> skipWhile(bool Function(T element) test) =>
      _wrap(_stream.skipWhile(test));

  @override
  ObservableStream<T> take(int count) => _wrap(_stream.take(count));

  @override
  ObservableStream<T> takeWhile(bool Function(T element) test) =>
      _wrap(_stream.takeWhile(test));

  @override
  ObservableStream<T> timeout(Duration timeLimit,
          {void Function(EventSink<T> sink) onTimeout}) =>
      _wrap(_stream.timeout(timeLimit, onTimeout: onTimeout));

  @override
  Future<List<T>> toList() => _stream.toList();

  @override
  Future<Set<T>> toSet() => _stream.toSet();

  @override
  ObservableStream<S> transform<S>(StreamTransformer<T, S> streamTransformer) =>
      _wrap(_stream.transform(streamTransformer));

  @override
  ObservableStream<T> where(bool Function(T event) test) =>
      _wrap(_stream.where(test));
}

enum _ValueType { value, error }

class _ObservableStreamController<T> {
  _ObservableStreamController(
      ReactiveContext context, this._stream, T initialValue,
      {bool cancelOnError = false})
      : _actions = ActionController(
            context: context, name: context.nameFor('ObservableStream<$T>')),
        _status = Observable(
            initialValue == null ? StreamStatus.waiting : StreamStatus.active,
            context: context,
            name: context.nameFor('ObservableStream<$T>.status')),
        _valueType = Observable(_ValueType.value,
            context: context,
            name: context.nameFor('ObservableStream<$T>.valueType')),
        _data = Observable(initialValue,
            context: context,
            name: context.nameFor('ObservableStream<$T>.data')),
        _cancelOnError = cancelOnError {
    _status
      ..onBecomeObserved(_listen)
      ..onBecomeUnobserved(_unsubscribe);
    _valueType
      ..onBecomeObserved(_listen)
      ..onBecomeUnobserved(_unsubscribe);
    _data
      ..onBecomeObserved(_listen)
      ..onBecomeUnobserved(_unsubscribe);
  }

  final bool _cancelOnError;
  final Stream<T> _stream;
  StreamSubscription<T> _subscription;

  final ActionController _actions;

  Observable<_ValueType> _valueType;
  _ValueType get valueType => _valueType.value;

  Observable _data;
  dynamic get data => _data.value;

  Observable<StreamStatus> _status;
  StreamStatus get status => _status.value;

  int _listenCount = 0;

  void _listen() {
    _listenCount++;
    if (_subscription == null) {
      _subscription = _stream.listen(_onData,
          onError: _onError, onDone: _onDone, cancelOnError: _cancelOnError);
    } else if (_subscription.isPaused) {
      _subscription.resume();
    }
  }

  // TODO(katis): Doesn't take into account subscriptions made with ObservableStream.listen
  void _unsubscribe() {
    _listenCount--;
    if (_listenCount == 0 && !_subscription.isPaused) {
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
    }
  }

  void _onError(error) {
    final actionInfo = _actions.startAction();
    try {
      _status.value = StreamStatus.active;
      _valueType.value = _ValueType.error;
      _data.value = error;
    } finally {
      _actions.endAction(actionInfo);
    }
  }

  void _onDone() {
    final actionInfo = _actions.startAction();
    try {
      _status.value = StreamStatus.done;
    } finally {
      _actions.endAction(actionInfo);
    }
  }
}
