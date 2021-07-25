import 'package:mobx/mobx.dart';
import 'package:mocktail/mocktail.dart';

class MockContext extends Mock implements ReactiveContext {
  // @override
  // bool get isSpyEnabled => true;
  //
  // @override
  // String nameFor(String prefix) => '${prefix}Test-When';
  //
  // @override
  // bool startAllowStateChanges({bool allow = true}) => allow;
}

class MockAtom extends Mock implements Atom {
  MockAtom() : context = MockContext();

  @override
  MockContext context;
}

class MockActionController extends Mock implements ActionController {}

class MockDerivation extends Mock implements Derivation {}

class FakeActionRunInfo extends Fake implements ActionRunInfo {}

class MockActionRunInfo extends Mock implements ActionRunInfo {}
