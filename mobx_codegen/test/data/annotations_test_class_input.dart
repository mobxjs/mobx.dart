library generator_sample;

import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

class AnnotationsTestClass = AnnotationsTestClassBase
    with _$AnnotationsTestClass;

abstract class AnnotationsTestClassBase with Store {
  AnnotationsTestClassBase(this.foo);

  @observable
  String foo = '';

  @action
  @protected
  @visibleForOverriding
  @visibleForTesting
  void actionAnnotated() {
    foo = 'Action annotated';
  }

  @action
  @protected
  @visibleForOverriding
  @visibleForTesting
  Future<void> asyncActionAnnotated() async {
    foo = 'AsyncAction annotated';
  }

  @action
  @observable
  @protected
  @visibleForOverriding
  @visibleForTesting
  Future<void> observableFutureAnnotated() async {
    foo = 'ObservableFuture annotated';
  }

  @observable
  @protected
  @visibleForOverriding
  @visibleForTesting
  Stream<String> observableStreamAnnotated() async* {
    yield 'ObservableFuture annotated';
  }
}
