import 'package:mobx/mobx.dart';
import 'package:mockito/mockito.dart';

class MockContext extends Mock implements ReactiveContext {
  @override
  int computationDepth = 0;
}

class MockAtom extends Mock implements Atom {}
