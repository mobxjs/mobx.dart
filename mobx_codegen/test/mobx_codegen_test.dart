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

@observable
abstract class User {
  User._();
  factory User() = _\$User;

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
}
""";

const validOutput = """
class _\$User extends User {
  _\$User() : super._() {
    _\$fullNameComputed = Computed(() => super.fullName);
  }

  final _\$firstNameAtom = Atom(name: 'User.firstName');

  @override
  String get firstName {
    _\$firstNameAtom.reportObserved();
    return super.firstName;
  }

  @override
  set firstName(String value) {
    super.firstName = value;
    _\$firstNameAtom.reportChanged();
  }

  final _\$lastNameAtom = Atom(name: 'User.lastName');

  @override
  String get lastName {
    _\$lastNameAtom.reportObserved();
    return super.lastName;
  }

  @override
  set lastName(String value) {
    super.lastName = value;
    _\$lastNameAtom.reportChanged();
  }

  Computed<String> _\$fullNameComputed;

  @override
  String get fullName => _\$fullNameComputed.value;

  final _\$UserActionController = ActionController(name: 'User');

  @override
  void updateNames({String firstName, String lastName}) {
    final _\$prevDerivation = _\$UserActionController.startAction();
    try {
      return super.updateNames(firstName: firstName, lastName: lastName);
    } finally {
      _\$UserActionController.endAction(_\$prevDerivation);
    }
  }
}
""";

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

    test('generates for class with @observer annotation', () async {
      expect(await generate(validInput), endsWith(validOutput));
    });
  });
}

final String pkgName = 'pkg';

// Recreate generator for each test because we repeatedly create
// classes with the same name in the same library, which will clash.
Builder get builder => new PartBuilder([new ObservableGenerator()], '.g.dart');

Future<String> generate(String source) async {
  final srcs = {
    'mobx|lib/src/api/annotations.dart': fakeAnnotationsSource,
    'mobx|lib/mobx.dart': fakeMobxSource,
    '$pkgName|lib/test_user.dart': source,
  };

  // Capture any error from generation; if there is one, return that instead of
  // the generated output.
  String error;
  void captureError(LogRecord logRecord) {
    if (logRecord.error is InvalidGenerationSourceError) {
      if (error != null) throw StateError('Expected at most one error.');
      error = logRecord.error.toString();
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
""";

const fakeMobxSource = """
library mobx;
export 'package:mobx/src/api/annotations.dart';
""";
