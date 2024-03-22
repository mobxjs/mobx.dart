import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:mobx_lint/src/assists/wrap_with_observer.dart';
import 'package:test/test.dart';

import '../../golden.dart';

void main() {
  testGolden(
    'Wrap with observer',
    'assists/wrap_widget/wrap_with_observer.json',
    () async {
      final assist = WrapWithObserver();
      final file = File('test/assists/wrap_widget/wrap_widget.dart').absolute;

      final result = await resolveFile2(path: file.path);
      result as ResolvedUnitResult;

      var changes = [
        // Map
        ...await assist.testRun(result, const SourceRange(171, 0)),

        // Scaffold
        ...await assist.testRun(result, const SourceRange(190, 0)),

        // Container
        ...await assist.testRun(result, const SourceRange(212, 0)),

        // Between ()
        ...await assist.testRun(result, const SourceRange(222, 0)),
      ];

      changes.forEach((element) {
        print(element);
      });

      expect(changes, hasLength(2));

      return changes;
    },
  );
}
