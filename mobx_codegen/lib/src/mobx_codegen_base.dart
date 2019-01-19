import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:mobx/src/api/annotations.dart'
    show ComputedMethod, MakeAction, MakeObservable;

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

  final List<String> _actionOverrides = [];

  String get source => """
  class $_className extends $_parentName {
    $_className() : super._() {
      ${_computedMethods.map((m) => m.initComputed).join('\n')}
    }

    ${_observableFields.join('\n')}

    ${_computedMethods.map((m) => m.code).join('\n')}

    ${_actionControllerField}

    ${_actionOverrides.join('\n')}
  }
  """;

  final _observableChecker = TypeChecker.fromRuntime(MakeObservable);

  final _computedChecker = TypeChecker.fromRuntime(ComputedMethod);

  final _actionChecker = TypeChecker.fromRuntime(MakeAction);

  String get _actionControllerField => _actionOverrides.isEmpty
      ? ''
      : "final $_actionControllerName = ActionController(name: '$_parentName');";

  String get _actionControllerName => '_\$${_parentName}ActionController';

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

  @override
  visitMethodElement(MethodElement element) {
    if (!element.isAsynchronous &&
        _actionChecker.hasAnnotationOfExact(element)) {
      final name = element.name;
      final returnType = element.returnType.name;

      String surroundNonEmpty(String prefix, String suffix, String str) =>
          str.isEmpty ? str : '$prefix$str$suffix';

      final typeParams = surroundNonEmpty(
          '<',
          '>',
          element.typeParameters.map((param) {
            if (param.bound == null) {
              return param.name;
            } else {
              return '${param.name} extends ${param.bound}';
            }
          }).join(', '));

      final typeArgs = surroundNonEmpty('<', '>',
          element.typeParameters.map((param) => param.name).join(', '));

      String paramCode(ParameterElement param) => param.defaultValueCode == null
          ? '${param.type.name} ${param.name}'
          : '${param.type.name} ${param.name} = ${param.defaultValueCode}';

      String argCode(ParameterElement param) => param.name;

      final positionalParams = element.parameters
          .where((param) => param.isPositional && !param.isOptionalPositional)
          .toList();
      final positionalParamList = positionalParams.map(paramCode).join(', ');
      final positionalArgs = positionalParams.map(argCode).join(', ');

      final optionalParams = element.parameters
          .where((param) => param.isOptionalPositional)
          .toList();
      final optionalParamList = optionalParams.map(paramCode).join(', ');
      final optionalArgs = optionalParams.map(argCode).join(', ');

      String namedArgCode(ParameterElement param) =>
          '${param.name}: ${param.name}';

      final namedParams =
          element.parameters.where((param) => param.isNamed).toList();
      final namedArgs = namedParams.map(namedArgCode).join(', ');
      final namedParamList = namedParams.map(paramCode).join(', ');

      final params = [
        positionalParamList,
        surroundNonEmpty('[', ']', optionalParamList),
        surroundNonEmpty('{', '}', namedParamList)
      ].where((s) => s.isNotEmpty).join(', ');

      final args = [positionalArgs, optionalArgs, namedArgs]
          .where((s) => s.isNotEmpty)
          .join(', ');

      final code = """
        @override
        $returnType $name$typeParams($params) {
          final _\$prevDerivation = $_actionControllerName.startAction();
          try {
            return super.$name$typeArgs($args);
          } finally {
            $_actionControllerName.endAction(_\$prevDerivation);
          }
        }
      """;

      _actionOverrides.add(code);
    }

    return super.visitMethodElement(element);
  }
}

class ComputedMethodData {
  final String initComputed;
  final String code;

  ComputedMethodData(this.initComputed, this.code);
}
