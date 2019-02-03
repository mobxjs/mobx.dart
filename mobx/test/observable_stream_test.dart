import 'dart:async';

import 'package:mobx/src/api/observable_stream.dart';
import 'package:mobx/src/api/reaction.dart';
import 'package:test/test.dart';

void main() {
  group('ObservableStream', () {
    test('match works', () async {
      // ignore:close_sinks
      final ctrl = StreamController<int>.broadcast();
      final stream = ObservableStream(ctrl.stream);

      String getValue() => stream.match(
            waiting: () => 'waiting',
            value: (i) => 'value',
            done: (_) => 'done',
            error: (err) => 'error',
          );

      expect(getValue(), equals('waiting'));

      ctrl.add(1);
      await asyncWhen((_) => stream.value == 1);
      expect(getValue(), equals('value'));

      ctrl.addError('ERROR');
      await asyncWhen((_) => stream.error == 'ERROR');
      expect(getValue(), equals('error'));

      await ctrl.close();
      expect(getValue(), equals('done'));
    });

    test('omitting done in match uses value instead for values', () async {
      // ignore:close_sinks
      final ctrl = StreamController<int>.broadcast();
      final stream = ObservableStream(ctrl.stream);

      String getValue() => stream.match(
            value: (i) => 'value/done',
          );

      ctrl.add(1);
      await asyncWhen((_) => stream.value == 1);
      expect(getValue(), equals('value/done'));

      await ctrl.close();
      expect(getValue(), equals('value/done'));
    });

    test('omitting done in match uses error instead for errors', () async {
      // ignore:close_sinks
      final ctrl = StreamController<int>.broadcast();
      final stream = ObservableStream(ctrl.stream);

      String getValue() => stream.match(
            error: (i) => 'error/done',
          );

      ctrl.addError('ERROR');
      await asyncWhen((_) => stream.error == 'ERROR');
      expect(getValue(), equals('error/done'));

      await ctrl.close();
      expect(getValue(), equals('error/done'));
    });

    test('providing no initialValue sets initial status to waiting', () async {
      final stream = ObservableStream(() async* {
        yield 1;
      }());

      expect(stream.status, equals(StreamStatus.waiting));
      expect(stream.value, equals(null));
    });

    test('providing initialValue sets initial status to value', () async {
      final stream = ObservableStream(() async* {
        yield 1;
      }(), initialValue: 0);

      expect(stream.status, equals(StreamStatus.value));
      expect(stream.value, equals(0));
    });
  });
}
