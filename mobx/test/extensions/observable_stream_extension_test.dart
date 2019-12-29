import 'dart:async';

import 'package:mobx/src/api/async.dart';
import 'package:mobx/src/api/extensions.dart';
import 'package:test/test.dart';

void main() {
  group('ObservableStreamExtension', () {
    test('Transform Stream in ObservableStream', () async {
      const stream = Stream.empty();
      expect(stream.asObservable(), isA<ObservableStream>());
    });
  });
}
