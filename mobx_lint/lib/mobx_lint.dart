library mobx_lint;

import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/assists/wrap_with_observer.dart';

PluginBase createPlugin() => _MobxPlugin();

class _MobxPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [];

  @override
  List<Assist> getAssists() => [
        WrapWithObserver(),
      ];
}
