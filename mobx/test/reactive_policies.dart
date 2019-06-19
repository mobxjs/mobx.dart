import 'package:test/test.dart';

void main() {
  group('when reactive-reads are enforced', () {
    test('should throw when reads happen OUTSIDE reactions', () {});

    test('should throw when reads happen OUTSIDE actions', () {});

    test('should NOT throw when reads happen INSIDE reactions', () {});

    test('should NOT throw when reads happen INSIDE actions', () {});
  });

  group('when reactive-reads are NOT enforced', () {
    test('should NOT throw when reads happen OUTSIDE reactions', () {});

    test('should NOT throw when reads happen OUTSIDE actions', () {});

    test('should NOT throw when reads happen INSIDE reactions', () {});

    test('should NOT throw when reads happen INSIDE actions', () {});
  });
}
