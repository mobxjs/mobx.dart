import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

import 'util.dart';

// Custom class for testing equals
class Person {
  final String name;
  final int age;

  Person(this.name, this.age);

  @override
  String toString() => 'Person($name, $age)';
}

void main() {
  testSetup();

  group('ObservableList with custom equals', () {
    test('uses custom equals for value comparisons', () {
      // Custom equals that only compares names
      bool nameEquals(Person? a, Person? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a.name == b.name;
      }

      final list = ObservableList<Person>(equals: nameEquals);
      var changeCount = 0;

      final dispose = autorun((_) {
        // Trigger observation
        list.toList();
        changeCount++;
      });

      list.add(Person('Alice', 25));
      expect(changeCount, equals(2)); // Initial + add

      // Update with same name but different age - should not trigger change
      list[0] = Person('Alice', 30);
      expect(changeCount, equals(2)); // No change due to custom equals

      // Update with different name - should trigger change
      list[0] = Person('Bob', 30);
      expect(changeCount, equals(3)); // Changed

      dispose();
    });

    test('custom equals works with null values', () {
      bool customEquals(String? a, String? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a.toLowerCase() == b.toLowerCase();
      }

      final list = ObservableList<String?>(equals: customEquals);
      list.add(null);
      list.add('Hello');

      var changeCount = 0;
      final dispose = autorun((_) {
        list.toList();
        changeCount++;
      });

      // Same value (null)
      list[0] = null;
      expect(changeCount, equals(1)); // No change

      // Different case but equal according to custom equals
      list[1] = 'HELLO';
      expect(changeCount, equals(1)); // No change

      // Actually different value
      list[1] = 'World';
      expect(changeCount, equals(2)); // Changed

      dispose();
    });

    test('cast preserves custom equals', () {
      bool numEquals(num? a, num? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a.round() == b.round();
      }

      final list = ObservableList<num>(equals: numEquals);
      list.add(1.4);
      list.add(2.6);

      list.cast<int>((int? a, int? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a == b;
      });

      var changeCount = 0;
      final dispose = autorun((_) {
        list.toList();
        changeCount++;
      });

      // Update with value that rounds to same
      list[0] = 1.3;
      expect(changeCount, equals(1)); // No change due to rounding equals

      list[0] = 2.1;
      expect(changeCount, equals(2)); // Changed (rounds to 2, not 1)

      dispose();
    });

    test('first setter uses custom equals', () {
      bool caseInsensitiveEquals(String? a, String? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a.toLowerCase() == b.toLowerCase();
      }

      final list = ObservableList<String>.of(['hello', 'world'],
          equals: caseInsensitiveEquals);

      var changeCount = 0;
      final dispose = autorun((_) {
        list.first;
        changeCount++;
      });

      list.first = 'HELLO'; // Same value with different case
      expect(changeCount, equals(1)); // No change

      list.first = 'goodbye';
      expect(changeCount, equals(2)); // Changed

      dispose();
    });

    test('replaceRange always triggers notifications (bulk operation)', () {
      // Note: replaceRange is a bulk operation that always triggers
      // notifications, even if individual values are equal according to
      // the custom equals function. This is by design for performance.
      bool lengthEquals(String? a, String? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a.length == b.length;
      }

      final list = ObservableList<String>.of(['aa', 'bb', 'cc'],
          equals: lengthEquals);

      var changeCount = 0;
      final dispose = autorun((_) {
        list.toList();
        changeCount++;
      });

      // Replace with same length strings - still triggers notification
      list.replaceRange(0, 2, ['xx', 'yy']);
      expect(changeCount, equals(2)); // Bulk operation always notifies

      // Replace with different length strings
      list.replaceRange(0, 1, ['xxx']);
      expect(changeCount, equals(3)); // Changed

      dispose();
    });

    test('setRange always triggers notifications (bulk operation)', () {
      // Note: setRange is a bulk operation that always triggers
      // notifications, even if values are equal according to custom equals
      bool modEquals(int? a, int? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a % 10 == b % 10;
      }

      final list = ObservableList<int>.of([1, 2, 3, 4], equals: modEquals);

      var changeCount = 0;
      final dispose = autorun((_) {
        list.toList();
        changeCount++;
      });

      // Set range with values that have same mod 10 - still triggers
      list.setRange(0, 2, [11, 12]);
      expect(changeCount, equals(2)); // Bulk operation always notifies

      // Set range with different mod values
      list.setRange(0, 2, [5, 6]);
      expect(changeCount, equals(3)); // Changed

      dispose();
    });
  });

  group('ObservableMap with custom equals', () {
    test('uses custom equals for value comparisons', () {
      bool personNameEquals(Person? a, Person? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a.name == b.name;
      }

      final map = ObservableMap<String, Person>(equals: personNameEquals);
      var changeCount = 0;

      final dispose = autorun((_) {
        map.values.toList();
        changeCount++;
      });

      map['key1'] = Person('Alice', 25);
      expect(changeCount, equals(2)); // Initial + add

      // Update with same name but different age
      map['key1'] = Person('Alice', 30);
      expect(changeCount, equals(2)); // No change due to custom equals

      // Update with different name
      map['key1'] = Person('Bob', 30);
      expect(changeCount, equals(3)); // Changed

      dispose();
    });

    test('custom equals works with null values in map', () {
      bool customEquals(String? a, String? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a.toLowerCase() == b.toLowerCase();
      }

      final map = ObservableMap<String, String?>(equals: customEquals);
      map['key1'] = null;
      map['key2'] = 'Hello';

      var changeCount = 0;
      final dispose = autorun((_) {
        map.values.toList();
        changeCount++;
      });

      // Same value (null)
      map['key1'] = null;
      expect(changeCount, equals(1)); // No change

      // Different case but equal
      map['key2'] = 'HELLO';
      expect(changeCount, equals(1)); // No change

      // Actually different value
      map['key2'] = 'World';
      expect(changeCount, equals(2)); // Changed

      dispose();
    });

    test('cast preserves custom equals in map', () {
      bool numEquals(num? a, num? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a.round() == b.round();
      }

      final map = ObservableMap<String, num>(equals: numEquals);
      map['a'] = 1.4;
      map['b'] = 2.6;

      map.cast<String, int>((int? a, int? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a == b;
      });

      var changeCount = 0;
      final dispose = autorun((_) {
        map.values.toList();
        changeCount++;
      });

      // Update with value that rounds to same
      map['a'] = 1.3;
      expect(changeCount, equals(1)); // No change

      map['a'] = 2.1;
      expect(changeCount, equals(2)); // Changed

      dispose();
    });

    test('addAll uses custom equals', () {
      bool lengthEquals(String? a, String? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a.length == b.length;
      }

      final map = ObservableMap<String, String>(equals: lengthEquals);
      map['a'] = 'xx';
      map['b'] = 'yy';

      var changeCount = 0;
      final dispose = autorun((_) {
        map.values.toList();
        changeCount++;
      });

      // Add values with same length - should not trigger change for existing
      map.addAll({'a': 'aa', 'c': 'zz'});
      expect(changeCount, equals(2)); // Only new key 'c' triggers change
      expect(map['a'], equals('xx')); // Original value preserved

      dispose();
    });
  });

  group('ObservableSet with custom equals', () {
    test('uses custom equals for add operations', () {
      bool caseInsensitiveEquals(String? a, String? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a.toLowerCase() == b.toLowerCase();
      }

      final set = ObservableSet<String>(equals: caseInsensitiveEquals);
      var changeCount = 0;

      final dispose = autorun((_) {
        set.toList();
        changeCount++;
      });

      set.add('hello');
      expect(changeCount, equals(2)); // Initial + add
      expect(set.length, equals(1));

      // Try to add same value with different case
      final added = set.add('HELLO');
      expect(added, isFalse); // Not added due to custom equals
      expect(changeCount, equals(2)); // No change
      expect(set.length, equals(1));

      set.add('world');
      expect(changeCount, equals(3)); // Changed
      expect(set.length, equals(2));

      dispose();
    });

    test('contains uses custom equals', () {
      bool personNameEquals(Person? a, Person? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a.name == b.name;
      }

      final set = ObservableSet<Person>(equals: personNameEquals);
      final alice1 = Person('Alice', 25);
      final alice2 = Person('Alice', 30);
      final bob = Person('Bob', 25);

      set.add(alice1);

      // Contains should use custom equals
      expect(set.contains(alice2), isTrue); // Same name, different age
      expect(set.contains(bob), isFalse);
    });

    test('remove uses custom equals', () {
      bool lengthEquals(String? a, String? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a.length == b.length;
      }

      final set = ObservableSet<String>(equals: lengthEquals);
      set.add('hello');
      set.add('ab');

      var changeCount = 0;
      final dispose = autorun((_) {
        set.toList();
        changeCount++;
      });

      // Remove using different string with same length
      final removed = set.remove('world'); // Same length as 'hello'
      expect(removed, isTrue);
      expect(changeCount, equals(2)); // Changed
      expect(set.length, equals(1));
      expect(set.contains('ab'), isTrue);

      dispose();
    });

    test('lookup uses custom equals', () {
      bool caseInsensitiveEquals(String? a, String? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a.toLowerCase() == b.toLowerCase();
      }

      final set = ObservableSet<String>(equals: caseInsensitiveEquals);
      set.add('Hello');
      set.add('World');

      // Lookup should return the actual stored value
      expect(set.lookup('HELLO'), equals('Hello'));
      expect(set.lookup('world'), equals('World'));
      expect(set.lookup('notfound'), isNull);
    });

    test('cast preserves custom equals in set', () {
      bool numEquals(num? a, num? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a.round() == b.round();
      }

      final set = ObservableSet<num>(equals: numEquals);
      set.add(1.4);
      set.add(2.6);

      set.cast<int>((int? a, int? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a == b;
      });

      expect(set.length, equals(2));

      // Try to add value that rounds to existing
      final added = set.add(1.3);
      expect(added, isFalse); // Not added due to rounding equals
      expect(set.length, equals(2));
    });

    test('addAll uses custom equals', () {
      bool modEquals(int? a, int? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a % 10 == b % 10;
      }

      final set = ObservableSet<int>(equals: modEquals);
      set.add(1);
      set.add(2);

      var changeCount = 0;
      final dispose = autorun((_) {
        set.toList();
        changeCount++;
      });

      // Add values with same mod 10
      set.addAll([11, 22, 3]); // 11 same as 1, 22 same as 2, 3 is new
      expect(changeCount, equals(2)); // Only value 3 triggers change
      expect(set.length, equals(3));

      dispose();
    });
  });

  group('Edge cases and performance', () {
    test('equals function is called efficiently', () {
      var equalsCallCount = 0;
      bool countingEquals(int? a, int? b) {
        equalsCallCount++;
        return a == b;
      }

      final list = ObservableList<int>(equals: countingEquals);
      list.addAll([1, 2, 3]);
      equalsCallCount = 0; // Reset counter

      // Setting same value should call equals once
      list[0] = 1;
      expect(equalsCallCount, equals(1));

      // Setting different value should call equals once
      list[0] = 10;
      expect(equalsCallCount, equals(2));
    });

    test('default behavior when equals is null', () {
      final list1 = ObservableList<String>();
      final list2 = ObservableList<String>(equals: null);

      list1.add('hello');
      list2.add('hello');

      var changes1 = 0;
      var changes2 = 0;

      final d1 = autorun((_) {
        list1.toList();
        changes1++;
      });

      final d2 = autorun((_) {
        list2.toList();
        changes2++;
      });

      list1[0] = 'hello'; // Same value
      list2[0] = 'hello'; // Same value

      expect(changes1, equals(1)); // No change (default equality)
      expect(changes2, equals(1)); // No change (null equals uses default)

      d1();
      d2();
    });

    test('equals with complex nested structures', () {
      bool deepEquals(List<int>? a, List<int>? b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        if (a.length != b.length) return false;
        for (var i = 0; i < a.length; i++) {
          if (a[i] != b[i]) return false;
        }
        return true;
      }

      final list = ObservableList<List<int>>(equals: deepEquals);
      list.add([1, 2, 3]);

      var changeCount = 0;
      final dispose = autorun((_) {
        list.toList();
        changeCount++;
      });

      // Update with equal list (different instance)
      list[0] = [1, 2, 3];
      expect(changeCount, equals(1)); // No change

      // Update with different list
      list[0] = [1, 2, 4];
      expect(changeCount, equals(2)); // Changed

      dispose();
    });
  });
}