abstract class CodegenError {
  bool get hasErrors;
  String get message;
}

class StoreClassCodegenErrors implements CodegenError {
  StoreClassCodegenErrors(this.name) {
    _errorCategories = [
      wronglyAnnotatedComputedFields,
      wronglyAnnotatedObservableFields,
      staticObservables,
      staticMethods,
      finalObservables,
      asyncGeneratorActions,
      nonAsyncMethods,
    ];
  }

  final String name;

  final PropertyErrors finalObservables = FinalObservableFields();
  final PropertyErrors staticObservables = StaticObservableFields();
  final PropertyErrors staticMethods = InvalidStaticMethods();
  final PropertyErrors asyncGeneratorActions = AsyncGeneratorActionMethods();
  final PropertyErrors nonAsyncMethods = NonAsyncMethods();
  final PropertyErrors wronglyAnnotatedComputedFields =
      WronglyAnnotatedComputedFields();
  final PropertyErrors wronglyAnnotatedObservableFields =
      WronglyAnnotatedObservableFields();

  List<CodegenError> _errorCategories;

  @override
  String get message {
    final errors = _errorCategories
        .where((category) => category.hasErrors)
        .toList(growable: false)
        .asMap()
        .map((i, category) => MapEntry(i, '  ${i + 1}. ${category.message}'))
        .values
        .join('\n');

    return 'Could not make class "$name" observable. Changes needed:\n$errors';
  }

  @override
  bool get hasErrors => _errorCategories.any((category) => category.hasErrors);
}

const fieldPluralizer = Pluralize('the field', 'fields');
const methodPluralizer = Pluralize('the method', 'methods');
const getterPluralizer = Pluralize('the getter', 'getters');

abstract class PropertyErrors implements CodegenError {
  final NameList _properties = NameList();

  // ignore: avoid_positional_boolean_parameters
  bool addIf(bool condition, String propertyName) {
    if (condition) {
      _properties.add(propertyName);
    }
    return condition;
  }

  String get propertyList => _properties.toString();

  Pluralize propertyPlural = fieldPluralizer;

  String get property => propertyPlural(_properties.length);

  @override
  bool get hasErrors => _properties.isNotEmpty;
}

class FinalObservableFields extends PropertyErrors {
  @override
  String get message => 'Remove final modifier from $property $propertyList.';
}

class StaticObservableFields extends PropertyErrors {
  @override
  String get message => 'Remove static modifier from $property $propertyList.';
}

class AsyncGeneratorActionMethods extends PropertyErrors {
  @override
  // ignore: overridden_fields
  Pluralize propertyPlural = methodPluralizer;

  @override
  String get message =>
      'Replace async* modifier with async from $property $propertyList.';
}

class NonAsyncMethods extends PropertyErrors {
  @override
  // ignore: overridden_fields
  Pluralize propertyPlural = methodPluralizer;

  @override
  String get message =>
      'Return a Future or a Stream from $property $propertyList.';
}

class WronglyAnnotatedComputedFields extends PropertyErrors {
  @override
  String get message =>
      'Remove @computed annotation for $property $propertyList. They only apply to property-getters.';
}

class WronglyAnnotatedObservableFields extends PropertyErrors {
  @override
  // ignore: overridden_fields
  Pluralize propertyPlural = getterPluralizer;

  @override
  String get message =>
      'Remove @observable annotation for $property $propertyList. They only apply to fields.';
}

class InvalidStaticMethods extends PropertyErrors {
  @override
  // ignore: overridden_fields
  Pluralize propertyPlural = methodPluralizer;

  @override
  String get message => 'Remove static modifier from $property $propertyList.';
}

class NameList {
  final List<String> _names = [];

  void add(String name) => _names.add(name);

  int get length => _names.length;

  bool get isNotEmpty => _names.isNotEmpty;

  @override
  String toString() {
    if (_names.length == 1) {
      return '"${_names[0]}"';
    }

    final buf = StringBuffer();
    for (var i = 0; i < _names.length; i++) {
      final name = _names[i];
      buf.write('"$name"');
      if (i < _names.length - 2) {
        buf.write(', ');
      } else if (i == _names.length - 2) {
        buf.write(' and ');
      }
    }
    return buf.toString();
  }
}

class Pluralize {
  const Pluralize(this._single, this._multiple);

  final String _single;
  final String _multiple;

  String call(int count) => count == 1 ? _single : _multiple;
}
