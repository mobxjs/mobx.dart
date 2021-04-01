import 'package:mobx/mobx.dart';
import 'package:mockito/mockito.dart';

class MockContext extends Mock implements ReactiveContext {
  @override
  bool get isSpyEnabled => true;

  @override
  String nameFor(String prefix) => '${prefix}Test-When';
}

class MockAtom extends Mock implements Atom {
  MockAtom() : context = MockContext();

  @override
  MockContext context;
}

class MockActionController extends Mock implements ActionController {}

class MockDerivation extends Mock implements Derivation {}
