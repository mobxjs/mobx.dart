import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:mobx/mobx.dart' show ComputedMethod, MakeObservable;

class ObservableGenerator extends GeneratorForAnnotation<MakeObservable> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element.kind == ElementKind.CLASS) {
      final visitor = new ObservableClassVisitor(element.name);
      element.visitChildren(visitor);
      return visitor.source;
    }
    return null;
  }
}

class ObservableClassVisitor extends SimpleElementVisitor {
  ObservableClassVisitor(this._parentName) : _className = '_\$$_parentName';

  final String _parentName;
  final String _className;

  final List<String> _observableFields = [];

  final List<ComputedMethodData> _computedMethods = [];

  String get source => """
  class $_className extends $_parentName {
    $_className() : super._() {
      ${_computedMethods.map((m) => m.initComputed).join('\n')}
    }

    ${_observableFields.join('\n')}

    ${_computedMethods.map((m) => m.code).join('\n')}
  }
  """;

  final _observableChecker = TypeChecker.fromRuntime(MakeObservable);

  final _computedChecker = TypeChecker.fromRuntime(ComputedMethod);

  @override
  visitFieldElement(FieldElement element) async {
    if (!element.isFinal && _observableChecker.hasAnnotationOfExact(element)) {
      final type = element.type.name;
      final name = element.name;
      final privateName = '_\$${name}Atom';

      _observableFields.add("""
      final $privateName = Atom(name: '$_parentName.$name');

      @override
      $type get $name {
        $privateName.reportObserved();
        return super.$name;
      }

      @override
      set $name($type value) {
        super.$name = value;
        $privateName.reportChanged();
      }
      """);
    }
    return null;
  }

  @override
  visitPropertyAccessorElement(PropertyAccessorElement element) {
    if (element.isGetter && _computedChecker.hasAnnotationOfExact(element)) {
      final type = element.returnType.name;
      final name = element.name;
      final privateName = '_\$${name}Computed';

      final initComputed = "$privateName = Computed(() => super.$name);";

      final code = """
        Computed<$type> $privateName;

        @override
        $type get $name => $privateName.value;
      """;

      _computedMethods.add(new ComputedMethodData(initComputed, code));
    }
    return null;
  }
}

class ComputedMethodData {
  final String initComputed;
  final String code;

  ComputedMethodData(this.initComputed, this.code);
}
