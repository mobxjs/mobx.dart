import 'package:mobx/mobx.dart';

// The mixin will be generated in memory and used during tests
class Test = _Test with _$Test;

abstract class _Test with Store {
  @observable
  String firstName = 'Pavan';

  @observable
  String lastName = 'Podila';

  // Invalid observable annotations //
  @observable
  String get fullName => '$firstName $lastName';
}
