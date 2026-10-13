import 'benchmark/options_test.dart' as options_test;
import 'package:test/test.dart';
import 'benchmark/workloads_test.dart' as workloads_test;
import 'regressions/audit_correctness_test.dart' as audit_correctness_test;

import 'benchmark/benchmark_harness_test.dart' as benchmark_harness_test;
import 'regressions/collection_mutation_test.dart' as collection_mutation_test;
import 'regressions/dependency_propagation_test.dart'
    as dependency_propagation_test;
import 'action_controller_test.dart' as action_controller_test;
import 'action_test.dart' as action_test;
import 'annotations_test.dart' as annotations_test;
import 'async_action_test.dart' as async_action_test;
import 'atom_extensions_test.dart' as atom_extensions_test;
import 'atom_test.dart' as atom_test;
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
import 'extensions/primitive_types_extensions_test.dart'
    as extensions_primitive_types_extensions_test;
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
import 'store_test.dart' as store_test;
import 'utils_test.dart' as utils_test;
import 'when_test.dart' as when_test;

void main() {
  group("benchmark options", options_test.main);
  group('benchmark workloads', workloads_test.main);
  group('audit_correctness_test', audit_correctness_test.main);
  group("benchmark_harness_test", benchmark_harness_test.main);
  group("collection_mutation_test", collection_mutation_test.main);
  group("dependency_propagation_test", dependency_propagation_test.main);
  group("observable_test", observable_test.main);
  group("observable_value_test", observable_value_test.main);
  group("computed_test", computed_test.main);

  group("observable_list_test", observable_list_test.main);
  group("observable_map_test", observable_map_test.main);
  group("observable_set_test", observable_set_test.main);
  group("observable_future_test", observable_future_test.main);
  group("observable_stream_test", observable_stream_test.main);

  group("reaction_test", reaction_test.main);
  group("autorun_test", autorun_test.main);
  group("when_test", when_test.main);

  group("context_test", context_test.main);

  group("action_test", action_test.main);
  group("async_action_test", async_action_test.main);
  group("action_controller_test", action_controller_test.main);

  group("exceptions_test", exceptions_test.main);
  group("listenable_test", listenable_test.main);
  group("intercept_test", intercept_test.main);
  group("observe_test", observe_test.main);

  group(
    "extensions_observable_list_extension_test",
    extensions_observable_list_extension_test.main,
  );
  group(
    "extensions_observable_map_extension_test",
    extensions_observable_map_extension_test.main,
  );
  group(
    "extensions_observable_set_extension_test",
    extensions_observable_set_extension_test.main,
  );
  group(
    "extensions_observable_future_extension_test",
    extensions_observable_future_extension_test.main,
  );
  group(
    "extensions_observable_stream_extension_test",
    extensions_observable_stream_extension_test.main,
  );
  group(
    "extensions_primitive_types_extensions_test",
    extensions_primitive_types_extensions_test.main,
  );
  group("atom_extensions_test", atom_extensions_test.main);

  group("bug_related_test", bug_related_test.main);
  group("reactive_policies_test", reactive_policies_test.main);
  group("annotations_test", annotations_test.main);

  group("spy_test", spy_test.main);
  group("store_test", store_test.main);

  group("atom_test", atom_test.main);
  group("utils_test", utils_test.main);
}
