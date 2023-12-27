import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:mobx_lint/src/mobx_custom_lint.dart';

import '../mobx_types.dart';

/// Right above "wrap in builder"
const wrapPriority = 28;

class WrapWithObserver extends MobxAssist {
  WrapWithObserver();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      // Select from "new" to the opening bracket
      if (!target.intersects(node.constructorName.sourceRange)) return;

      final createdType = node.constructorName.type.type;

      if (createdType == null ||
          !widgetType.isAssignableFromType(createdType)) {
        return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Wrap with Observer',
        priority: wrapPriority,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleInsertion(
          node.offset,
          'Observer(builder: (context) { return ',
        );
        builder.addSimpleInsertion(node.end, '; },)');
      });
    });
  }
}
