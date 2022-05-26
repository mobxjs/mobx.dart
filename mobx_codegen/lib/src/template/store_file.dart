const _analyzerIgnores =
    '// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers';

/// Template for a file containing one or more generated stores.
class StoreFileTemplate {
  StoreFileTemplate({required this.storeSources});

  final Iterable<String> storeSources;

  @override
  String toString() => storeSources.isEmpty
      ? ''
      : '''
        $_analyzerIgnores

        ${storeSources.join('\n\n')}
        ''';
}
