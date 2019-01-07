import 'action_test.dart' as action_test;
import 'autorun_test.dart' as autorun_test;
import 'computed_test.dart' as computed_test;
import 'derivation_tracker_test.dart' as derivation_tracker_test;
import 'intercept_test.dart' as intercept_test;
import 'listenable_test.dart' as listenable_test;
import 'observable_test.dart' as observable_test;
import 'observe_test.dart' as observe_test;
import 'reaction_test.dart' as reaction_test;
import 'when_test.dart' as when_test;

void main() {
  observable_test.main();
  computed_test.main();
  action_test.main();
  reaction_test.main();
  autorun_test.main();
  when_test.main();
  observe_test.main();
  intercept_test.main();
  listenable_test.main();
  derivation_tracker_test.main();
}
