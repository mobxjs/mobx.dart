#!/usr/bin/env dart

import 'dart:io';

void main() {
  final packagePath = Directory.current.path;
  final packageName = Directory.current.path.split("/").last;
  final pubspecFile = File('$packagePath/pubspec.yaml');

  final projectData = pubspecFile.readAsStringSync();
  final versionNumber = resolveVersion(projectData);

  if (versionNumber == null) {
    print('Failed to fetch version for $packageName');
    exit(1);
  }

  final versionText = generateVersionScript(versionNumber);

  final versionFile = File('$packagePath/lib/version.dart');
  versionFile.writeAsStringSync(versionText);
}

String generateVersionScript(String versionNumber) => """
// Generated via set_version.dart. !!!DO NOT MODIFY BY HAND!!!

/// The current version as per `pubspec.yaml`.
const version = '$versionNumber';
""";

String? resolveVersion(String projectData) =>
    RegExp('version: (.*)').firstMatch(projectData)?.group(1);
