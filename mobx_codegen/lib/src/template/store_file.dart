const _analyzerIgnores =
    '// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic';

/// Template for a file containing one or more generated stores.
class StoreFileTemplate {
  Iterable<String> storeSources;

  @override
  String toString() => '''
    $_analyzerIgnores

    ${storeSources.join('\n\n')}
  ''';
}
