import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mobx/src/api/context.dart';
import 'package:mobx/src/core.dart';

@experimental
enum StreamStatus { waiting, value, done, error }

enum _ValueType { value, error }

@experimental
class ObservableStream<T> implements Stream<T> {
  ObservableStream(Stream<T> stream,
      {T initialValue, bool cancelOnError, ReactiveContext context})
      : this._(context ?? mainContext, stream.asBroadcastStream(), initialValue,
            cancelOnError);

  ObservableStream._(
      ReactiveContext context, this._stream, T initialValue, bool cancelOnError)
      : _status = Observable(
            initialValue == null ? StreamStatus.waiting : StreamStatus.value,
            context: context),
        _actions = ActionController(
            name: context.nameFor('ObservableStream<$T>'), context: context),
        _data = Observable(initialValue, context: context) {
    _stream.listen(_onData,
        onDone: _onDone, onError: _onError, cancelOnError: cancelOnError);
  }

  final ActionController _actions;
  final Observable<StreamStatus> _status;
  _ValueType _valueType = _ValueType.value;
  final Observable _data;
  final Stream<T> _stream;

  // Current value or error if failed.
  dynamic get data => _data.value;

  /// Current value or null if no initialValue and stream hasn't provided a new value yet.
  T get value => _status.value == StreamStatus.error ? null : _data.value;

  /// Current error or null if not failed.
  dynamic get error => _status.value == StreamStatus.error ? _data.value : null;

  /// Current stream status.
  StreamStatus get status => _status.value;

  /// Maps the current status and value or error into a value.
  ///
  /// Returns null if a callback is not provided for the active status.
  /// If [done] is null, [value] and [error] are used instead.
  R match<R>(
      {R Function() waiting,
      R Function(T) value,
      // ignore:avoid_annotating_with_dynamic
      R Function(dynamic) error,
      // ignore:avoid_annotating_with_dynamic
      R Function(dynamic) done}) {
    final data = _data.value;
    final status = _status.value;

    if (status == StreamStatus.waiting) {
      return waiting == null ? null : waiting();
    } else if (status == StreamStatus.value ||
        (status == StreamStatus.done &&
            _valueType == _ValueType.value &&
            done == null)) {
      return value == null ? null : value(data);
    } else if (status == StreamStatus.error ||
        (status == StreamStatus.done &&
            _valueType == _ValueType.error &&
            done == null)) {
      return error == null ? null : error(data);
    }
    return done(data);
  }

  void _onData(T data) {
    final prevDerivation = _actions.startAction();
    try {
      _status.value = StreamStatus.value;
      _valueType = _ValueType.value;
      _data.value = data;
    } finally {
      _actions.endAction(prevDerivation);
    }
  }

  void _onDone() {
    final prevDerivation = _actions.startAction();
    try {
      _status.value = StreamStatus.done;
    } finally {
      _actions.endAction(prevDerivation);
    }
  }

  void _onError(error) {
    final prevDerivation = _actions.startAction();
    try {
      _status.value = StreamStatus.error;
      _valueType = _ValueType.error;
      _data.value = error;
    } finally {
      _actions.endAction(prevDerivation);
    }
  }

  // Delegated methods

  @override
  Future<bool> any(bool Function(T element) test) => _stream.any(test);

  @override
  Stream<T> asBroadcastStream(
          {void Function(StreamSubscription<T> subscription) onListen,
          void Function(StreamSubscription<T> subscription) onCancel}) =>
      _stream.asBroadcastStream(onListen: onListen, onCancel: onCancel);

  @override
  Stream<E> asyncExpand<E>(Stream<E> Function(T event) convert) =>
      _stream.asyncExpand(convert);

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(T event) convert) =>
      _stream.asyncMap(convert);

  @override
  Stream<R> cast<R>() => _stream.cast();

  @override
  Future<bool> contains(Object needle) => _stream.contains(needle);

  @override
  Stream<T> distinct([bool Function(T previous, T next) equals]) =>
      _stream.distinct(equals);

  @override
  Future<E> drain<E>([E futureValue]) => _stream.drain(futureValue);

  @override
  Future<T> elementAt(int index) => _stream.elementAt(index);

  @override
  Future<bool> every(bool Function(T element) test) => _stream.every(test);

  @override
  Stream<S> expand<S>(Iterable<S> Function(T element) convert) =>
      _stream.expand(convert);

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
  Stream<T> handleError(Function onError,
          // ignore:avoid_annotating_with_dynamic
          {bool Function(dynamic) test}) =>
      _stream.handleError(onError, test: test);

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
          {Function onError, void Function() onDone, bool cancelOnError}) =>
      _stream.listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);

  @override
  Stream<S> map<S>(S Function(T event) convert) => _stream.map(convert);

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
  Stream<T> skip(int count) => _stream.skip(count);

  @override
  Stream<T> skipWhile(bool Function(T element) test) => _stream.skipWhile(test);

  @override
  Stream<T> take(int count) => _stream.take(count);

  @override
  Stream<T> takeWhile(bool Function(T element) test) => _stream.takeWhile(test);

  @override
  Stream<T> timeout(Duration timeLimit,
          {void Function(EventSink<T> sink) onTimeout}) =>
      _stream.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<List<T>> toList() => _stream.toList();

  @override
  Future<Set<T>> toSet() => _stream.toSet();

  @override
  Stream<S> transform<S>(StreamTransformer<T, S> streamTransformer) =>
      _stream.transform(streamTransformer);

  @override
  Stream<T> where(bool Function(T event) test) => _stream.where(test);
}
