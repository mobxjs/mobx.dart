#!/usr/bin/env dart

import 'dart:io';

void main() {
  final pubspecFile = File('${Directory.current.path}/pubspec.yaml');

  final projectData = pubspecFile.readAsStringSync();
  final versionNumber = resolveVersion(projectData);

  if (versionNumber == null) {
    final package = Directory.current.path.split("/").last;
    print('Failed to fetch version for $package');
    exit(1);
  }

  final versionText = generateVersionScript(versionNumber);

  final versionFile = File('${Directory.current.path}/lib/version.dart');
  versionFile.writeAsStringSync(versionText);
}

String generateVersionScript(String versionNumber) => """
// Generated via set_version.dart. !!!DO NOT MODIFY BY HAND!!!

/// The current version as per `pubspec.yaml`.
const version = '$versionNumber';
""";

String? resolveVersion(String projectData) =>
    RegExp('version: (.*)').firstMatch(projectData)?.group(1);
