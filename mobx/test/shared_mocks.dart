import 'package:mobx/mobx.dart';
import 'package:mockito/mockito.dart';

class MockContext extends Mock implements ReactiveContext {
  @override
  bool get isSpyEnabled => true;
}

class MockAtom extends Mock implements Atom {
  MockAtom() {
    context = MockContext();
  }

  @override
  MockContext context;
}

class MockActionController extends Mock implements ActionController {}
