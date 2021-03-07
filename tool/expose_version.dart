#!/usr/bin/env dart

import 'dart:io';

void main(List<String> packages) {
  for (var package in packages) {
    final libraryFile = File('./$package/lib/$package.dart');
    final content = libraryFile.readAsStringSync();
    final strippedContent = stripVersion(content);

    final pubspecFile = File('./$package/pubspec.yaml');
    final projectData = pubspecFile.readAsStringSync();
    final versionNumber = resolveVersion(projectData);

    if (versionNumber == null) {
      print('Failed to fetch version for $package');
      continue;
    }

    final versionVariable = createVersionVariable(versionNumber);

    libraryFile.writeAsStringSync('$strippedContent\n$versionVariable\n');
  }
}

String createVersionVariable(String versionNumber) =>
    "const version = '$versionNumber';";

String? resolveVersion(String projectData) =>
    RegExp('version: (.*)').firstMatch(projectData)?.group(1);

String stripVersion(String content) =>
    content.replaceAll(RegExp("\nconst version = '.*';\n"), '');
