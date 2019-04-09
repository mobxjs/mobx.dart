// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hitimer_stores.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies

mixin _$Exercise on _Exercise, Store {
  final _$nameAtom = Atom(name: '_Exercise.name');

  @override
  String get name {
    _$nameAtom.reportObserved();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.context.checkIfStateModificationsAreAllowed(_$nameAtom);
    super.name = value;
    _$nameAtom.reportChanged();
  }

  final _$descriptionAtom = Atom(name: '_Exercise.description');

  @override
  String get description {
    _$descriptionAtom.reportObserved();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.context
        .checkIfStateModificationsAreAllowed(_$descriptionAtom);
    super.description = value;
    _$descriptionAtom.reportChanged();
  }

  final _$secondsAtom = Atom(name: '_Exercise.seconds');

  @override
  int get seconds {
    _$secondsAtom.reportObserved();
    return super.seconds;
  }

  @override
  set seconds(int value) {
    _$secondsAtom.context.checkIfStateModificationsAreAllowed(_$secondsAtom);
    super.seconds = value;
    _$secondsAtom.reportChanged();
  }
}

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies

mixin _$Routine on _Routine, Store {
  final _$nameAtom = Atom(name: '_Routine.name');

  @override
  String get name {
    _$nameAtom.reportObserved();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.context.checkIfStateModificationsAreAllowed(_$nameAtom);
    super.name = value;
    _$nameAtom.reportChanged();
  }

  final _$descriptionAtom = Atom(name: '_Routine.description');

  @override
  String get description {
    _$descriptionAtom.reportObserved();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.context
        .checkIfStateModificationsAreAllowed(_$descriptionAtom);
    super.description = value;
    _$descriptionAtom.reportChanged();
  }

  final _$exerciseRestingSecondsAtom =
      Atom(name: '_Routine.exerciseRestingSeconds');

  @override
  int get exerciseRestingSeconds {
    _$exerciseRestingSecondsAtom.reportObserved();
    return super.exerciseRestingSeconds;
  }

  @override
  set exerciseRestingSeconds(int value) {
    _$exerciseRestingSecondsAtom.context
        .checkIfStateModificationsAreAllowed(_$exerciseRestingSecondsAtom);
    super.exerciseRestingSeconds = value;
    _$exerciseRestingSecondsAtom.reportChanged();
  }

  final _$repetitionRestingSecondsAtom =
      Atom(name: '_Routine.repetitionRestingSeconds');

  @override
  int get repetitionRestingSeconds {
    _$repetitionRestingSecondsAtom.reportObserved();
    return super.repetitionRestingSeconds;
  }

  @override
  set repetitionRestingSeconds(int value) {
    _$repetitionRestingSecondsAtom.context
        .checkIfStateModificationsAreAllowed(_$repetitionRestingSecondsAtom);
    super.repetitionRestingSeconds = value;
    _$repetitionRestingSecondsAtom.reportChanged();
  }
}

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies

mixin _$Workout on _Workout, Store {}
