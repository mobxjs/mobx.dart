import 'package:mobx/mobx.dart' as mobx;
import 'package:mockito/mockito.dart';

class MockState extends Mock implements mobx.ReactiveState {}

class MockContext extends Mock implements mobx.ReactiveContext {
  final MockState _state = MockState();
}

class MockAtom extends Mock implements mobx.Atom {}
