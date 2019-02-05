import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';
import 'package:mockito/mockito.dart';

class MockState extends Mock implements ReactiveState {}

class MockContext extends Mock implements ReactiveContext {
  @override
  int computationDepth = 0;
}

class MockAtom extends Mock implements Atom {
  @override
  final Set<Derivation> _observers = Set();
}
