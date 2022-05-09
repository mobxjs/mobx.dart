import 'package:build/build.dart';
import 'package:mobx_codegen/mobx_codegen.dart';
import 'package:source_gen/source_gen.dart';

Builder storeGenerator(BuilderOptions options) =>
    SharedPartBuilder([StoreGenerator(options)], 'store_generator');
