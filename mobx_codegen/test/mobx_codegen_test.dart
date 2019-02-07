import 'package:build/build.dart';
import 'package:logging/logging.dart';
import 'package:mobx_codegen/mobx_codegen.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build_test/build_test.dart';
import 'package:test/test.dart';

const validInput = """
library test_user;

import 'package:mobx/mobx.dart';

part 'test_user.g.dart';

class User = UserBase with _\$User;

abstract class UserBase implements Store {
  UserBase(this.id);

  final int id;

  @observable
  String firstName = 'Jane';

  @observable
  String lastName = 'Doe';

  @computed
  String get fullName => '\$firstName \$lastName';

  @action
  void updateNames({String firstName, String lastName}) {
    if (firstName != null) this.firstName = firstName;
    if (lastName != null) this.lastName = firstName;
  }

  @observable
  Future<String> foobar() async {
    return 'foobar';
  }

  @observable
  Stream<T> loadStuff<T>(String arg1, {T value}) async* {
    yield value;
  }
}
""";

const validOutput = """
mixin _\$User on UserBase, Store {
  Computed<String> _\$fullNameComputed;

  @override
  String get fullName =>
      (_\$fullNameComputed ??= Computed<String>(() => super.fullName)).value;

  final _\$firstNameAtom = Atom(name: 'UserBase.firstName');

  @override
  String get firstName {
    _\$firstNameAtom.reportObserved();
    return super.firstName;
  }

  @override
  set firstName(String value) {
    mainContext.checkIfStateModificationsAreAllowed(_\$firstNameAtom);
    super.firstName = value;
    _\$firstNameAtom.reportChanged();
  }

  final _\$lastNameAtom = Atom(name: 'UserBase.lastName');

  @override
  String get lastName {
    _\$lastNameAtom.reportObserved();
    return super.lastName;
  }

  @override
  set lastName(String value) {
    mainContext.checkIfStateModificationsAreAllowed(_\$lastNameAtom);
    super.lastName = value;
    _\$lastNameAtom.reportChanged();
  }

  @override
  ObservableFuture<String> foobar() {
    final _\$future = super.foobar();
    return ObservableFuture<String>(_\$future);
  }

  @override
  ObservableStream<T> loadStuff<T>(String arg1, {T value}) {
    final _\$stream = super.loadStuff<T>(arg1, value: value);
    return ObservableStream<T>(_\$stream);
  }

  final _\$UserBaseActionController = ActionController(name: 'UserBase');

  @override
  void updateNames({String firstName, String lastName}) {
    final _\$actionInfo = _\$UserBaseActionController.startAction();
    try {
      return super.updateNames(firstName: firstName, lastName: lastName);
    } finally {
      _\$UserBaseActionController.endAction(_\$actionInfo);
    }
  }
}
""";

const invalidInput = """
library test_user;

import 'package:mobx/mobx.dart';

part 'test_user.g.dart';

class User = UserBase with _\$User;

abstract class UserBase implements Store {
  UserBase(this.id);

  @observable
  final int id;

  @observable
  final String firstName = 'Jane';

  @observable
  String lastName = 'Doe';

  @computed
  String get fullName => '\$firstName \$lastName';

  @observable
  static int foobar = 123;

  @action
  void updateNames({String firstName, String lastName}) {
    if (firstName != null) this.firstName = firstName;
    if (lastName != null) this.lastName = firstName;
  }

  @action
  static UserBase getUser(int id) async {}

  @observable
  String nonAsyncObservableMethod() {
    return 'nonAsyncObservableMethod';
  }
}
""";

const invalidOutput = """
Could not make class "User" observable. Changes needed:
  1. Remove static modifier from the field "foobar"
  2. Remove static modifier from the method "getUser"
  3. Remove final modifier from fields "id" and "firstName"
  4. Return a Future or a Stream from the method "nonAsyncObservableMethod\"""";

void main() {
  group('generator', () {
    test('ignores empty library', () async {
      expect(await generate(''), isEmpty);
    });

    test('ignores non-annotated class', () async {
      const source = """
        class MyClass {
          void foobar() => 'Hello';
        }
      """;

      expect(await generate(source), isEmpty);
    });

    test('generates for a class that implements Store', () async {
      expect(await generate(validInput), endsWith(validOutput));
    });

    test('invalid output', () async {
      expect(await generate(invalidInput), endsWith(invalidOutput));
    });
  });
}

final String pkgName = 'pkg';

// Recreate generator for each test because we repeatedly create
// classes with the same name in the same library, which will clash.
Builder get builder => new PartBuilder([new StoreGenerator()], '.g.dart');

Future<String> generate(String source) async {
  final srcs = {
    'mobx|lib/src/api/annotations.dart': fakeAnnotationsSource,
    'mobx|lib/mobx.dart': fakeMobxSource,
    '$pkgName|lib/test_user.dart': source,
  };

  String error;
  void captureError(LogRecord logRecord) {
    if (logRecord.level == Level.SEVERE) {
      error = logRecord.message;
    }
  }

  final writer = new InMemoryAssetWriter();
  await testBuilder(builder, srcs,
      rootPackage: pkgName, writer: writer, onLog: captureError);
  return error ??
      new String.fromCharCodes(
          writer.assets[new AssetId(pkgName, 'lib/test_user.g.dart')] ?? []);
}

// Just needs the annotations for the tests
const fakeAnnotationsSource = """
class MakeObservable {
  const MakeObservable._();
}

const MakeObservable observable = MakeObservable._();

class ComputedMethod {
  const ComputedMethod._();
}

const ComputedMethod computed = ComputedMethod._();

class MakeAction {
  const MakeAction._();
}

const MakeAction action = MakeAction._();

abstract class Store {}
""";

const fakeMobxSource = """
library mobx;

export 'package:mobx/src/api/annotations.dart';
""";
