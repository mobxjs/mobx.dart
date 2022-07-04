import 'dart:async';

import 'package:mobx/src/api/async.dart';
import 'package:mobx/src/api/extensions.dart';
import 'package:test/test.dart';

import '../util.dart';

void main() {
  testSetup();

  group('ObservableStreamExtension', () {
    test('Transform Stream in ObservableStream', () async {
      const stream = Stream.empty();
      expect(stream.asObservable(), isA<ObservableStream>());
    });

    test('Transform Stream in ObservableStream (Use .asObs)', () async {
      const stream = Stream.empty();
      expect(stream.asObs, isA<ObservableStream>());
    });
  });
}
