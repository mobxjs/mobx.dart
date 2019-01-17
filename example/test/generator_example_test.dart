import 'package:example/src/generator_example.dart';
import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('@observable works', () {
      final user = User();

      var firstName = '';

      autorun((_) {
        firstName = user.firstName;
      });

      expect(firstName, equals('Jane'));

      user.firstName = 'Jill';
      expect(firstName, equals('Jill'));
    });

    test('@computed works', () {
      final user = User();

      var fullName = '';

      autorun((_) {
        fullName = user.fullName;
      });

      expect(fullName, equals('Jane Doe'));

      user.firstName = 'John';
      expect(fullName, equals('John Doe'));

      user.lastName = 'Addams';
      expect(fullName, equals('John Addams'));
    });
  });
}
