import 'action_controller_test.dart' as action_controller_test;
import 'action_test.dart' as action_test;
import 'annotations_test.dart' as annotations_test;
import 'async_action_test.dart' as async_action_test;
import 'autorun_test.dart' as autorun_test;
import 'bug_related_test.dart' as bug_related_test;
import 'computed_test.dart' as computed_test;
import 'context_test.dart' as context_test;
import 'exceptions_test.dart' as exceptions_test;
import 'extensions/observable_future_extension_test.dart'
    as extensions_observable_future_extension_test;
import 'extensions/observable_list_extension_test.dart'
    as extensions_observable_list_extension_test;
import 'extensions/observable_map_extension_test.dart'
    as extensions_observable_map_extension_test;
import 'extensions/observable_set_extension_test.dart'
    as extensions_observable_set_extension_test;
import 'extensions/observable_stream_extension_test.dart'
    as extensions_observable_stream_extension_test;
import 'intercept_test.dart' as intercept_test;
import 'listenable_test.dart' as listenable_test;
import 'observable_future_test.dart' as observable_future_test;
import 'observable_list_test.dart' as observable_list_test;
import 'observable_map_test.dart' as observable_map_test;
import 'observable_set_test.dart' as observable_set_test;
import 'observable_stream_test.dart' as observable_stream_test;
import 'observable_test.dart' as observable_test;
import 'observable_value_test.dart' as observable_value_test;
import 'observe_test.dart' as observe_test;
import 'reaction_test.dart' as reaction_test;
import 'reactive_policies_test.dart' as reactive_policies_test;
import 'spy_test.dart' as spy_test;
import 'when_test.dart' as when_test;

void main() {
  observable_test.main();
  observable_value_test.main();
  computed_test.main();

  observable_list_test.main();
  observable_map_test.main();
  observable_set_test.main();
  observable_future_test.main();
  observable_stream_test.main();

  reaction_test.main();
  autorun_test.main();
  when_test.main();

  context_test.main();

  action_test.main();
  async_action_test.main();
  action_controller_test.main();

  exceptions_test.main();
  listenable_test.main();
  intercept_test.main();
  observe_test.main();

  extensions_observable_list_extension_test.main();
  extensions_observable_map_extension_test.main();
  extensions_observable_set_extension_test.main();
  extensions_observable_future_extension_test.main();
  extensions_observable_stream_extension_test.main();

  bug_related_test.main();
  reactive_policies_test.main();
  annotations_test.main();

  spy_test.main();
}
