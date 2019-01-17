import 'package:build/build.dart';
import 'package:mobx_codegen/mobx_codegen.dart';
import 'package:source_gen/source_gen.dart';

Builder observableGenerator(BuilderOptions options) =>
    SharedPartBuilder([ObservableGenerator()], 'observable_generator');
