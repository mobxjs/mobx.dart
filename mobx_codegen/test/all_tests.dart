import 'errors_test.dart' as errors_test;
import 'generator_usage_test.dart' as generator_usage_test;
import 'invalid_annotations_test.dart' as invalid_annotations_test;
import 'mobx_codegen_test.dart' as mobx_codegen_test;
import 'templates_test.dart' as templates_test;
import 'util_test.dart' as util_test;

void main() {
  generator_usage_test.main();
  errors_test.main();
  invalid_annotations_test.main();
  templates_test.main();
  mobx_codegen_test.main();
  util_test.main();
}
